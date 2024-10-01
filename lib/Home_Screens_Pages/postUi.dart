import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  final bool colorBW;

  const Post({super.key, required this.colorBW});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late Future<List<String>> futureimages;

  late Future<List<Map<String, dynamic>>> Post;

  Future<List<Map<String, dynamic>>> getPost() async {
    List<Map<String, dynamic>> imageurl = [];
    final results = await FirebaseFirestore.instance.collection("Post").get();

    final imageurls = results.docs.map((e) => e.data()).toList();
    setState(() {
      imageurl = imageurls;
    });
    return imageurl;
  }

  bool liked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Post = getPost();
  }

  void _showPhoto(String imageshow) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  height: 250,
                  width: 1500,
                  child: CachedNetworkImage(
                    imageUrl: imageshow,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Post,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              height: 300, child: Center(child: CircularProgressIndicator()));
        }
        final imageurls = snapshot.data!.toList();
        return ListView.separated(
          itemCount: imageurls.length,
          itemBuilder: (context, index) {
            final image = imageurls[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                color: !widget.colorBW ? Colors.black : Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          image["Postname"]
                              .toString()
                              .replaceAll(".jpg", "")
                              .toString()
                              .replaceAll(".jpeg", "")
                              .toString()
                              .replaceAll(".png", ""),
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                !widget.colorBW ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () => _showPhoto(image["Posturl"]),
                          child: CachedNetworkImage(
                            imageUrl: image["Posturl"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Center();
          },
        );
      },
    );
  }
}
