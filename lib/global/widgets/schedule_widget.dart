import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_controller.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_details_controller.dart';
import 'package:taskify/app/modules/tasks/page/create_task_page.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/helper/task_helper_classes.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/custom_gradient_checkbox.dart';
import 'package:taskify/global/widgets/percentage_indicator.dart';

class ScheduleWidget extends GetView<TasksController> {
  final int taskIndex;
  final isExpanded = false.obs;

  ScheduleWidget({super.key, required this.taskIndex});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.light
                ? [
              const Color(0xFFFFE5D1).withOpacity(0.6), // Light peach to contrast with the title text
              const Color(0xFFF5CBA7).withOpacity(0.6), // Soft orange-pink that complements the orange
            ]
                : [
              const Color(0xFFB55E1F).withOpacity(0.7), // Muted brown-orange for dark mode
              const Color(0xFF4A250E).withOpacity(0.7), // A deeper brown to maintain contrast
            ],
            stops: const [0, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                _buildHeader(context),
                25.verticalSpace,
                _buildProgressWidget(context),
                if (controller.selectedDayTasks[taskIndex].taskNotes.isNotEmpty) ...[
                  15.verticalSpace,
                  _buildNotesSection(context),
                ],
                if (controller.selectedDayTasks[taskIndex].taskSubtasks.isNotEmpty) ...[
                  25.verticalSpace,
                  _buildExpandButton(context),
                ]
              ],
            ),
            if (controller.selectedDayTasks[taskIndex].taskSubtasks.isNotEmpty) _buildSubTaskWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.selectedDayTasks[taskIndex].taskTitle,
                style: AppTextStyles.extraBold.copyWith(
                  fontSize: 22.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                ),
              ),
              if (controller.selectedDayTasks[taskIndex].taskDescription != null && controller.selectedDayTasks[taskIndex].taskDescription.toString().isNotEmpty) ...[
                10.verticalSpace,
                Text(
                  controller.selectedDayTasks[taskIndex].taskDescription.toString(),
                  style: AppTextStyles.medium.copyWith(
                    fontSize: 16.sp,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ]
            ],
          ),
        ),
        Row(
          children: [
            CupertinoButton(
              onPressed: () {
                Get.find<TasksDetailsController>().isUpdateMode.value = true;
                Get.find<TasksDetailsController>().selectedTask.value = controller.selectedDayTasks[taskIndex];
                Get.find<TasksDetailsController>().setupDateForUpdate(Get.find<TasksDetailsController>().selectedTask.value);
                Get.to(
                  () => const TaskDetailsPage(),
                  transition: Transition.cupertino,
                );
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Icon(
                  Icons.edit,
                  size: 20.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            15.horizontalSpace,
            CupertinoButton(
              onPressed: () async {
                await controller.updateTask(controller.selectedDayTasks[taskIndex] = controller.selectedDayTasks[taskIndex].copyWith(
                  taskStatus: controller.selectedDayTasks[taskIndex].taskStatus == 'completed'
                    ? 'in-progress'
                        : controller.selectedDayTasks[taskIndex].taskSubtasks.every((element) => element.subTaskStatus == true) == true
                    ? "completed"
                    : "in-progress",
                  taskUpdatedAt: DateTime.now(),
                  taskSubtasks: controller.selectedDayTasks[taskIndex].updateAllSubtasks(true),
                ));
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Icon(
                  Icons.done_all,
                  size: 20.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            15.horizontalSpace,
            CupertinoButton(
              onPressed: () async {
                await controller.deleteTask(controller.selectedDayTasks[taskIndex]);
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Icon(
                  Icons.delete,
                  size: 20.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressWidget(BuildContext context) {
    return Row(
      children: [
        Text(
          LocalizationTheme.of(context).progress,
          style: AppTextStyles.extraBold.copyWith(
            fontSize: 20.sp,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: LinearPercentageIndicator(
            completedColor: AppColors.primary,
            percentage: TaskHelperClasses.getPercentageCompleted(
              status: controller.selectedDayTasks[taskIndex].taskStatus,
              completedTasksLength: controller.selectedDayTasks[taskIndex].taskSubtasks.where((element) => element.subTaskStatus == true).toList().length,
              allTasksLength: controller.selectedDayTasks[taskIndex].taskSubtasks.length,
            ),
            animationDuration: 800.milliseconds,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor.withOpacity(0.1) : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.75) : AppColors.primary.withOpacity(0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notes_rounded,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            size: 24.r,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationTheme.of(context).notes,
                  style: AppTextStyles.extraBold.copyWith(fontSize: 18.sp, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                ),
                10.verticalSpace,
                Text(
                  controller.selectedDayTasks[taskIndex].taskNotes,
                  style: AppTextStyles.medium.copyWith(fontSize: 16.sp, color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        isExpanded.value = !isExpanded.value;
      },
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isExpanded.value ? LocalizationTheme.of(context).collapse : LocalizationTheme.of(context).expand,
            style: AppTextStyles.medium.copyWith(
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
            ),
          ),
          Icon(
            isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubTaskWidget(BuildContext context) {
    return AnimatedSize(
      duration: 300.milliseconds,
      curve: Curves.easeInOut,
      child: Column(
        children: [
          if (isExpanded.isTrue) ...[
            15.verticalSpace,
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColor.withOpacity(0.1) : AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemExtent: 50.h,
                itemCount: controller.selectedDayTasks[taskIndex].taskSubtasks.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientCheckbox(
                        isChecked: controller.selectedDayTasks[taskIndex].taskSubtasks[index].subTaskStatus,
                        onPressed: () async {
                          await controller.updateSubTaskStatus(taskIndex: taskIndex, subTaskIndex: index);
                          isExpanded.value = true;
                          controller.update();
                        },
                        gradient: Theme.of(context).brightness == Brightness.dark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient,
                        size: 24.sp,
                        checkBoxText: controller.selectedDayTasks[taskIndex].taskSubtasks[index].subTaskTitle,
                        checkBoxTextStyle: AppTextStyles.medium.copyWith(
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                          decoration: controller.selectedDayTasks[taskIndex].taskSubtasks[index].subTaskStatus == true ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                        radius: 10.r,
                      ),
                      CupertinoButton(
                        onPressed: () async {
                          await controller.deleteSubTask(
                            taskIndex: taskIndex,
                            selectedSubTask: controller.selectedDayTasks[taskIndex].taskSubtasks[index],
                          );
                        },
                        minSize: 0,
                        padding: EdgeInsets.zero,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                            border: Border.all(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                          child: Icon(
                            Icons.delete,
                            size: 20.sp,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
