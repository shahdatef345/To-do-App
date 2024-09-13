import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../task.dart';
import '../task_list_tile.dart';
import '../add_task_bottom_sheet.dart';

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('EEE, dd MMMM yyyy').format(DateTime.now());

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddTaskBottomSheet(
          onTaskAdded: (newTasks) {
            setState(() {
              List<TaskItem> combinedTasks = newTasks.where((task) => task.text.isNotEmpty).toList();
              if (combinedTasks.isNotEmpty) {
                tasks.add(Task(
                  DateTime.now().toString(),
                  combinedTasks,
                  DateFormat.jm().format(DateTime.now()),
                ));
              }
            });
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        formattedDate = DateFormat('EEE, dd MMMM yyyy').format(selectedDate);
      });
    }
  }

  int _countCheckedTasks(Task task) {
    return task.items.where((item) => item.isCompleted).length;
  }

  Color _getTaskStatusColor(Task task) {
    int completedTasks = _countCheckedTasks(task);
    if (completedTasks == 0) {
      return Colors.grey; 
    } else if (completedTasks == task.items.length) {
      return Colors.green; 
    } else {
      return Colors.orange; 
    }
  }

  String _getTaskStatusText(Task task) {
    int completedTasks = _countCheckedTasks(task);
    int totalTasks = task.items.length;
    if (completedTasks == totalTasks && totalTasks > 0) {
      return 'Completed'; 
    } else {
      return '$completedTasks/$totalTasks task completed'; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.grey),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, taskIndex) {
                return TaskListTile(
                  task: tasks[taskIndex],
                  onDelete: (itemIndex) {
                    setState(() {
                      tasks[taskIndex].items.removeAt(itemIndex);
                      if (tasks[taskIndex].items.isEmpty) {
                        tasks.removeAt(taskIndex);
                      }
                    });
                  },
                  onToggleCompletion: (itemIndex) {
                    setState(() {
                      tasks[taskIndex].items[itemIndex].isCompleted = !tasks[taskIndex].items[itemIndex].isCompleted;
                    });
                  },
                  onToggleExpansion: () {
                    setState(() {
                      tasks[taskIndex].isExpanded = !tasks[taskIndex].isExpanded;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showAddTaskBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('+ Add Task'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
