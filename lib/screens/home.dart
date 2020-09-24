import 'package:blog_app/screens/creat_blog.dart';
import 'package:blog_app/services/crud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();


  Stream blogsStream;

  Widget BlogList() {
    return Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: blogsStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return BlogsDesign(
                    imgUrl: snapshot.data.docs[index].data()['imageUrl'],
                    title: snapshot.data.docs[index].data()['title'],
                    authorName: snapshot.data.docs[index].data()['authorName'],
                    desc: snapshot.data.docs[index].data()['desc'],
                  );
                });
          },
        ));
  }

  @override
  void initState() {
    super.initState();

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
        if (blogsStream == null) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(fontSize: 22),
            ),
            Text(
              'Blog',
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
          ],
        ),
      ),
      body: Container(
        child: BlogList(),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogsDesign extends StatelessWidget {
  String imgUrl, authorName, title, desc;
  BlogsDesign(
      {@required this.imgUrl,
      @required this.title,
      @required this.authorName,
      @required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  //margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    authorName,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    desc,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 5,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
