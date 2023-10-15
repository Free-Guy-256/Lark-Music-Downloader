import 'package:flutter/material.dart';
import 'download_box.dart';
import 'package:permission_handler/permission_handler.dart';

late double screen_width = 0;
late double screen_height = 0;
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.storage.request().isGranted) {
  // Either the permission was already granted before or the user just granted it.
}
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Lark Music", style: TextStyle(fontStyle: FontStyle.italic)),backgroundColor: Colors.black87),
        body: Container(
          color: Colors.black87,
          height: screen_height,
          width: screen_width,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: screen_width,height: (screen_height*0.01),color: Color.fromARGB(255, 5, 61, 104)),
              Container(
                width: screen_width,
                height: (screen_height*0.1),
                child:MusicDl_boxx((screen_height*0.7),screen_width)),
                Container(child:MusicPlayer()),
                /*Container(color:Colors.green,height:(screen_height*0.7),width:screen_width,
                child: Downloads())*/
               Expanded(
                  child: Downloads()
                  )
              
                //Downloads()
            ],
          ),
        ),
      ),
    );
  }
}
