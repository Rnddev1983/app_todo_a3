import 'package:flutter/material.dart';
import 'package:todo_list/configs/routes_config.dart';
import 'package:todo_list/services/firebase_auth.dart';

void main() => runApp(const TaskPage());

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySchedulePage(),
    );
  }
}

class MySchedulePage extends StatefulWidget {
  const MySchedulePage({super.key});

  @override
  _MySchedulePageState createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Listas de tarefas
  List<String> todoTasks = [];
  List<String> doneTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Adiciona uma nova tarefa
  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        todoTasks.add(task);
      });
    }
  }

  // Move uma tarefa para "DONE"
  void _markAsDone(int index) {
    setState(() {
      String completedTask = todoTasks.removeAt(index);
      doneTasks.add(completedTask);
    });
  }

  // Mostra o diálogo para adicionar tarefas
  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(taskController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "My Schedule",
          style: TextStyle(fontFamily: "Cursive"),
        ),
        // Botão de logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //logout firebase
              FirebaseAuthService().signOut();
              Navigator.of(navigatorKey!.currentContext!).pushNamed('/login');
            },
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: "TO DO"),
            const Tab(text: "DONE"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba "TO DO"
          ListView.builder(
            itemCount: todoTasks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.task_alt, color: Colors.blueAccent),
                  title: Text(todoTasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _markAsDone(index),
                  ),
                ),
              );
            },
          ),
          // Aba "DONE"
          ListView.builder(
            itemCount: doneTasks.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.done, color: Colors.green),
                  title: Text(
                    doneTasks[index],
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
