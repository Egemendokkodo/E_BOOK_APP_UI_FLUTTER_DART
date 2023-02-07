import 'dart:convert';
import 'package:e_book_app/my_tabs.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // resim eklemek için pubspec.yaml da belirttim. img klasörü oluşturup altına eklemek istediğim resmi koydum
  // img/square.png
  List popularBooks = [];
  List books = [];
  late ScrollController _scrollController;
  late TabController _tabController;
  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) {
      setState(() {
        popularBooks = json.decode(s);
      });
    });
    await DefaultAssetBundle.of(context)
        .loadString("json/books.json")
        .then((s) {
      setState(() {
        books = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          // notification bar
          child: Scaffold(
        body: Column(
          children: [
            Container(
              // en üsttelki toolbar
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageIcon(
                    AssetImage("img/square.png"),
                    size: 24,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.notifications),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              // popular books ve en üstteki toolbar ı birbirinden ayıran boşluk, placeholder.
              height: 20,
            ), // üstteki yerle alttaki yerin arasına boşluk koymak için bunu kullanırız.
            Row(
              // popular books satırı
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text("Popular Books", style: TextStyle(fontSize: 20)),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ), // placeholder
            Container(
              // recyclerview kısmı
              height: 180,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: -20,
                  right: 0,
                  child: Container(
                    height: 180,
                    child: PageView.builder(
                        // RECYCLERVİEW
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: popularBooks.length,
                        itemBuilder: (_, i) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(popularBooks[i]["img"]),
                                  fit: BoxFit.fill,
                                )),
                          );
                        }),
                  ),
                )
              ]),
            ),
            Expanded(
                child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (BuildContext context, bool isScroll) {
                      return [
                        SliverAppBar(
                            backgroundColor: Colors.white,
                            pinned: true,
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(50),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 20, left: 20),
                                child: TabBar(
                                  indicatorPadding: const EdgeInsets.all(0),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelPadding:
                                      const EdgeInsets.only(right: 10),
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 7,
                                          offset: Offset(0, 0),
                                        )
                                      ]),
                                  tabs: [
                                    AppTabs(color: Colors.yellow, text: "New"),
                                    AppTabs(
                                        color: Colors.redAccent,
                                        text: "Popular"),
                                    AppTabs(
                                        color: Colors.cyan, text: "Trending"),
                                    AppTabs(
                                        color: Colors.green, text: "Most Liked"),
                                  ],
                                ),
                              ),
                            ))
                      ];
                    },
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                            itemCount: books.length,
                            itemBuilder: (_, i) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xfff2f2f2),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          offset: Offset(0, 0),
                                          color: Colors.grey.withOpacity(0.2),
                                        )
                                      ]),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 90,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      books[i]["img"]),
                                                ))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.star,
                                                    size: 24,
                                                    color: Color(0xffffd700)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(books[i]["rating"],
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            ),
                                            Text(
                                              books[i]["title"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Avenir",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              books[i]["text"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Avenir",
                                                  color: Color(0xffdcdcdc)),
                                            ),
                                            Container(
                                              width: 60,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.blue),
                                              child: Text(
                                                "Love",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Avenir",
                                                    color: Colors.white),
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.grey),
                            title: Text("Content"),
                          ),
                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.grey),
                            title: Text("Content"),
                          ),
                        ),
                        Material(
                          child: ListTile(
                            leading: CircleAvatar(backgroundColor: Colors.grey),
                            title: Text("Content"),
                          ),
                        ),
                      ],
                    )))
          ],
        ),
      )),
    );
  }
}
