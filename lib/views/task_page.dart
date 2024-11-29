// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/commons/human_date.dart';
import 'package:todo_list/models/custom_notification.dart';
import 'package:todo_list/models/tasks.dart';
import 'package:todo_list/services/local_notification.dart';
import 'package:todo_list/services/sqlite_service.dart';
import 'package:todo_list/views/left_menu.dart';

void main() => runApp(const TaskPage());

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _MySchedulePageState createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SQLiteService sqliteService = SQLiteService();
  DateTime selectedDate = DateTime.now();
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
  Future<int> _addTask(Tasks task) async {
    int taskId = await sqliteService.insertTask(task);
    return taskId;
  }

  //seach task by id
  Tasks? searchTaskById(int id) {
    try {
      return todoTasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  void _updateTask(Tasks task) {
    sqliteService.updateTask(task);
  }

  void _deleteTaskById(int id) {
    sqliteService.deleteTask(id);
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
    final TextEditingController description = TextEditingController();
    int selectedHour = DateTime.now().toLocal().hour;
    int selectedMinute = DateTime.now().toLocal().minute;

    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text("Adicionar tarefa"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: taskController,
                      validator: (value) =>
                          value!.isEmpty ? 'Preencha o campo' : null,
                      decoration: const InputDecoration(hintText: "Titulo"),
                    ),
                    TextFormField(
                      controller: description,
                      validator: (value) =>
                          value!.isEmpty ? 'Preencha o campo' : null,
                      decoration: const InputDecoration(
                        hintText: "Descrição",
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: EasyDateTimeLinePicker(
                        focusedDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        onDateChange: (date) {
                          //state não muda
                          setState(() {
                            selectedDate = date;
                          });

                          // Print the selected date.

                          print(selectedDate);
                        },
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Hora: "),
                        SizedBox(
                          width: 50,
                          child: DropdownButton<int>(
                            menuWidth: 100,
                            value: selectedHour,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedHour = newValue!;
                              });
                            },
                            items: List<DropdownMenuItem<int>>.generate(
                              24,
                              (int index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              },
                            ),
                          ),
                        ),
                        Text('Minutos: '),
                        SizedBox(
                          width: 50,
                          child: DropdownButton<int>(
                            menuWidth: 100,
                            value: selectedMinute,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedMinute = newValue!;
                              });
                            },
                            items: List<DropdownMenuItem<int>>.generate(
                              60,
                              (int index) {
                                return DropdownMenuItem<int>(
                                  value: index,
                                  child: Text('$index'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preencha os campos')));
                      return;
                    }
                    Tasks task = Tasks(
                      id: null,
                      title: taskController.text,
                      isDone: false,
                      description: description.text,
                      //date + hour
                      data: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedHour,
                        selectedMinute,
                      ).toString(),
                    );

                    int taskId = await _addTask(task);
                    print(
                        '$taskId -------------------------------------------------------------------------------');

                    Provider.of<NotificationService>(context, listen: false)
                        .showNotificationIfTimeIsNow(
                      CustomNotification(
                        title: task.title,
                        body: task.description,
                        id: taskId,
                        payload: '/task',
                      ),
                      Duration(
                          minutes: convertDateToMinutes(task.data.toString())),
                    );
                    setState(() {
                      _setListTasks();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final idNotification = ModalRoute.of(context)!.settings.arguments as int?;

    if (idNotification != null) {
      Tasks? task = searchTaskById(idNotification);
      if (task != null) {
        task.isDone = true;
        _updateTask(task);
        _setListTasks();
      }
    }

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
            icon: const Icon(Icons.upload_file, color: Colors.white, size: 40),
            onPressed: () {
              //logout firebase
            },
          ),
        ],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.list, color: Colors.white, size: 40),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
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
      drawer: const LeftMenu(),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba "TO DO"
          ListView.builder(
            itemCount: todoTasks.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(todoTasks[index].id.toString()),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(Icons.check, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmação'),
                        content: (direction == DismissDirection.startToEnd)
                            ? Text('Deseja realmente finalizar esta tarefa?')
                            : Text('Deseja realmente excluir esta tarefa?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Sim'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    _markAsDone(index);
                  } else {
                    setState(() {
                      sqliteService.deleteTask(todoTasks[index].id!);
                      todoTasks.removeAt(index);
                    });
                  }
                },
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.task_alt,
                        color: Colors.blueAccent, size: 30),
                    dense: true,
                    title: Text(todoTasks[index].title,
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                        )),
                    trailing: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _markAsDone(index);
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todoTasks[index].id.toString()),
                        Text(todoTasks[index].description),
                        Text(humanDate(todoTasks[index].data)),
                        Text('Falta: ${convertDate(todoTasks[index].data)}'),
                      ],
                    ),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(Icons.done, color: Colors.green),
                    title: Text(
                      doneTasks[index].title,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                    subtitle: Text(doneTasks[index].description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTaskById(doneTasks[index].id!);
                        setState(() {
                          doneTasks.removeAt(index);
                        });
                      },
                    ),
                  ));
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
