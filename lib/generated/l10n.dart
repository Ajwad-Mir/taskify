// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class LocalizationTheme {
  LocalizationTheme();

  static LocalizationTheme? _current;

  static LocalizationTheme get current {
    assert(_current != null,
        'No instance of LocalizationTheme was loaded. Try to initialize the LocalizationTheme delegate before accessing LocalizationTheme.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<LocalizationTheme> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = LocalizationTheme();
      LocalizationTheme._current = instance;

      return instance;
    });
  }

  static LocalizationTheme of(BuildContext context) {
    final instance = LocalizationTheme.maybeOf(context);
    assert(instance != null,
        'No instance of LocalizationTheme present in the widget tree. Did you add LocalizationTheme.delegate in localizationsDelegates?');
    return instance!;
  }

  static LocalizationTheme? maybeOf(BuildContext context) {
    return Localizations.of<LocalizationTheme>(context, LocalizationTheme);
  }

  /// `Taskify`
  String get appName {
    return Intl.message(
      'Taskify',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logging In`
  String get loggingIn {
    return Intl.message(
      'Logging In',
      name: 'loggingIn',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email address`
  String get pleaseEnterEmailAddress {
    return Intl.message(
      'Please enter email address',
      name: 'pleaseEnterEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't Have an Account? `
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t Have an Account? ',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Registering User`
  String get registeringUser {
    return Intl.message(
      'Registering User',
      name: 'registeringUser',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full name`
  String get pleaseEnterFullName {
    return Intl.message(
      'Please enter full name',
      name: 'pleaseEnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Password length must be greater than 6 characters`
  String get passwordLengthMustBeGreaterThanSixCharacters {
    return Intl.message(
      'Password length must be greater than 6 characters',
      name: 'passwordLengthMustBeGreaterThanSixCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Both Passwords must be same`
  String get bothPasswordsMustBeSame {
    return Intl.message(
      'Both Passwords must be same',
      name: 'bothPasswordsMustBeSame',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already Have an Account? `
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already Have an Account? ',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Looks like your task list is empty!\nWhy not kick things off by adding some tasks.`
  String get looksLikeYourTaskListIsEmptyWhyNotKickThingsOffByAddingSomeTasks {
    return Intl.message(
      'Looks like your task list is empty!\\nWhy not kick things off by adding some tasks.',
      name: 'looksLikeYourTaskListIsEmptyWhyNotKickThingsOffByAddingSomeTasks',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message(
      'Progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Collapse`
  String get collapse {
    return Intl.message(
      'Collapse',
      name: 'collapse',
      desc: '',
      args: [],
    );
  }

  /// `Expand`
  String get expand {
    return Intl.message(
      'Expand',
      name: 'expand',
      desc: '',
      args: [],
    );
  }

  /// `Update Task`
  String get updateTask {
    return Intl.message(
      'Update Task',
      name: 'updateTask',
      desc: '',
      args: [],
    );
  }

  /// `Updating Task`
  String get updatingTask {
    return Intl.message(
      'Updating Task',
      name: 'updatingTask',
      desc: '',
      args: [],
    );
  }

  /// `Updating Profile`
  String get updatingProfile {
    return Intl.message(
      'Updating Profile',
      name: 'updatingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Create Task`
  String get createTask {
    return Intl.message(
      'Create Task',
      name: 'createTask',
      desc: '',
      args: [],
    );
  }

  /// `Creating Task`
  String get creatingTask {
    return Intl.message(
      'Creating Task',
      name: 'creatingTask',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Characters`
  String get characters {
    return Intl.message(
      'Characters',
      name: 'characters',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Very Low`
  String get veryLow {
    return Intl.message(
      'Very Low',
      name: 'veryLow',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message(
      'Low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `Normal`
  String get normal {
    return Intl.message(
      'Normal',
      name: 'normal',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get high {
    return Intl.message(
      'High',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `Very High`
  String get veryHigh {
    return Intl.message(
      'Very High',
      name: 'veryHigh',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get dueDate {
    return Intl.message(
      'Due Date',
      name: 'dueDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Due Date`
  String get selectDueDate {
    return Intl.message(
      'Select Due Date',
      name: 'selectDueDate',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Add Notes`
  String get addNotes {
    return Intl.message(
      'Add Notes',
      name: 'addNotes',
      desc: '',
      args: [],
    );
  }

  /// `No tasks here, create one if you want`
  String get noTasksHereCreateOneIfYouWant {
    return Intl.message(
      'No tasks here, create one if you want',
      name: 'noTasksHereCreateOneIfYouWant',
      desc: '',
      args: [],
    );
  }

  /// `Subtask`
  String get subtask {
    return Intl.message(
      'Subtask',
      name: 'subtask',
      desc: '',
      args: [],
    );
  }

  /// `Add Subtask`
  String get addSubtask {
    return Intl.message(
      'Add Subtask',
      name: 'addSubtask',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<LocalizationTheme> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<LocalizationTheme> load(Locale locale) => LocalizationTheme.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
