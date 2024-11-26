import 'package:flutter/material.dart';
import 'package:todo_list/configs/routes_config.dart';
import 'package:todo_list/models/tasks.dart';
import 'package:todo_list/services/firebase_auth.dart';
import 'package:todo_list/services/sqlite_service.dart';

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

  SQLiteService sqliteService = SQLiteService();

  // Listas de tarefas
  List<Tasks> todoTasks = [];
  List<Tasks> doneTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setListTasks();
  }

  void _setListTasks() {
    sqliteService.tasks().then((tasks) {
      setState(() {
        todoTasks = tasks.where((task) => !task.isDone).toList();
        doneTasks = tasks.where((task) => task.isDone).toList();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Adiciona uma nova tarefa
  void _addTask(Tasks task) {
    setState(() {
      // todoTasks.add(task);
      sqliteService.insertTask(task);
    });
  }

  // Move uma tarefa para "DONE"
  void _markAsDone(int index) {
    setState(() {
      try {
        Tasks completedTask = todoTasks[index];
        completedTask.isDone = true;
        sqliteService.updateTask(completedTask);
      } catch (e) {
        print(e);
      }
      Tasks completedTask = todoTasks.removeAt(index);
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
                Tasks task = Tasks(
                  id: null,
                  title: taskController.text,
                  isDone: false,
                  description: 'Teste de descricao',
                  data: DateTime.now().timeZoneName,
                );
                setState(() {
                  _addTask(task);
                });
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
        title: Image.asset(
          'assets/images/my_schedule_white.png',
          width: 100,
        ),
        // Botão de logout
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //logout firebase
              FirebaseAuthService().signOut().whenComplete(
                    () => Navigator.of(navigatorKey!.currentContext!)
                        .pushNamed('/login'),
                  );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.list, color: Colors.white, size: 40),
          onPressed: () {},
        ),
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
                  title: Text(todoTasks[index].title),
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
                    doneTasks[index].title,
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
