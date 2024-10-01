import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itmaterialspoint/Services/pdfviewer.dart';

class tech_page extends StatefulWidget {
  final techField;
  final techSubField;
  final bool colorBW;

  const tech_page({super.key,
    required this.techField,
    required this.techSubField,
    required this.colorBW});

  @override
  State<tech_page> createState() => tech_page_state();
}

class tech_page_state extends State<tech_page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back,color: !widget.colorBW ? Colors.white : Colors.black,)),
        backgroundColor: widget.colorBW ? Colors.white : Colors.black,
        title: Text(
          widget.techSubField,
          style: TextStyle(
            fontSize: 25,
            color: widget.colorBW ? Colors.black : Colors.cyanAccent,
          ),
        ),
      ),
      body: Container(
        color: widget.colorBW ? Colors.white : Colors.grey[800],
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("TechnologiesPDF")
                .doc(widget.techField)
                .collection(widget.techSubField)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final filesData = snapshot.data!.docs.toList();

              return ListView.builder(
                itemCount: filesData.length,
                itemBuilder: (context, index) {
                  final files = filesData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.shade50,
                      child: InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    pdfviewer(
                                      viewer: "Online",
                                      url: files["fileurl"].toString().trim(),
                                      filename: files["filename"]
                                          .toString()
                                          .trim(),
                                    ),
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  files["filename"]
                                      .toString()
                                      .replaceAll(".pdf", ""),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                                leading: const Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
