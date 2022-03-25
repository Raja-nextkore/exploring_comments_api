import 'dart:convert';

import '../model/comments_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Comments> _comments = [];
  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<List<Comments>> _fetchComments() async {
    final http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/comments'),
    );
    if (response.statusCode == 200) {
      var parsedJson = jsonDecode(response.body.toString());
      for (Map<String, dynamic> json in parsedJson) {
        setState(() {
          _comments.add(
            Comments.fromJson(json),
          );
        });
      }
      return _comments;
    } else {
      throw Exception('Unable to load comments...');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exploring comments Api'),
      ),
      body: ListView.separated(
          itemBuilder: (_, index) {
            return Card(
              elevation: 10.0,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      _comments[index].name,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _comments[index].email,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      child: Text(_comments[index].postId.toString()),
                    ),
                  ),
                  SizedBox(
                    child: ListTile(
                      title: Text(
                        'Body :  ${_comments[index].body}',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (_, i) {
            return const Divider(
              height: 1.0,
              color: Colors.black,
            );
          },
          itemCount: _comments.length),
    );
  }
}
