import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice/colors.dart';

import 'dart:async';

import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:path/path.dart' as path;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:voice/list_recorder.dart';

// ignore: camel_case_types
class recorder extends StatefulWidget {
  const recorder({Key? key}) : super(key: key);
  @override
  State<recorder> createState() => recorderState();
}

// ignore: camel_case_types
class recorderState extends State<recorder> {
  bool isanimate = false;

  late FlutterSoundRecorder _recordingSession;

  final recordingPlayer = AssetsAudioPlayer();

  String pathToAudio = '';

  bool playAudio = false;

  bool isRecording = false;
  // ignore: non_constant_identifier_names
  List<AudioItem> array_audio = [];
  // ignore: non_constant_identifier_names
  List<String> array_name = [];
  // ignore: prefer_typing_uninitialized_variables
  var filename;
  bool play = false;
  bool recordState = false;

  final Stopwatch timerText = Stopwatch();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    initializer();
  }

  void initializer() async {
    _recordingSession = FlutterSoundRecorder();

    await _recordingSession.openRecorder();

    await _recordingSession
        .setSubscriptionDuration(const Duration(milliseconds: 10));

    await initializeDateFormatting();

    await Permission.microphone.request();

    await Permission.storage.request();

    await Permission.manageExternalStorage.request();
  }

  Future<void> startRecording() async {
    String currentTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

    filename = 'Rec$currentTime';
    print('$filename..................rakesh shaw');

    pathToAudio = '/sdcard/Download/$filename.wav';
    Directory directory = Directory(path.dirname(pathToAudio));

    if (!directory.existsSync()) {
      directory.createSync();
    }

    _recordingSession.openRecorder();

    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      codec: Codec.pcm16WAV,
    );

    timerText.start();

    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => setState(() {}));

    setState(() {
      isRecording = true;
      recordState = true;
    });
  }

  Future<String?> stopRecording() async {
    setState(() {
      isRecording = false;
      //  array_name.add(filename);
      //filename = '';
    });

    _recordingSession.closeRecorder();
    timerText.stop();

    timerText.reset();

    timer?.cancel();
    return await _recordingSession.stopRecorder();
  }

  Future<void> stopPlayFunc() async {
    setState(() {
      playAudio = false;

      //play = false;
    });

    recordingPlayer.stop();
  }

  Future<void> playFunc() async {
    if (recordState) {
      recordingPlayer.open(
        Audio.file(pathToAudio),
        autoStart: true,
        showNotification: true,
      );

      setState(() {
        playAudio = true;
      });
    } else {
      showDialog(
          context: context,
          // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
          builder: (BuildContext) {
            return AlertDialog(
              title: const Text(
                'Warning',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text('Please hold on mic and record something.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: true,
        title: const Text(
          'Record Audio',
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              child: Center(
                // ignore: avoid_unnecessary_containers
                child: CircleAvatar(
                  radius: 115,
                  backgroundColor: bgColor,
                  child: Container(
                    width: 224,
                    height: 224,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(112),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(4, 4)),
                        ]),
                    child: Center(
                      child: Text(
                        "${timerText.elapsed.inHours.toString().padLeft(2, "0")}:"
                        "${(timerText.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:"
                        "${(timerText.elapsed.inSeconds % 60).toString().padLeft(2, "0")}",
                        style: const TextStyle(
                          fontSize: 50,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'rakesh1',
                  onPressed: playAudio ? stopPlayFunc : playFunc,
                  child: playAudio
                      ? const CircleAvatar(
                          backgroundColor: bgColor,
                          radius: 35,
                          child: Icon(
                            Icons.stop,
                            color: Colors.white,
                          ),
                        )
                      : const CircleAvatar(
                          backgroundColor: bgColor,
                          radius: 35,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                ),
                AvatarGlow(
                  endRadius: 75.0,
                  animate: isanimate,
                  duration: const Duration(milliseconds: 2000),
                  glowColor: bgColor,
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  showTwoGlows: true,
                  child: GestureDetector(
                    onTapDown: (details) async {
                      setState(() {
                        isanimate = true;
                        startRecording();
                      });
                    },
                    onTapUp: (details) {
                      setState(() {
                        isanimate = false;
                      });
                      stopRecording();
                    },
                    child: CircleAvatar(
                      backgroundColor: bgColor,
                      radius: 35,
                      child: Icon(isanimate ? Icons.mic : Icons.mic_none,
                          color: Colors.white),
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'rakesh2',
                  onPressed: () {
                    // var pathAudio = pathToAudio;
                    setState(() {
                      if (pathToAudio.isNotEmpty) {
                        //pathToAudio = '';
                        array_audio.add(AudioItem(path: pathToAudio));
                        pathToAudio = '';
                        recordState = false;
                        array_name.add(filename);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Audio saved successfully.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      } else {
                        showDialog(
                            context: context,
                            // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                            builder: (BuildContext) {
                              return AlertDialog(
                                title: const Text(
                                  'Message',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: const Text(
                                    'Please hold on mic and record something then click on save button.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });
                      }
                    });
                  },
                  child: const CircleAvatar(
                    backgroundColor: bgColor,
                    radius: 35,
                    child: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            FloatingActionButton(
              heroTag: 'rakesh3',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => list_recorder(
                            array_audio: array_audio, array_name: array_name)));
              },
              child: const CircleAvatar(
                backgroundColor: bgColor,
                radius: 35,
                child: Icon(
                  Icons.note_alt_sharp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioItem {
  String path;

  bool isPlaying;

  AudioItem({required this.path, this.isPlaying = false});
}
