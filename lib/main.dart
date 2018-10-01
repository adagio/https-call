import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {

  bool _certificateCheck(X509Certificate cert, String host, int port) =>
      host == 'www.woo.local';

  http.Client wooClient() {
    var ioClient = new HttpClient()
      ..badCertificateCallback = _certificateCheck;

    return new http.IOClient(ioClient);
  }

  var client = wooClient();

  final response =
  await client.get('https://www.woo.local/index.php/wp-json/wp/v2/posts/1',
    //headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int author;
  final int id;
  final String slug;
  final String type;

  Post({this.author, this.id, this.slug, this.type});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      author: json['author'],
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.slug);
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
