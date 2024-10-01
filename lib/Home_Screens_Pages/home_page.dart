import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:itmaterialspoint/Home_Screens_Pages/postUi.dart';

class home_page extends StatefulWidget {
  final bool colorBW;

  const home_page({super.key, required this.colorBW});

  @override
  State<home_page> createState() => home_page_state();
}

class home_page_state extends State<home_page> {
  late CarouselSliderController outerCarouselController =
      CarouselSliderController();

  int outerCurrentPage = 0;

  late Future<List<String>> futureimages;

  Future<List<String>> fetchimageurls() async {
    List<String> imageurl = [];
    final StorageRef = FirebaseStorage.instance.ref("sliderphotos/");
    final listresult = await StorageRef.listAll();

    for (var item in listresult.items) {
      final url = await item.getDownloadURL();
      imageurl.add(url);
    }
    return imageurl;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      futureimages = fetchimageurls();
    });
  }

  void _showPhoto(String imageshow) {
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              content: SizedBox(
                height: 200,
                width: 700,
                child: CachedNetworkImage(
                  imageUrl: imageshow,
                  fit: BoxFit.fitWidth,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: FutureBuilder(
            future: futureimages,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()));
              }
              final imageurls = snapshot.data;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15),
                    ),
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CarouselSlider(
                            carouselController: outerCarouselController,
                            items: imageurls?.map((images) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return InkWell(
                                    onTap: ()=> _showPhoto(images),
                                    child: CachedNetworkImage(
                                      imageUrl: images,
                                      fit: BoxFit.fitWidth,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              aspectRatio: 16 / 8,
                              viewportFraction: .80,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  outerCurrentPage = index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imageurls!.length,
                        (index) {
                          bool isSelected = outerCurrentPage == index;
                          return GestureDetector(
                            onTap: () {
                              outerCarouselController.animateToPage(index);
                            },
                            child: AnimatedContainer(
                              width: isSelected ? 30 : 10,
                              height: 10,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isSelected ? 6 : 3),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(
                                  40,
                                ),
                              ),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
            flex: 3,
            child: Post(
              colorBW: widget.colorBW,
            )),
      ],
    );
  }
}
