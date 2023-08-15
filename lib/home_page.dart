import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voice/colors.dart';
import 'package:voice/recorder.dart';
import 'package:voice/speech_screen.dart';

class home_page extends StatelessWidget {
  const home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Yes'))
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade200,
        appBar: AppBar(
          backgroundColor: bgColor,
          centerTitle: true,
          title: const Text(
            'Welcome to this page',
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 110,
                backgroundColor: textColor,
                backgroundImage: AssetImage('assets/images/boy.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                // child:
                //  Card(
                //   shadowColor: bgColor,
                //   elevation: 18,
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                      color: bgColor, borderRadius: BorderRadius.circular(22)),
                  child: const Center(
                    child: Text(
                      'Speech To Text',
                      style: TextStyle(color: textColor, fontSize: 21),
                    ),
                  ),
                ),
                // ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SpeechScreen()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                // child: Card(
                //   shadowColor: bgColor,
                //   elevation: 18,
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                      color: bgColor, borderRadius: BorderRadius.circular(22)),
                  child: const Center(
                    child: Text(
                      'Recorder',
                      style: TextStyle(color: textColor, fontSize: 21),
                    ),
                  ),
                ),
                //  ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const recorder()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
