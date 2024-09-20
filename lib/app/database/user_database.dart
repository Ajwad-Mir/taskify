import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/global/helper/connection_helper.dart';

class UserDatabase {
  static final UserDatabase _instance = UserDatabase._internal();

  factory UserDatabase() => _instance;

  UserDatabase._internal();

  late Box<UserModel> _userBox;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>('users');
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncUsers();
      }
    });
  }

  Future<UserModel?> register(String fullName, String email, String password) async {
    if (await _isEmailRegisteredLocally(email)) {
      SmartDialog.showToast('Email already exists');
      return null;
    }

    if (await ConnectionHelper.hasNoConnectivity()) {
      return await _registerLocally(fullName, email, password);
    } else {
      return await _registerWithFirebase(fullName, email, password);
    }
  }

  Future<UserModel?> login(String email, String password) async {
    if (await ConnectionHelper.hasNoConnectivity()) {
      return _loginLocally(email, password);
    } else {
      return await _loginWithFirebase(email, password);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = await GetStorage().read('currentUserID');
    if (userId == null) return null;

    UserModel? localUser = _userBox.get(userId);

    if (localUser == null) return null;

    if (await ConnectionHelper.hasNoConnectivity()) {
      return localUser;
    } else {
      try {
        User? firebaseUser = _auth.currentUser;

        if (firebaseUser == null) {
          // Firebase user does not exist, create Firebase account using local data
          UserCredential newFirebaseUser = await _auth.createUserWithEmailAndPassword(
            email: localUser.email,
            password: localUser.password,
          );

          // Sync local user data to Firebase Firestore
          UserModel updatedUser = localUser.copyWith(id: newFirebaseUser.user!.uid);
          await _saveUserToBothLocalAndFirebase(updatedUser);
          await GetStorage().write('currentUserID', updatedUser.id);

          SmartDialog.showToast('User synced to Firebase');
          return updatedUser;
        } else {

          UserCredential existingFirebaseUser = await _auth.signInWithEmailAndPassword(
            email: localUser.email,
            password: localUser.password,
          );
          // Firebase user exists, sync data
          final userDoc = await _firestore.collection('users').doc(existingFirebaseUser.user!.uid).get();

          if (!userDoc.exists) {
            // If the user does not exist in Firestore, sync the local data to Firestore
            await _saveUserToBothLocalAndFirebase(localUser.copyWith(id: existingFirebaseUser.user!.uid));
          }

          // Sync user data from Firebase to local storage
          UserModel firebaseUserData = await _syncUserDataFromFirebase(existingFirebaseUser.user!.uid);

          // Update local data with the synced Firebase data
          await _userBox.put(existingFirebaseUser.user!.uid, firebaseUserData);
          return firebaseUserData;
        }
      } catch (e) {
        SmartDialog.showToast('Error checking Firebase account: ${e.toString()}');
        return localUser;
      }
    }
  }

  Future<UserModel?> updateUser({required UserModel updatingUser}) async {
    UserModel? user = _userBox.get(updatingUser.id);
    if (user == null) return null;

    await _userBox.put(updatingUser.id, updatingUser);

    if (!await ConnectionHelper.hasNoConnectivity()) {
      await _updateUserInFirebase(updatingUser.id, updatingUser);
    }
    return updatingUser;
  }

  Future<void> logout() async {
    await GetStorage().write('currentUserID', null);
    await _auth.signOut();
  }

  Future<void> syncUsers() async {
    if (await ConnectionHelper.hasNoConnectivity()) return;
    await _syncLocalToFirebase();
    await _syncFirebaseToLocal();
  }

  Future<bool> _isEmailRegisteredLocally(String email) async {
    return _userBox.values.any((user) => user.email == email);
  }

  Future<UserModel?> _registerLocally(String fullName, String email, String password) async {
    final newUser = UserModel(
      id: _generateCustomUid(28),
      fullName: fullName,
      email: email,
      password: password,
    );
    await _userBox.put(newUser.id, newUser);
    await GetStorage().write('currentUserID', newUser.id);

    // Check if internet is restored to sync user with Firebase
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        try {
          UserCredential firebaseUser = await _auth.createUserWithEmailAndPassword(
            email: newUser.email,
            password: newUser.password,
          );

          // Sync the local user to Firebase
          await _saveUserToBothLocalAndFirebase(newUser.copyWith(id: firebaseUser.user!.uid));
          await GetStorage().write('currentUserID', firebaseUser.user!.uid);

          SmartDialog.showToast('User synced to Firebase');
        } catch (e) {
          SmartDialog.showToast('Error syncing user to Firebase: ${e.toString()}');
        }
      }
    });

    return newUser;
  }

  Future<UserModel?> _registerWithFirebase(String fullName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        password: password,
      );
      await GetStorage().write('currentUserID', userCredential.user!.uid);

      await _saveUserToBothLocalAndFirebase(newUser);
      return newUser;
    } catch (e) {
      SmartDialog.showToast('Registration failed: ${e.toString()}');
      return null;
    }
  }

  Future<UserModel?> _loginLocally(String email, String password) async {
    UserModel? localUser = _userBox.values.firstWhere(
          (user) => user.email == email && user.password == password,
      orElse: () => UserModel.empty(),
    );

    if (localUser != UserModel.empty()) {
      await GetStorage().write('currentUserID', localUser.id);
      return localUser;
    } else {
      SmartDialog.showToast('Invalid email and/or password');
      return null;
    }
  }

  Future<UserModel?> _loginWithFirebase(String email, String password) async {
    try {
      // First, check if the user exists in Firebase Authentication
      UserCredential? userCredential;
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // If sign in fails, handle the error
        SmartDialog.showToast('Login failed: ${e.toString()}');
        return null;
      }

      // Check if the user exists in Firestore
      QuerySnapshot userQuery = await _firestore.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (userQuery.docs.isNotEmpty) {
        // User exists in Firestore, update local user with Firestore data
        UserModel firestoreUser = UserModel.fromMap(userQuery.docs.first.data() as Map<String, dynamic>);
        await _userBox.put(firestoreUser.id, firestoreUser);
        await GetStorage().write('currentUserID', firestoreUser.id);
        return firestoreUser;
      } else {
        // User exists in Firebase Auth but not in Firestore or Hive
        UserModel newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          fullName: userCredential.user!.displayName ?? 'Existing User',
          password: password,
        );

        // Save new user to both Firestore and local storage
        await _saveUserToBothLocalAndFirebase(newUser);
        await GetStorage().write('currentUserID', newUser.id);
        SmartDialog.showToast('User profile created and synced to Firestore');
        return newUser;
      }
    } catch (e) {
      SmartDialog.showToast('Login failed: ${e.toString()}');
      return null;
    }
  }


  Future<void> _saveUserToBothLocalAndFirebase(UserModel user) async {
    await _userBox.put(user.id, user);
    await _firestore.collection('users').doc(user.id).set(user.toMap());
    await GetStorage().write('currentUserID', user.id);
  }

  Future<void> _updateUserInFirebase(String userId, UserModel updatedUser) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      await currentUser?.updateProfile(displayName: updatedUser.fullName);
      await currentUser?.updatePassword(updatedUser.password);
      await currentUser?.verifyBeforeUpdateEmail(updatedUser.email);
      await _firestore.collection('users').doc(userId).update(updatedUser.toMap());

    } catch (e) {
      if (kDebugMode) {
        print('Error updating user in Firebase: $e');
      }
    }
  }
  Future<void> _syncLocalToFirebase() async {
    for (var user in _userBox.values) {
      try {
        // Check if user exists in Firebase Auth
        List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(user.email);
        bool userExistsInAuth = signInMethods.isNotEmpty;

        // Check if user exists in Firestore
        DocumentSnapshot<Map<String, dynamic>> firestoreDoc =
        await _firestore.collection('users').doc(user.id).get();
        bool userExistsInFirestore = firestoreDoc.exists;

        if (userExistsInAuth) {
          // User exists in Firebase Auth
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

          String firebaseUid = userCredential.user!.uid;

          if (user.id != firebaseUid) {
            // Update local user ID to match Firebase Auth UID
            await _updateLocalUserId(user, firebaseUid);
          }

          if (!userExistsInFirestore) {
            // User exists in Auth but not in Firestore, so add to Firestore
            await _firestore.collection('users').doc(firebaseUid).set(user.toMap());
          }
        } else {
          // User doesn't exist in Firebase Auth, create new account
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

          String firebaseUid = userCredential.user!.uid;

          // Update local user ID to match new Firebase Auth UID
          await _updateLocalUserId(user, firebaseUid);

          // Add user to Firestore
          await _firestore.collection('users').doc(firebaseUid).set(user.toMap());
        }

        SmartDialog.showToast('User synced successfully');
      } on FirebaseAuthException catch (e) {
        if(e.message == 'email-already-in-use') {
          if (kDebugMode) {
            print('Error syncing user ${user.email}: $e');
          }
          SmartDialog.showToast('Error syncing user: ${e.toString()}');
        }
      }
    }
  }

  Future<void> _updateLocalUserId(UserModel user, String newId) async {
    UserModel updatedUser = user.copyWith(id: newId);
    await _userBox.delete(user.id);
    await _userBox.put(newId, updatedUser);

    // Update current user ID in GetStorage if it matches the old ID
    String? currentUserId = GetStorage().read('currentUserID');
    if (currentUserId == user.id) {
      await GetStorage().write('currentUserID', newId);
    }
  }

  Future<void> _syncFirebaseToLocal() async {
    final firebaseUsers = await _firestore.collection('users').get();
    for (var doc in firebaseUsers.docs) {
      UserModel firebaseUser = UserModel.fromMap(doc.data());
      if(_userBox.containsKey(firebaseUser.id) == false) {
        await _userBox.put(firebaseUser.id, firebaseUser);
      }
    }
  }

  Future<UserModel> _syncUserDataFromFirebase(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      // If the user exists in Firestore, sync it to local Hive
      UserModel firebaseUser = UserModel.fromMap(userDoc.data()!);
      await _userBox.put(firebaseUser.id, firebaseUser);
      return firebaseUser;
    } else {
      // If user data is not found, handle it here (throw an error or fallback)
      SmartDialog.showToast('User data not found in Firebase');
      throw Exception('User data not found in Firebase');
    }
  }

  String _generateCustomUid(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) => characters[Random.secure().nextInt(characters.length)]).join();
  }
}