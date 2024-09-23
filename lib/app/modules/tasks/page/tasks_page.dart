import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/modules/profile/page/profile_page.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_controller.dart';
import 'package:taskify/app/modules/tasks/page/create_task_page.dart';
import 'package:taskify/app/services/localization_service.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/schedule_widget.dart';

class TasksPage extends GetView<TasksController> {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(Get.find<LocalizationService>().locale.languageCode),
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        systemOverlayStyle: (Theme.of(context).brightness == Brightness.dark)
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
        title: Text(
          LocalizationTheme.of(context).appName,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
            fontFamily: Assets.fontsBodoniModaSCVariableFont,
            fontSize: 36.sp,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: -2,
          ),
        ),
        leading: CupertinoButton(
          onPressed: () {
            Get.to(
              () => const ProfilePage(),
              transition: Transition.cupertino,
            );
          },
          minSize: 0,
          padding: EdgeInsets.zero,
          child: Container(
            width: 50.w,
            height: 50.w,
            margin: EdgeInsets.only(
              left: Get.find<LocalizationService>().locale.languageCode == 'ar' ? 0 : 20.w,
              right: Get.find<LocalizationService>().locale.languageCode == 'ar' ? 20.w : 0,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Center(
              child: Obx(
                () => Text(
                  "${Get.find<UserService>().currentUser.value.fullName.split(" ").first[0].capitalize}${Get.find<UserService>().currentUser.value.fullName.split(" ").last[0].capitalize}",
                  style: AppTextStyles.extraBold.copyWith(
                    fontSize: 24.sp,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          CupertinoButton(
            onPressed: () async {
              final currentLocale = Get.find<LocalizationService>().locale.languageCode;
              final newLocale = currentLocale == 'en' ? 'ar' : 'en';

              // Start the fade-out animation
              controller.animationController.forward().then((_) {
                Get.find<LocalizationService>().changeLocale(newLocale);
                controller.animationController.reverse();
              });
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: SvgPicture.asset(
              Assets.svgEnglishToArabic,
              colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, BlendMode.srcIn),
              width: 30.w,
              height: 30.w,
            ),
          ),
          20.horizontalSpace,
          CupertinoButton(
            onPressed: () async {
              await UserDatabase().logout();
              Get.offAll(
                () => const LoginPage(),
                transition: Transition.cupertino,
              );
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.logout,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              size: 30.w,
            ),
          ),
          20.horizontalSpace,
        ],
      ),
      body: FadeTransition(opacity: controller.animation, child: _buildBody(context)),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory, splashColor: Colors.transparent),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(
              () => const TaskDetailsPage(),
              transition: Transition.cupertino,
            );
          },
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Obx(
      () => FadeIn(
          child: controller.isLoading.isFalse
              ? NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: _buildCalendar(context),
                      ),
                    ];
                  },
                  floatHeaderSlivers: true,
                  body: _buildScheduleList(context),
                )
              : _buildPageShimmer(context)),
    );
  }

  Widget _buildPageShimmer(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
          child: Container(
            height: 400.h,
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 10.h,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10, // Display a few shimmer items
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  height: 80.h, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 10.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TableCalendar<TaskModel>(
          focusedDay: controller.selectedDay.value,
          currentDay: DateTime.now(),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          calendarFormat: CalendarFormat.month,
          locale: Get.find<LocalizationService>().locale.languageCode,
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDay.value, day);
          },
          eventLoader: controller.getTasksForDay,
          availableCalendarFormats: const {CalendarFormat.month: 'Month,'},
          headerStyle: HeaderStyle(
            titleTextStyle: AppTextStyles.bold.copyWith(
              fontSize: 36.sp,
              color: AppColors.primary,
            ),
            titleCentered: true,
            headerMargin: EdgeInsets.zero,
            headerPadding: EdgeInsets.symmetric(vertical: 20.h),
            leftChevronVisible: false,
            rightChevronVisible: false,
          ),
          onDaySelected: controller.filterTaskBySelectedDate,
          onFormatChanged: null,
          daysOfWeekVisible: true,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: Colors.redAccent,
            ),
            weekdayStyle: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: AppColors.primary,
            ),
          ),
          calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            markerMargin: EdgeInsets.only(top: 7.5.h),
            markerSize: 7.5.w,
            weekendTextStyle: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: Colors.redAccent,
            ),
            defaultTextStyle: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withAlpha(145),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            outsideTextStyle: AppTextStyles.bold.copyWith(
              fontSize: 16.sp,
              color: AppColors.primary,
            ),
          ),
          rangeSelectionMode: RangeSelectionMode.disabled,
          startingDayOfWeek: StartingDayOfWeek.sunday,
        ),
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context) {
    return Obx(
      () => controller.selectedDayTasks.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: controller.selectedDayTasks.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  duration: 1000.milliseconds,
                  delay: (index * 100).milliseconds,
                  child: ScheduleWidget(taskIndex: index),
                );
              },
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                50.verticalSpace,
                SvgPicture.asset(
                  Assets.svgNoNotesHere,
                  width: 256.w,
                  height: 256.h,
                ),
                SizedBox(
                  width: 350.w,
                  child: Text(
                    LocalizationTheme.of(context).looksLikeYourTaskListIsEmptyWhyNotKickThingsOffByAddingSomeTasks,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.medium.copyWith(fontSize: 18.sp, color: AppColors.primary.withOpacity(0.4), height: 1.5),
                  ),
                ),
              ],
            ),
    );
  }
}
