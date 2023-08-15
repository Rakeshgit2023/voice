import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voice/colors.dart';
import 'package:voice/recorder.dart';

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

// ignore: camel_case_types
class list_recorder extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final List<AudioItem> array_audio;
  // ignore: non_constant_identifier_names
  final List<String> array_name;
  // ignore: non_constant_identifier_names
  const list_recorder(
      {Key? key, required this.array_audio, required this.array_name})
      : super(key: key);

  @override
  State<list_recorder> createState() => list_recorderState();
}

// ignore: camel_case_types
class list_recorderState extends State<list_recorder> {
  bool play_Audio = false;
  late FlutterSoundRecorder _recordingSession;

  final recordingPlayer = AssetsAudioPlayer();

  Future<void> playFunction(String path) async {
    recordingPlayer.open(
      Audio.file(path),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlayFunc() async {
    setState(() {
      play_Audio = false;

      //play = false;
    });

    recordingPlayer.stop();
  }

  void stopAllOtherAudioItems(AudioItem currentItem) {
    for (var item in widget.array_audio) {
      if (item != currentItem && item.isPlaying) {
        item.isPlaying = false;

        recordingPlayer.stop();
      }
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
          'List Of Audio',
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.array_audio.isEmpty
                ? const Center(
                    child: Text(
                    'No Audio Yet...',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                      itemCount: widget.array_audio.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shadowColor: bgColor,
                          elevation: 12,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: bgColor,
                                child: InkWell(
                                    child: widget.array_audio[index].isPlaying
                                        ? const Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                    onTap: () {
                                      setState(() {
                                        if (!widget
                                            .array_audio[index].isPlaying) {
                                          stopAllOtherAudioItems(
                                              widget.array_audio[index]);

                                          playFunction(
                                              widget.array_audio[index].path);

                                          widget.array_audio[index].isPlaying =
                                              true;
                                        } else {
                                          stopPlayFunc();

                                          widget.array_audio[index].isPlaying =
                                              false;
                                        }
                                      });
                                    }),
                                //Icon(Icons.play_arrow),
                              ),
                              title: Text(widget.array_name[index]),
                              // Text('Recorder-${index + 1}'),
                              trailing: SizedBox(
                                width: 20,
                                child: PopupMenuButton(
                                  child: const Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 10),
                                          Text('Delete'),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          widget.array_audio.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
