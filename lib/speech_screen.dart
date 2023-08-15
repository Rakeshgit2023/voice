// ignore: file_names
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice/list_class.dart';
import 'colors.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);
  @override
  State<SpeechScreen> createState() => SpeechScreenState();
}

class SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  // ignore: non_constant_identifier_names
  List<String> notes = [];
  var text = "Hold the button and start speaking";
  var isListening = false;
  // ignore: prefer_typing_uninitialized_variables
  var note;

  @override
  Widget build(BuildContext context) {
    return
        //  WillPopScope(
        //   onWillPop: () async {
        //     final value = await showDialog<bool>(
        //         context: context,
        //         builder: (context) {
        //           return AlertDialog(
        //             title: const Text('Exit App'),
        //             content: const Text('Are you sure you want to exit?'),
        //             actions: [
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop(false);
        //                   },
        //                   child: const Text('No')),
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop(true);
        //                   },
        //                   child: const Text('Yes'))
        //             ],
        //           );
        //         });
        //     if (value != null) {
        //       return Future.value(value);
        //     } else {
        //       return Future.value(false);
        //     }
        //   },
        //   child:
        Scaffold(
      backgroundColor: Colors.green.shade100,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 500),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'button1',
                onPressed: () {
                  setState(() {
                    Transform.rotate(
                      angle: 91 * pi / 180,
                      child: const Icon(Icons.refresh),
                    );
                    text = "Hold the button and start speaking";
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: bgColor,
                  radius: 35,
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
              ),
              AvatarGlow(
                endRadius: 75.0,
                animate: isListening,
                duration: const Duration(milliseconds: 2000),
                glowColor: bgColor,
                repeat: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                showTwoGlows: true,
                child: GestureDetector(
                  onTapDown: (details) async {
                    if (!isListening) {
                      var available = await speechToText.initialize();
                      if (available) {
                        setState(() {
                          isListening = true;
                          speechToText.listen(
                            onResult: (result) {
                              if (text ==
                                  "Hold the button and start speaking") {
                                text = '';
                              } else {
                                if (result.finalResult) {
                                  setState(() {
                                    text = '$text ${result.recognizedWords}';
                                  });
                                }
                              }
                            },
                          );
                        });
                      }
                    }
                  },
                  onTapUp: (details) {
                    setState(() {
                      isListening = false;
                    });
                    speechToText.stop();
                  },
                  child: CircleAvatar(
                    backgroundColor: bgColor,
                    radius: 35,
                    child: Icon(isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white),
                  ),
                ),
              ),
              FloatingActionButton(
                heroTag: 'button2',
                onPressed: () {
                  note = '';
                  if (text != 'Hold the button and start speaking') {
                    note = text;
                  }
                  setState(() {
                    text = 'Hold the button and start speaking';
                    if (note.isNotEmpty) {
                      notes.add(note);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Text saved successfully.'),
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
                                  'Please hold on mic and speech something then click on save button.'),
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
            heroTag: 'button3',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => list(notes: notes)));
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
      appBar: AppBar(
          // leading: IconButton(
          //  icon: const Icon(
          //   Icons.list,
          // color: Colors.white,
          // ),
          //   onPressed: () {
          //  Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => list(notes: notes)));
          //   },
          //  ),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0.0,
          title: const Text(
            "Speech to text",
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          )),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Container(
          // color: Colors.grey.shade300,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.only(bottom: 150),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
    //);
  }
}
