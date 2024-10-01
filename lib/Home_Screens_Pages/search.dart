import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Services/pdfviewer.dart';

class SearchPage extends StatefulWidget {
  final bool colorBW;

  const SearchPage({super.key, required this.colorBW});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, String>> allPDFs = [];
  List<Map<String, String>> filteredPDFs = []; // Start with an empty list
  TextEditingController searchController = TextEditingController();
  String? searchText;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    fetchPDFs();
    searchController.addListener(onSearchChanged);
  }

  Future<void> fetchPDFs() async {
    final StorageRef = FirebaseStorage.instance.ref("TechnologiesPDF/");
    final listResult = await StorageRef.listAll();

    allPDFs = await Future.wait(
      listResult.items.map((item) async {
        final url = await item.getDownloadURL();
        return {"name": item.name, "url": url};
      }),
    );
  }

  void onSearchChanged() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchText = searchController.text.toLowerCase();
        if (searchText!.isNotEmpty) {
          filteredPDFs = allPDFs.where((pdf) {
            return pdf["name"]!.toLowerCase().contains(searchText!);
          }).toList();
        } else {
          filteredPDFs = []; // Clear results if search text is empty
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  widget.colorBW ? Colors.white : Colors.grey[800],
      appBar: AppBar(

        backgroundColor: widget.colorBW ? Colors.white : Colors.grey[800],

        leadingWidth: double.maxFinite,
        leading: Padding(
          padding: const EdgeInsets.only(top: 10.0,left: 5.0,right: 5.0),
          child: TextFormField(
            style: TextStyle(
                color: widget.colorBW ? Colors.black : Colors.white),
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search_sharp,
                color: widget.colorBW ? Colors.black : Colors.white,
              ),
              hintText: 'Search',
              hintStyle:  TextStyle(color: widget.colorBW ? Colors.black : Colors.white),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.cyan),
                borderRadius: BorderRadius.circular(40),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: widget.colorBW ? Colors.black : Colors.cyan),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: filteredPDFs.isEmpty
            ? Center(
                child: Text(
                "No PDFs found",
                style: TextStyle(
                    color: widget.colorBW ? Colors.black : Colors.white),
              ))
            : ListView.builder(
                itemCount: filteredPDFs.length,
                itemBuilder: (context, index) {
                  final pdf = filteredPDFs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey.shade50,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => pdfviewer(
                                viewer: "Online",
                                url: pdf["url"]!.trim(),
                                filename: pdf["name"]!.trim(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Text(
                              pdf["name"]!.replaceAll(".pdf", ""),
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
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
