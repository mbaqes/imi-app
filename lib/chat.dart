import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late IO.Socket socket;

  TextEditingController msgInputcontrole = TextEditingController();
  @override
  void initState() {
    socket = IO.io(
        'http://localhost:3000',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            // .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.emit(
      "joinRoom",
      {
        "username": "socket.id",
        "room": "message", //--> message to be sent
      },
    );
    socket.on('message', (data) {
      print(data); //
    });
    socket.on('roomUsers', (data) {
      print(data); //
    });

    socket.connect();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                child: ListView.builder(itemBuilder: (context, index) {
                  return MessgeItem(
                    sentbyme: true,
                  );
                }),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: TextField(
                  controller: msgInputcontrole,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white)),
                      suffixIcon: Container(
                        child: IconButton(
                          onPressed: () {
                            sendMessage(msgInputcontrole.text);
                            msgInputcontrole.text = "";
                          },
                          icon: Icon(Icons.send),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(String message) {
    socket.emit('chatMessage', message);
  }
}

class MessgeItem extends StatelessWidget {
  MessgeItem({Key? key, required this.sentbyme}) : super(key: key);
  final bool sentbyme;
  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: sentbyme ? purple : Colors.white,
        ),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "1:10 AM",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
