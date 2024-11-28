//pagina de configurações

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/custom_notification.dart';
import 'package:todo_list/services/local_notification.dart';

class ConfigsPage extends StatefulWidget {
  const ConfigsPage({super.key});

  @override
  State<ConfigsPage> createState() => _ConfigsPageState();
}

class _ConfigsPageState extends State<ConfigsPage> {
  @override
  Widget build(BuildContext context) {
    bool notifier = false;

    @override
    initState() {
      super.initState();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        body: Column(
          children: <Widget>[
            //add radio button
            StatefulBuilder(
              builder: (context, setState) => ListTile(
                title: const Text('Ativar notificações'),
                trailing: Checkbox(
                    value: notifier,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      if (value != null) {
                        notifier = value;
                      }
                      setState(() {});
                      print(notifier);
                    }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 138, 155, 168)),
                ),
                onTap: () {
                  setState(() {
                    notifier = !notifier;
                  });
                  if (notifier) {
                    Provider.of<NotificationService>(context, listen: false)
                        .showLocalNotification(CustomNotification(
                      title: 'Parabeéns!',
                      body: 'Notificações ativadas com sucesso!',
                      id: 0,
                      payload: '/task',
                    ));
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Excluir conta'),
              onTap: () {},
            ),
          ],
        ));
  }
}
