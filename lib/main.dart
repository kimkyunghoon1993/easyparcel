import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: '필드서비스 쉬운택배 서비스',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = GeneratorPage();
        break;
      case 2:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff12237e),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'PILDSERVICE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/image/sukuna.png'),
              ),
              accountName: Text(''),
              accountEmail: Text('abcd123456@naver.com'),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: Icon(Icons.home),
              iconColor: colorScheme.primary,
              focusColor: colorScheme.primary,
              title: Text('홈'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.format_list_numbered),
              iconColor: colorScheme.primary,
              focusColor: colorScheme.primary,
              title: Text('배송 내역'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.mark_as_unread_sharp),
              iconColor: colorScheme.primary,
              focusColor: colorScheme.primary,
              title: Text('편지함'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.restore_from_trash),
              iconColor: colorScheme.primary,
              focusColor: colorScheme.primary,
              title: Text('휴지통'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: colorScheme.primary,
              focusColor: colorScheme.primary,
              title: Text('설정'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed, // item이 4개 이상일 경우 추가
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'main',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Color(0xff101c5d),
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label:
                            Text('main', style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label:
                        Text('Home', style: TextStyle(color: Colors.white)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  final VisibleModel _visible = VisibleModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xff12237e),
            width: 600,
            height: 150,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            '물건 보낼 땐, 필드서비스!!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    width: 335,
                    height: 50,
                    color: Color.fromARGB(255, 32, 43, 55),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true, // 모달의 기본 높이 제거
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter bottomState) {
                                        return ListenableBuilder(
                                          listenable: _visible,
                                          builder: (BuildContext context, Widget? child) {
                                            return Visibility(
                                              visible: _visible._isVisible,
                                              child: Container(
                                                height: 600,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                          child: Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                            alignment: Alignment.topRight,
                                                            child: Column(
                                                              children: [
                                                                IconButton(
                                                                    icon: const Icon(Icons.close),
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    }
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.fromLTRB(15, 8, 0, 10),
                                                            alignment: Alignment.centerLeft,
                                                            child: Text('출발지', style: TextStyle(color: Colors.black),
                                                            ),
                                                          ),
                                                          Container(
                                                              padding:
                                                                  EdgeInsets.fromLTRB(
                                                                      10, 0, 10, 0),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 30.0,
                                                                    child:  TextField(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.all(10),
                                                                        border: OutlineInputBorder(),
                                                                        hintText: '주소 검색',
                                                                        hintStyle: TextStyle(),
                                                                        suffixIcon: IconButton(
                                                                            icon: const Icon(Icons.search,),
                                                                            onPressed: () {
                                                                              bottomState(() {
                                                                                _visible.setVisible(false);
                                                                              });

                                                                              var secondModal = SecondModal(context, _visible);
                                                                              secondModal.showSecondModal();
                                                                            },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                                  Container(
                                                                    height: 30.0,
                                                                    child:  TextField(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.all(10),
                                                                        border: OutlineInputBorder(),
                                                                        hintText: '상세 주소',
                                                                        hintStyle: TextStyle(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                                  Container(
                                                                    height: 30.0,
                                                                    child:  TextField(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.all(10),
                                                                        border: OutlineInputBorder(),
                                                                        hintText: '이름',
                                                                        hintStyle: TextStyle(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                                  Container(
                                                                    height: 30.0,
                                                                    child:  TextField(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.all(10),
                                                                        border: OutlineInputBorder(),
                                                                        hintText: '전화 번호',
                                                                        hintStyle: TextStyle(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                                  Container(
                                                                    height: 30.0,
                                                                    child:  TextField(
                                                                      decoration: InputDecoration(
                                                                        isDense: true,
                                                                        contentPadding: EdgeInsets.all(10),
                                                                        border: OutlineInputBorder(),
                                                                        hintText: '픽업 기사님께 메시지 전달',
                                                                        hintStyle: TextStyle(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                                    Colors
                                                                                        .white30),
                                                                          ),
                                                                          onPressed:
                                                                              () {},
                                                                          child: Text(
                                                                            '주소록',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black),
                                                                          )),
                                                                      Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                                  right:
                                                                                      8.0)),
                                                                      ElevatedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                                    Colors
                                                                                        .white30),
                                                                          ),
                                                                          onPressed:
                                                                              () {},
                                                                          child: Text(
                                                                            '집',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black),
                                                                          )),
                                                                      Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              right:
                                                                              8.0)),
                                                                      ElevatedButton(
                                                                          style:
                                                                          ButtonStyle(
                                                                            backgroundColor:
                                                                            MaterialStateProperty.all(
                                                                                Colors
                                                                                    .white30),
                                                                          ),
                                                                          onPressed:
                                                                              () {},
                                                                          child: Text(
                                                                            '회사',
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .black),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(top: 70.0)),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 8)),
                                                                      Text(
                                                                        '최근 배송에서 선택',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,letterSpacing: 2.0),
                                                                      ),
                                                                      Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 8)),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '최근 배송 건이 없습니다.',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(bottom: 30.0)),
                                                                  Column(
                                                                    children: [
                                                                      ElevatedButton(
                                                                        child: Text('출발지 설정', style: TextStyle(color: Colors.white),),
                                                                        onPressed: () {},
                                                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                            return states.contains(
                                                                                    MaterialState.pressed) ? Colors.green : Colors.grey;
                                                                          }
                                                                        ),
                                                                        fixedSize: MaterialStateProperty.resolveWith((states) {
                                                                          return states.contains(MaterialState.pressed) ? Size(300, 100) : Size(350, 50);
                                                                          }
                                                                        ),
                                                                          // Set elevation regardless of states
                                                                          elevation: MaterialStateProperty
                                                                              .resolveWith(
                                                                                  (states) {
                                                                            return 20.0;
                                                                          }),
                                                                        ),
                                                                      ),
                                                                      Padding(padding: EdgeInsets.only(bottom: 40.0)),
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                        ],

                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      }
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '출발',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),


                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true, // 모달의 기본 높이 제거
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 600,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                      alignment: Alignment.topRight,
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                              icon: const Icon(Icons.close),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(15, 8, 0, 10),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text('출발지', style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 0),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '주소 검색',
                                                                  hintStyle: TextStyle(),
                                                                  suffixIcon: IconButton(
                                                                      icon: const Icon(Icons.search,),
                                                                      onPressed: () {}
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                    8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '상세 주소',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '이름',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '전화 번호',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '픽업 기사님께 메시지 전달',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '주소록',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '집',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '회사',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(top: 70.0)),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 8)),
                                                                Text(
                                                                  '최근 배송에서 선택',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,letterSpacing: 2.0),
                                                                ),
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 8)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '최근 배송 건이 없습니다.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 30.0)),
                                                            Column(
                                                              children: [
                                                                ElevatedButton(
                                                                  child: Text('출발지 설정', style: TextStyle(color: Colors.white),),
                                                                  onPressed: () {},
                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                    return states.contains(
                                                                        MaterialState.pressed) ? Colors.green : Colors.grey;
                                                                  }
                                                                  ),
                                                                    fixedSize: MaterialStateProperty.resolveWith((states) {
                                                                      return states.contains(MaterialState.pressed) ? Size(300, 100) : Size(350, 50);
                                                                    }
                                                                    ),
                                                                    // Set elevation regardless of states
                                                                    elevation: MaterialStateProperty
                                                                        .resolveWith(
                                                                            (states) {
                                                                          return 20.0;
                                                                        }),
                                                                  ),
                                                                ),
                                                                Padding(padding: EdgeInsets.only(bottom: 40.0)),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ],

                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text('출발지 설정', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 335,
                    height: 50,
                    color: Color.fromARGB(255, 32, 43, 55),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true, // 모달의 기본 높이 제거
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 600,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                      alignment: Alignment.topRight,
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                              icon: const Icon(Icons.close),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(15, 8, 0, 10),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text('도착지', style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 0),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '주소 검색',
                                                                  hintStyle: TextStyle(),
                                                                  suffixIcon: IconButton(
                                                                      icon: const Icon(Icons.search,),
                                                                      onPressed: () {}
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                    8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '상세 주소',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '이름',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '전화 번호',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '픽업 기사님께 메시지 전달',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '주소록',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '집',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '회사',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(top: 70.0)),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 8)),
                                                                Text(
                                                                  '최근 배송에서 선택',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,letterSpacing: 2.0),
                                                                ),
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 8)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '최근 배송 건이 없습니다.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 30.0)),
                                                            Column(
                                                              children: [
                                                                ElevatedButton(
                                                                  child: Text('도착지 설정', style: TextStyle(color: Colors.white),),
                                                                  onPressed: () {},
                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                    return states.contains(
                                                                        MaterialState.pressed) ? Colors.green : Colors.grey;
                                                                  }
                                                                  ),
                                                                    fixedSize: MaterialStateProperty.resolveWith((states) {
                                                                      return states.contains(MaterialState.pressed) ? Size(300, 100) : Size(350, 50);
                                                                    }
                                                                    ),
                                                                    // Set elevation regardless of states
                                                                    elevation: MaterialStateProperty
                                                                        .resolveWith(
                                                                            (states) {
                                                                          return 20.0;
                                                                        }),
                                                                  ),
                                                                ),
                                                                Padding(padding: EdgeInsets.only(bottom: 40.0)),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ],

                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '도착',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true, // 모달의 기본 높이 제거
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 600,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                                      alignment: Alignment.topRight,
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                              icon: const Icon(Icons.close),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              }
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.fromLTRB(15, 8, 0, 10),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text('도착지', style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                        padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 10, 0),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '주소 검색',
                                                                  hintStyle: TextStyle(),
                                                                  suffixIcon: IconButton(
                                                                      icon: const Icon(Icons.search,),
                                                                      onPressed: () {}
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                    8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '상세 주소',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '이름',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '전화 번호',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Container(
                                                              height: 30.0,
                                                              child:  TextField(
                                                                decoration: InputDecoration(
                                                                  isDense: true,
                                                                  contentPadding: EdgeInsets.all(10),
                                                                  border: OutlineInputBorder(),
                                                                  hintText: '픽업 기사님께 메시지 전달',
                                                                  hintStyle: TextStyle(),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 8.0)),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '주소록',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '집',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        8.0)),
                                                                ElevatedButton(
                                                                    style:
                                                                    ButtonStyle(
                                                                      backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .white30),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                      '회사',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                    )),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(top: 70.0)),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 8)),
                                                                Text(
                                                                  '최근 배송에서 선택',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,letterSpacing: 2.0),
                                                                ),
                                                                Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 8)),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '최근 배송 건이 없습니다.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.only(bottom: 30.0)),
                                                            Column(
                                                              children: [
                                                                ElevatedButton(
                                                                  child: Text('도착지 설정', style: TextStyle(color: Colors.white),),
                                                                  onPressed: () {},
                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                                                                    return states.contains(
                                                                        MaterialState.pressed) ? Colors.green : Colors.grey;
                                                                  }
                                                                  ),
                                                                    fixedSize: MaterialStateProperty.resolveWith((states) {
                                                                      return states.contains(MaterialState.pressed) ? Size(300, 100) : Size(350, 50);
                                                                    }
                                                                    ),
                                                                    // Set elevation regardless of states
                                                                    elevation: MaterialStateProperty
                                                                        .resolveWith(
                                                                            (states) {
                                                                          return 20.0;
                                                                        }),
                                                                  ),
                                                                ),
                                                                Padding(padding: EdgeInsets.only(bottom: 40.0)),
                                                              ],
                                                            )
                                                          ],
                                                        )),
                                                  ],

                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                '도착지 설정',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 400,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(Icons.local_shipping),
                            onPressed: () {}),
                      ],
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }

}

class VisibleModel with ChangeNotifier {
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  setVisible(bool isVisible) {
    _isVisible = isVisible;
    print('setState: 토글 상태 $_isVisible');
    notifyListeners();
  }

}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              for (var pair in appState.favorites)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeFavorite(pair);
                    },
                  ),
                  title: Text(
                    pair.asLowerCase,
                    semanticsLabel: pair.asPascalCase,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SecondModal {
  final VisibleModel visibleModel;
  BuildContext context;

  SecondModal(this.context, this.visibleModel);

  void showSecondModal() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListenableBuilder(
          listenable: visibleModel,
          builder: (BuildContext context, Widget? child) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter bottomState){
                  return Container(
                    width: 400,
                    height: 600, // 적절한 높이로 조절하세요
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 8, 2, 5),
                              alignment: Alignment.topRight,
                              child: Center(
                                child: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      // 데이터 같이 넘길 수 있음
                                      visibleModel.setVisible(true);
                                      Navigator.of(context).pop();
                                    }
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(12, 2, 12, 0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(),
                                    hintText: '도로명,지번,건물명을 입력하세요',
                                    hintStyle: TextStyle(),
                                    suffixIcon: IconButton(
                                        icon: const Icon(Icons.search,),
                                        onPressed: () {
                                        }
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 350,
                              height: 150,
                              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 8.0)),
                                  Text('검색방법',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Padding(padding: EdgeInsets.only(top: 8.0)),
                                  Text('-동/읍/면/리 + 번지 (예 : 논현동 87-2)'),
                                  Text('-도로명 + 건물번호 입력 (예 : 논현로 132길 6)'),
                                  Text('-동/읍/면/리 + 번지 (예 : 논현동 87-2)'),
                                ],
                              ),
                            )

                          ],
                        ),
                      ],
                    ),
                  );
                }
            );
          }
        );
      },
    );
  }

}



class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
