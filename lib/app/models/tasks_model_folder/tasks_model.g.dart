// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      taskId: fields[0] as String,
      taskTitle: fields[1] as String,
      taskDescription: fields[2] as String?,
      taskStatus: fields[3] as String,
      taskPriority: fields[4] as int,
      taskDueDate: fields[5] as DateTime?,
      taskCreatedAt: fields[6] as DateTime,
      taskUpdatedAt: fields[7] as DateTime,
      taskSubtasks: (fields[8] as List).cast<SubTaskModel>(),
      taskNotes: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.taskTitle)
      ..writeByte(2)
      ..write(obj.taskDescription)
      ..writeByte(3)
      ..write(obj.taskStatus)
      ..writeByte(4)
      ..write(obj.taskPriority)
      ..writeByte(5)
      ..write(obj.taskDueDate)
      ..writeByte(6)
      ..write(obj.taskCreatedAt)
      ..writeByte(7)
      ..write(obj.taskUpdatedAt)
      ..writeByte(8)
      ..write(obj.taskSubtasks)
      ..writeByte(9)
      ..write(obj.taskNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubTaskModelAdapter extends TypeAdapter<SubTaskModel> {
  @override
  final int typeId = 2;

  @override
  SubTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubTaskModel(
      subTaskTitle: fields[0] as String,
      subTaskStatus: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SubTaskModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subTaskTitle)
      ..writeByte(1)
      ..write(obj.subTaskStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
