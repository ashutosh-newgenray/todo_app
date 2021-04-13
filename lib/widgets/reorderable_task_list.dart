import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'todo_task_item.dart';

class ReorderableTaskList extends StatefulWidget {
  final String todoDocId;
  final List tasks;
  ReorderableTaskList({required this.todoDocId, required this.tasks});

  @override
  _ReorderableTaskListState createState() => _ReorderableTaskListState();
}

class _ReorderableTaskListState extends State<ReorderableTaskList> {
  late final String _todoDocId;
  int reordered = 0;
  List _tasks = [];
  @override
  void initState() {
    _todoDocId = widget.todoDocId;

    super.initState();
  }

  Future<void> updatePriority(oldIndex, newIndex) {
    CollectionReference tasksCollection =
        FirebaseFirestore.instance.collection('todos/$_todoDocId/tasks');
    WriteBatch batch = FirebaseFirestore.instance.batch();

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    String _oldDocId = _tasks[oldIndex].id;
    int oP = _tasks[oldIndex].data()['priority'];
    int nP = _tasks[newIndex].data()['priority'];

    return tasksCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        final int p = document.data()['priority'];
        if (nP > oP && p <= nP && p > oP) {
          batch.update(
              document.reference, {'priority': FieldValue.increment(-1)});
        }

        if (nP < oP && p >= nP && p < oP) {
          batch.update(
              document.reference, {'priority': FieldValue.increment(1)});
        }
        if (document.id == _oldDocId) {
          batch.update(document.reference, {'priority': nP});
        }
      });

      return batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    double scale = 1.0;
    _tasks = widget.tasks;
    // _tasks.sort((a, b) {
    //   return b.data()['priority'].compareTo(a.data()['priority']);
    // });
    final _activeTasks = _tasks.map((item) {
      return item.data()['isComplete'] != null && !item.data()['isComplete'];
    }).toList();
    final activeListCount = _activeTasks.length > 0 ? _activeTasks.length : 0;

    return RefreshIndicator(
      onRefresh: () {
        todoProvider.addTask(_todoDocId);
        return Future.delayed(Duration(milliseconds: 0));
      },
      child: GestureDetector(
        onScaleUpdate: (ScaleUpdateDetails details) {
          scale = details.scale;
        },
        onScaleEnd: (ScaleEndDetails details) {
          if (scale < 1) {
            Navigator.of(context).pop();
          }
        },
        child: ReorderableListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (ctx, i) {
            final task = _tasks[i].data();
            int c =
                activeListCount > 0 ? (255 / activeListCount).round() * i : 82;
            return TodoTaskItem(
              key: ValueKey(_tasks[i].id),
              todoDocId: widget.todoDocId,
              taskDocId: _tasks[i].id,
              colorValue: c,
              data: task,
            );
          },
          onReorder: (int oldIndex, int newIndex) {
            updatePriority(oldIndex, newIndex)
                .then((value) => print("Success"))
                .catchError((err) {
              print(err);
            });
            int nI = newIndex;
            setState(() {
              if (oldIndex < newIndex) {
                nI -= 1;
              }
              final item = _tasks.removeAt(oldIndex);
              _tasks.insert(nI, item);
            });
          },
        ),
      ),
    );
  }
}
