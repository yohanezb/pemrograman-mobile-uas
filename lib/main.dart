import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSON Parser',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? title;
  String? authorId;
  List<String>? comments;

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data.json');
      final data = await json.decode(response);

      setState(() {
        title = data['data'][0]['attributes']['title'];
        authorId = data['data'][0]['relationships']['author']['data']['id'];


        comments = List<String>.from(data['data'][0]['relationships']['comments']['data']
            .map((comment) => comment['id'].toString()));
      });
    } catch (e) {
      print("Error loading data: $e");  // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS Pemrograman Mobile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: title == null || authorId == null || comments == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title ?? 'No Title',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            //Author ID
            Text(
              'Author ID:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              authorId ?? 'No Author ID',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            //Comment
            Text(
              'Comments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: comments?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Comment ID: ${comments?[index]}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
