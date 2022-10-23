import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:music_app_flutter/network/HttpFactoty.dart';

import 'network/model/Music.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.blueGrey,
            child: ScreenView()),
      ),
    );
  }
}

class ScreenView extends StatefulWidget {
  const ScreenView({Key? key}) : super(key: key);

  @override
  State<ScreenView> createState() => _ScreenViewState();
}

class _ScreenViewState extends State<ScreenView> {
  @override
  Widget build(BuildContext context) {
    return futureBluider();
  }
}
Widget mainContent(Music music){
  final audioPlayer = AudioPlayer();
  return MediaQuery(
    data: MediaQueryData(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
    children: [
      musicSelected(music),
      progressBar(audioPlayer),
      playerButtons(audioPlayer, music)

    ],
    ),
  );
}

Widget futureBluider(){
  return FutureBuilder<Map>(
      future: getData(),
  builder: (context, snapshot){
  switch (snapshot.connectionState) {
  case ConnectionState.none:
  case ConnectionState.waiting:
  return Center(
    child: Carregando("Carregando"),
  );
    default:
      if(snapshot.hasError){
        return Center(child: Carregando("Erro na obtenção dos dados"));
      }else{
        String urlMusic = snapshot.data!["tracks"]["hits"][0]["track"]["hub"]["actions"][1]["uri"];
        String urlCapa = snapshot.data!["tracks"]["hits"][0]["track"]["share"]["image"];
        String title = snapshot.data!["tracks"]["hits"][0]["track"]["title"];
        String author = snapshot.data!["tracks"]["hits"][0]["track"]["subtitle"];
        final eminemMusic = new Music(title, author, urlCapa, urlMusic);

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mainContent(eminemMusic),
            ],
          ),
        );
      }
  }
  });
}

Widget Carregando(String text){
  return Text(text);
}

Widget musicSelected(Music music){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          height: 350,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(music.capaAlbum),
              fit: BoxFit.cover
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),

          )),
        SizedBox(
          height: 5,
        ),
        Icon(
          Icons.favorite_border,
          size: 20.0,
          color: Colors.white,
        ),
        Container(
          height: 50,
        ),
        Text(
          music.title,
          style: TextStyle(
            fontSize: 26.0,
            color: Colors.white,
          ),
        ),
        Text(
          music.author,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            color: Color(0xff29F2FF),
          ),
        ),

      ],
    ),
  );

}

Widget progressBar(AudioPlayer audioPlayer){
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        Container(
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff29F2FF)),
            value: 0.5,
          ),
        ),
        Container(
          padding: EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("00:15"),
              Expanded(child: Container()),
              Text("03:15")
            ],
          ),
        )
      ],
    ),
  );
}

Widget playerButtons(AudioPlayer audioPlayer, Music music){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(onPressed: ()=> audioPlayer.pause(), icon: Icon(Icons.pause_circle, size: 30,color: Color(0xff29F2FF))),
      IconButton(onPressed: () => audioPlayer.play(music.url), icon: Icon(Icons.play_circle, size: 30,color: Color(0xff29F2FF))),
      IconButton(onPressed: () => audioPlayer.stop(), icon: Icon(Icons.stop_circle, size: 30,color: Color(0xff29F2FF)))
    ],
  );

}


