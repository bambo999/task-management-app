import 'package:flutter/material.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String id;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      id = widget.task!.id;
      title = widget.task!.title;
      description = widget.task!.description;
    } else {
      id = DateTime.now().toString();
      title = '';
      description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
                onChanged: (value) => title = value,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final task = Task(
                      id: id,
                      title: title,
                      description: description,
                    );
                    Navigator.pop(context, task);
                  }
                },
                child: Text(widget.task == null ? 'Save' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
