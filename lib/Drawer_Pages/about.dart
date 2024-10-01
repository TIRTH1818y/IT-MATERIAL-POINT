import 'package:flutter/material.dart';

class about_dev extends StatefulWidget {
  final bool colorBW;
  const about_dev({super.key, required this.colorBW});

  @override
  State<about_dev> createState() => _about_devState();
}

class _about_devState extends State<about_dev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.colorBW ? Colors.white : Colors.grey.shade900,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back,
                  color: !widget.colorBW ? Colors.white : Colors.black)),
          backgroundColor:widget.colorBW ? Colors.grey : Colors.black,
          centerTitle: true,
          title: Text(
            "About DEV",
            style: TextStyle(color: widget.colorBW ? Colors.black : Colors.white,),
          ),
        ),
        body: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 40),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/technology/imp.jpg"),
                    radius: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "IT",
                    style: TextStyle(
                        fontFamily: 'karsyu', fontSize: 30, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Material",
                    style: TextStyle(
                        fontFamily: 'karsyu', fontSize: 30, color: Colors.cyan),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Point",
                    style: TextStyle(
                        fontFamily: 'karsyu', fontSize: 30, color: Colors.teal),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25)),
                width: 350,
                height: 360,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "               Welcome to IT MATERIAL POINT, your all-in-one productivity app designed to help learn IT Related all Fields. Whether you're tracking personal goals or collaborating on large-scale projects, IT MATERIAL POINT simplifies your learn and Work With IT Related  Fields, The purpose of creating this application is to teach you in IT Fields. Our Goal is to improvement Your IT skill and Knowledge,This Application Give your Material about you Learn any Technology.",style: TextStyle(color: Colors.black,fontSize: 18),),

                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 150,left: 80),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:10 ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/technology/h.jpg"),radius: 40,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 60),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/technology/t.jpg"),radius: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70,top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:10 ),
                    child: Text("Himanshu Jadav",style: TextStyle(color: widget.colorBW ? Colors.black : Colors.white,fontFamily: 'teko',fontSize: 15),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text("Tirth Sonigara",style: TextStyle(color:  widget.colorBW ? Colors.black : Colors.white,fontFamily: 'teko',fontSize: 15),),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}