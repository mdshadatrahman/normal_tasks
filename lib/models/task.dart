class Task {
  String content;
  String timestamp;
  bool done;

  Task({
    required this.content,
    required this.done,
    required this.timestamp,
  });

  factory Task.fromMap(Map task) {
    return Task(
      content: task['content'],
      done: task['done'],
      timestamp: task['timestamp'],
    );
  }

  Map toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'done': done,
    };
  }
}
