import 'package:flutter/material.dart';
import 'package:practice/screen/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giant STORE',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.grey),
      ),
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
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
        backgroundColor:Colors.red,
        title: Text('Giant STORE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            CircleAvatar(radius: 30,
              backgroundColor: Colors.blueGrey,),
            Text('Welcome To Giant STORE', style: TextStyle(fontSize: 20,
              color:Colors.red,
              fontWeight: FontWeight.bold,
            )
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()
                  ),
                  );//Navigator.push(context, route);
            },
                child: Text('My Profile')),
          ],

        ),

      ),




      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

