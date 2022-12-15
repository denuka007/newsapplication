import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_newz/repository/news.dart';
import 'package:s_newz/models/category_model.dart';

import '../repository/data.dart';
import '../models/article_model.dart';
import 'article_view.dart';
import 'category_news.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final searchBarController = TextEditingController();
  List<CategoryModel> categories = List<CategoryModel>.empty(growable: true);
  List<ArticleModel> articles = List<ArticleModel>.empty(growable: true);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  void getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      isLoading = false;
    });
  }

  void getQueryNews() async {
    News newsClass = News();
    await newsClass.getQueryNews(searchBarController.text);
    articles = newsClass.news;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title: GestureDetector(
          onTap: () => {
            // Display a Toast at the center of the screen
            Fluttertoast.showToast(
                msg: "Develop by Denuka Uwanpriya",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0)
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "NEWS",
                style: TextStyle(
                    fontFamily: 'Courgette',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25),
              ),
              Text(
                " Application",
                style: TextStyle(
                    color: Colors.limeAccent,
                    fontFamily: 'Exo',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: "Search",
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 9, horizontal: 0)
                        // border: InputBorder.none,
                        ),
                    controller: searchBarController,
                    onSubmitted: (text) {
                      print(searchBarController.text);
                      isLoading = true;
                      getQueryNews();
                    },
                  ),
                ),
                Container(
                  height: 39,
                  width: MediaQuery.of(context).size.width / 10,
                  // decoration: const BoxDecoration(
                  //   color: Colors.blue,
                  //   borderRadius: BorderRadius.all(Radius.circular(40)),
                  // ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.search,
                    color: Colors.blue,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),

          // Categories
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryTile(
                  imageUrl: categories[index].imageUrl,
                  categoryName: categories[index].categoryName,
                );
              },
            ),
          ),

          // News
          isLoading
              ? Container(
                  margin: const EdgeInsets.only(top: 200),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return BlogTile(
                        imageUrl: articles[index].urlToImage,
                        title: articles[index].title,
                        description: articles[index].description,
                        url: articles[index].url,
                      );
                    },
                  ),
                ),
        ]),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  const CategoryTile({Key key, this.imageUrl, this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNewsView(
                      category: categoryName.toString().toLowerCase(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                width: 150,
                height: 90,
                fit: BoxFit.cover,
                imageUrl: imageUrl,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 150,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black45,
              ),
              child: Text(categoryName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, description, url;
  const BlogTile(
      {Key key, this.imageUrl, this.title, this.description, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl)),
            const SizedBox(height: 7),
            Text(title,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
