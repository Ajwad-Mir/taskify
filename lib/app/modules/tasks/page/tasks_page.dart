import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/modules/profile/page/profile_page.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_controller.dart';
import 'package:taskify/app/modules/tasks/page/create_task_page.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/schedule_widget.dart';

class TasksPage extends GetView<TasksController> {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Taskify",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
            fontFamily: Assets.fontsBodoniModaSCVariableFont,
            fontSize: 36.sp,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: -2,
          ),
        ),
        leadingWidth: 80.w,
        titleSpacing: 10.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: CupertinoButton(
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
        ),
        actions: [
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
            ),
          ),
          20.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: _buildBody(context),
      ),
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
      () => controller.isLoading.isFalse
          ? NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: _buildCalendar(context),
                  ),
                ];
              },
              floatHeaderSlivers: true,
              body: _buildScheduleList(),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
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
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectedDay.value, day);
          },
          eventLoader: controller.getTasksForDay,
          availableCalendarFormats: const {CalendarFormat.month: 'Month,'},
          headerStyle: HeaderStyle(
            titleTextStyle: AppTextStyles.medium.copyWith(
              fontSize: 24.sp,
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
            weekendStyle: AppTextStyles.medium.copyWith(
              fontSize: 16.sp,
              color: Colors.redAccent,
            ),
            weekdayStyle: AppTextStyles.medium.copyWith(
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
            weekendTextStyle: AppTextStyles.medium.copyWith(
              fontSize: 16.sp,
              color: Colors.redAccent,
            ),
            defaultTextStyle: AppTextStyles.medium.copyWith(
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
            outsideTextStyle: AppTextStyles.medium.copyWith(
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

  Widget _buildScheduleList() {
    return Obx(
      () => controller.selectedDayTasks.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: controller.selectedDayTasks.length,
              itemBuilder: (context, index) {
                return ScheduleWidget(taskIndex: index);
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
                    "Looks like your task list is empty!\nWhy not kick things off by adding some tasks.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.medium.copyWith(fontSize: 18.sp, color: AppColors.primary.withOpacity(0.4), height: 1.5),
                  ),
                ),
              ],
            ),
    );
  }
}
