class Tasks {
  int? id;
  String title;
  String description;
  bool isDone;
  String data;

  Tasks({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0, // Converte bool para int
      'data': data,
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1, // Converte int para bool
      data: map['data'],
    );
  }

  @override
  String toString() {
    return 'Tasks{id: $id, title: $title, description: $description, isDone: $isDone, data: $data}';
  }
}
