import 'package:flutter/material.dart';
import 'package:habit_coins/myCoins.dart';
import 'package:habit_coins/me.dart';
import 'package:habit_coins/splash.dart';
import 'package:habit_coins/team.dart';
import 'package:habit_coins/stats.dart';









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
        buttonColor: Color.fromARGB(255,53, 83, 165),
        
        appBarTheme: AppBarTheme(


          color: Color.fromARGB(255,53, 83, 165),
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
      home:  Splash(),
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
 
  int _currentIndex = 1;

  List<Widget> _children = [
    new Me(),
    new MyCoins(),
    new Stats(),
    new Team(),
  ];


 
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
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/unless.jpg',
              fit: BoxFit.contain,
              height: 100,
            ),
            Container(
                padding: const EdgeInsets.all(6.0), child: Text(widget.title),)
          ],

        ),



      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255,53, 83, 165),
        selectedItemColor: Colors.white,

        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Me'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.toll),
            title: Text('HabitCoins'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('History'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              title: Text('Team')
          ),

        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
       backgroundColor: Color.fromARGB(255,53, 83, 165),
        tooltip: 'Add Coin',
        child: Icon(Icons.add),
      ), */// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
