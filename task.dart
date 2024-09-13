class TaskItem {
  String text;
  bool isCompleted;

  TaskItem(this.text, {this.isCompleted = false});
}

class Task {
  String id;
  List<TaskItem> items;
  String time;
  bool isExpanded;

  Task(this.id, this.items, this.time, {this.isExpanded = false});
}
