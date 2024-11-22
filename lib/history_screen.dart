import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;

  HistoryScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculation History"),
      ),
      body: history.isEmpty
          ? Center(
              child: Text("No history yet."),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    history[index],
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
    );
  }
}
