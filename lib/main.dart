import 'package:flutter/material.dart';
import 'myCoins.dart' ;
import 'package:habit_coins/me.dart';
import 'package:habit_coins/settings.dart';
import 'package:habit_coins/splash.dart';
import 'package:habit_coins/team.dart';
import 'package:habit_coins/stats.dart';
import 'package:habit_coins/unless.dart';
import 'package:habit_coins/globals.dart' as globals;

void main() {
  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unless HabitCoins',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

        fontFamily: 'Lato',
        buttonColor: Color.fromARGB(255, 53, 83, 165),

        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 53, 83, 165),
          textTheme: TextTheme(
            title: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
      //home: MyHomePage(title: 'HabitCoins'),
    );
  }
}

//Color.fromARGB(255,58, 83, 165),

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  MyCoins c;
  Stats s;
  Team t;
  Unless u;
  List<Widget> _children;
final GlobalKey<MyCoinsState> _key = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    c = new MyCoins(key:_key);
    s = new Stats();
    t = new Team();
    u = new Unless();
    _children = [
      c,
      s, t, u
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/unless.jpg',
              fit: BoxFit.contain,
              height: 100,
            ),
            Image.asset(
              'assets/images/habitcoins logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            // Container(
            //     padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: globals.ShowHelp ? Icon(Icons.help) : Icon(Icons.help_outline),
            onPressed: () {
              globals.ShowHelp = !globals.ShowHelp;
              if(_currentIndex == 0) _key.currentState.refresh();
                
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              globals.ShowHelp = false;
              if(_currentIndex == 0) _key.currentState.refresh();
              openSettings();
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 53, 83, 165),
        selectedItemColor: Colors.white,

        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: buildBottomBar(),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
       backgroundColor: Color.fromARGB(255,53, 83, 165),
        tooltip: 'Add Coin',
        child: Icon(Icons.add),
      ), */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void openSettings() async {
    globals.ShowHelp = false;
    final Settings page = new Settings();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  List<BottomNavigationBarItem> buildBottomBar() {
    List<BottomNavigationBarItem> items = new List();
    // items.add(new BottomNavigationBarItem(
    //   icon: Icon(Icons.person), title: Text('Me')));

    items.add(new BottomNavigationBarItem(
      icon: Icon(Icons.toll),
      title: Text('HabitCoins'),
    ));
    items.add(BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      title: Text('History'),
    ));
    items.add(BottomNavigationBarItem(
        icon: Icon(Icons.people_outline), title: Text('Team')));

    globals.userDetails.isUnless
        ? items.add(new BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Unless')))
        : {};

    return items;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
