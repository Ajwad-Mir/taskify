import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_details_controller.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/category_widget.dart';

class TaskDetailsPage extends GetView<TasksDetailsController> {
  const TaskDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TasksDetailsController>(
      builder: (_) => Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.primary.withAlpha((255 * 0.5).round())
            : AppColors.primary.withAlpha((255 * 0.85).round()),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: CupertinoButton(
            onPressed: () {
              if (controller.isUpdateMode.isTrue) {
                controller.clearData();
                controller.update();
              }
              Get.back();
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            CupertinoButton(
              onPressed: () async {
                if (controller.isUpdateMode.isFalse) {
                  await controller.createTask();
                } else {
                  await controller.updateTask();
                }
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.primary.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Text(
                  controller.isUpdateMode.isTrue ? "Update Task" : "Create Task",
                  style: AppTextStyles.medium.copyWith(
                    fontSize: 16.sp,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            20.horizontalSpace,
          ],
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleWidget(context),
                5.verticalSpace,
                _buildScheduleDetails(context),
                5.verticalSpace,
                _buildDescriptionWidget(context),
                5.verticalSpace,
                _buildTaskPriority(context),
                20.verticalSpace,
                _buildDueDateWidget(context),
                10.verticalSpace,
                _buildNoteWidget(context),
                10.verticalSpace,
                _buildSubtaskWidget(context),
              ],
            ),
          ),
        ),
      ),
      dispose: (_) {
        if (controller.isUpdateMode.isTrue) {
          controller.clearData();
        }
      },
    );
  }

  Widget _buildTitleWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: controller.titleController,
        style: AppTextStyles.bold.copyWith(
          fontSize: 42.sp,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        maxLines: null,
        cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        scrollController: null,
        keyboardType: TextInputType.text,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          hintText: 'Title',
          hintStyle: AppTextStyles.bold.copyWith(
            fontSize: 42.sp,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
          ),
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildScheduleDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd MMMM yyyy').format(DateTime.now()),
            style: AppTextStyles.bold.copyWith(
              fontSize: 18.sp,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
            ),
          ),
          15.horizontalSpace,
          Obx(
            () => Text(
              "${controller.descriptionLength.value} Characters",
              style: AppTextStyles.bold.copyWith(
                fontSize: 18.sp,
                color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: controller.descriptionController,
        style: AppTextStyles.bold.copyWith(
          fontSize: 18.sp,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        maxLines: null,
        cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        scrollController: null,
        keyboardType: TextInputType.multiline,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.newline,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Description',
          hintStyle: AppTextStyles.bold.copyWith(
            fontSize: 18.sp,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
          ),
          constraints: BoxConstraints(
            maxHeight: 150.h,
          ),
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTaskPriority(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 5.w,
        children: controller.priorityList.map((element) {
          return Obx(
            () => CategoryWidget(
              onPressed: () {
                controller.selectedPriority.value = element;
              },
              categoryText: element,
              categoryStyle: AppTextStyles.medium.copyWith(
                fontSize: 18.sp,
                color: controller.selectedPriority.value == element
                    ? AppColors.primary
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
              selectedColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              borderColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              borderRadius: 25.r,
              isSelected: controller.selectedPriority.value == element,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDueDateWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              10.horizontalSpace,
              Text(
                'Due Date',
                style: AppTextStyles.bold.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Obx(
            () => CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await controller.selectDueDate(context);
              },
              child: Text(
                controller.selectedDueDate.value != null ? DateFormat('dd MMMM yyyy').format(controller.selectedDueDate.value!) : 'Select Due Date',
                style: AppTextStyles.bold.copyWith(
                  fontSize: 18.sp,
                  color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextFormField(
        controller: controller.notesController,
        style: AppTextStyles.bold.copyWith(
          fontSize: 18.sp,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
        maxLines: null,
        cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        scrollController: null,
        keyboardType: TextInputType.multiline,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        textInputAction: TextInputAction.newline,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Add Notes',
          hintStyle: AppTextStyles.bold.copyWith(
            fontSize: 18.sp,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
          ),
          constraints: BoxConstraints(
            maxHeight: 150.h,
          ),
          filled: false,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubtaskWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.subtaskControllers.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  'No tasks here, create one if you want',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 18.sp,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            for (var i = 0; i < controller.subtaskControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.subtaskControllers[i],
                      style: AppTextStyles.bold.copyWith(
                        fontSize: 18.sp,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                      ),
                      maxLines: 1,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Subtask ${i + 1}',
                        hintStyle: AppTextStyles.bold.copyWith(
                          fontSize: 18.sp,
                          color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.4) : Colors.white.withOpacity(0.4),
                        ),
                        filled: false,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.removeSubtask(i);
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            CupertinoButton(
              onPressed: controller.addSubtask,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                  5.horizontalSpace,
                  Text(
                    'Add Subtask',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 18.sp,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
