import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart'; // Import ScopedModel

void main() {
  runApp(
    ScopedModel<AppState>( // Wrap your app with ScopedModel
      model: AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Using Scoped Model",
      home: MyNoteListPage(),
    );
  }
}

class AppState extends Model { // Extend Model to make it a scoped model
  final List<String> _notes = [];

  List<String> get notes => _notes;

  void add(String note) {
    _notes.add(note);
    notifyListeners();
  }

  void remove(String note) {
    _notes.remove(note);
    notifyListeners();
  }
}

class MyNoteListPage extends StatelessWidget {
  const MyNoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MyNoteList(),
    );
  }
}

class MyNoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>( // Access AppState using ScopedModelDescendant
      builder: (context, child, appState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("My Notes"),
          ),
          body: ListView.builder(
            itemCount: appState.notes.length,
            itemBuilder: (context, index) {
              final note = appState.notes[index];
              return ListTile(
                title: Text(note),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    appState.remove(note);
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyNoteAddPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class MyNoteAddPage extends StatelessWidget {
  const MyNoteAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: MyNoteAdd(),
    );
  }
}

class MyNoteAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>( // Access AppState using ScopedModelDescendant
      builder: (context, child, appState) {
        return Center(
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                onSubmitted: (text) {
                  appState.add(text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}