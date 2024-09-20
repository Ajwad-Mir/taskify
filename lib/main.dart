import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskify/app/bindings/app_bindings.dart';
import 'package:taskify/app/database/tasks_database.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/app/modules/splash/page/splash_page.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/firebase_options.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDatabases();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserService(), permanent: true);
    createAppDefaultSettings(context);
    return ScreenUtilInit(
      designSize: const Size(430, 923),
      builder: (context, _) => GetMaterialApp(
          title: 'Taskify',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          initialBinding: AppBindings(),
          theme: ThemeData.light().copyWith(
            brightness: Brightness.light,
            textTheme: Typography().white.apply(fontFamily: AppTextStyles.kFontFamily),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionHandleColor: AppColors.primary,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            brightness: Brightness.dark,
            textTheme: Typography().black.apply(fontFamily: AppTextStyles.kFontFamily),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: AppColors.primary,
              selectionHandleColor: AppColors.primary,
            ),
          ),
          home: const SplashPage()),
    );
  }

  void createAppDefaultSettings(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      (Theme.of(context).brightness == Brightness.dark)
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: AppColors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: AppColors.black.withOpacity(0.0),
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: AppColors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: AppColors.white.withOpacity(0.0),
            ),
    );
  }
}

Future<void> initializeBackgroundTasks() async {
  await Workmanager().initialize(backgroundSyncCallback);
  await Workmanager().registerPeriodicTask(
    "sync-users",
    "syncUsers",
    frequency: 5.seconds,
  );
  await Workmanager().registerPeriodicTask(
    "sync-tasks",
    "syncUserTasks",
    frequency: 5.seconds,
  );
}

Future<void> initializeDatabases() async {
  await Hive.initFlutter();
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  Hive.registerAdapter<TaskModel>(TaskModelAdapter());
  Hive.registerAdapter<SubTaskModel>(SubTaskModelAdapter());
  await GetStorage.init();
  await UserDatabase().init();
  await TaskDatabase().init();
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void backgroundSyncCallback() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'syncUsers') {
      await UserDatabase().init();
      await UserDatabase().syncUsers();
      return Future.value(true);
    } else if (task == 'syncUserTasks') {
      await TaskDatabase().init();
      await TaskDatabase().syncTasks();
      return Future.value(true);
    }
    return Future.value(false);
  });
}
