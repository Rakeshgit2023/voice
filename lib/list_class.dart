import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice/colors.dart';
//import 'package:flutter/services.dart';

// ignore: camel_case_types
class list extends StatefulWidget {
  final List<String> notes;

  const list({Key? key, required this.notes}) : super(key: key);

  @override
  State<list> createState() => listState();
}

// ignore: camel_case_types
class listState extends State<list> {
  TextEditingController textController = TextEditingController();
  int selectedIndex = -1;
  TextEditingController names = TextEditingController();
  var isListening = false;
  SpeechToText speechToText = SpeechToText();
  TextEditingController textController1 = TextEditingController();
  List<String> select = [];
  bool tikmark = false;
  int alterIndex = -1;

  // final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  //     GlobalKey<ScaffoldMessengerState>();

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<String?> displayFileNameDialog(BuildContext context) async {
    final fileNameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter File Name'),
          content: TextFormField(
            controller: fileNameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'File Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(fileNameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void writeToFile(String notes) async {
    try {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if (!permissionStatus.isGranted) {
        PermissionStatus newPermissionStatus =
            await Permission.storage.request();
        if (!newPermissionStatus.isGranted) {
          return;
        }
      }
      String? directory = await FilePicker.platform.getDirectoryPath();
      // ignore: use_build_context_synchronously
      String? fileName = await displayFileNameDialog(context);

      if (fileName == null || fileName.isEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No filename provided. Note was not saved.'),
          ),
        );
        return;
      }

      String filePath = '$directory/$fileName.txt';
      final file = File(filePath);

      if (file.existsSync()) {
        // ignore: use_build_context_synchronously
        bool replaceFile = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('File Already Exists'),
              content: const Text('Do you want to replace the existing file?'),
              actions: <Widget>[
                // TextButton(
                //   child: const Text('Cancel'),
                //   onPressed: () {
                //     Navigator.of(context).pop(false);
                //   },
                // ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Replace'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (!replaceFile) {
          return;
        }
      }

      //   if (conflictResult == FileConflictResult.changeName) {
      //     // ignore: use_build_context_synchronously
      //     fileName = await displayFileNameDialog(context);
      //     if (fileName == null || fileName.isEmpty) {
      //       _scaffoldMessengerKey.currentState?.showSnackBar(
      //         const SnackBar(
      //           content: Text('No filename provided. Note was not saved.'),
      //           // Red color for failure
      //         ),
      //       );
      //       return;
      //     }
      //     filePath = "$directory/$fileName.txt";
      //     file.renameSync(filePath);
      //   } else if (conflictResult == FileConflictResult.replace) {
      //     // Do nothing here, the file will be replaced below
      //   } else {
      //     // User canceled the operation
      //     return;
      //   }
      // }

      await file.writeAsString(notes);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note saved successfully under the name: $fileName'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save note.'),
        ),
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Give Permission for allow management of all files.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // void writeToFile(String notes) async {
  //   try {
  //     PermissionStatus permissionStatus = await Permission.storage.status;
  //     if (!permissionStatus.isGranted) {
  //       PermissionStatus newPermissionStatus =
  //           await Permission.storage.request();
  //       if (!newPermissionStatus.isGranted) {
  //         return;
  //       }
  //     }
  //     String? directory = await FilePicker.platform.getDirectoryPath();
  //     String? fileName;
  //     String filePath;

  //     do {
  //       // ignore: use_build_context_synchronously
  //       fileName = await displayFileNameDialog(context);
  //       if (fileName == null || fileName.isEmpty) {
  //         _scaffoldMessengerKey.currentState?.showSnackBar(
  //           const SnackBar(
  //             content: Text('No filename provided. Note was not saved.'),
  //             backgroundColor: Colors.red, // Red color for failure
  //           ),
  //         );
  //         return;
  //       }
  //       filePath = '$directory/$fileName.txt';
  //       final file = File(filePath);
  //       if (file.existsSync()) {
  //         // ignore: use_build_context_synchronously
  //         FileConflictResult conflictResult = await showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('File Already Exists'),
  //               content: const Text(
  //                 'A file with the same name already exists. Do you want to change the file name again?',
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('Change Name'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(FileConflictResult.changeName);
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: const Text('Replace'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(FileConflictResult.replace);
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );

  //         if (conflictResult == FileConflictResult.replace) {
  //           // Replace the existing file with the new one
  //           break;
  //         }
  //       } else {
  //         break;
  //       }
  //     } while (true);

  //     final file = File(filePath);
  //     await file.writeAsString(notes);

  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(
  //         content: Text('Note saved successfully under the name: $fileName'),
  //         backgroundColor: Colors.green, // Green color for success
  //       ),
  //     );
  //   } catch (e) {
  //     // print(e);
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       const SnackBar(
  //         content: Text('Failed to save note.'),
  //         backgroundColor: Colors.red, // Red color for failure
  //       ),
  //     );
  //   }
  // }

  void _downloadListToFile(List<String> strings) async {
    try {
      PermissionStatus permissionStatus = await Permission.storage.status;

      if (!permissionStatus.isGranted) {
        PermissionStatus newPermissionStatus =
            await Permission.storage.request();

        if (!newPermissionStatus.isGranted) {
          return;
        }
      }

      String? directory = await FilePicker.platform.getDirectoryPath();

      // ignore: use_build_context_synchronously
      String? fileName = await displayFileNameDialog(context);

      if (fileName == null || fileName.isEmpty) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No filename provided. Note was not saved.'),
          ),
        );
        return;
      }

      String filePath = "$directory/$fileName.txt";

      final file = File(filePath);

      if (file.existsSync()) {
        // ignore: use_build_context_synchronously
        bool replaceFile = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('File Already Exists'),
              content: const Text('Do you want to replace the existing file?'),
              actions: <Widget>[
                // TextButton(
                //   child: const Text('Cancel'),
                //   onPressed: () {
                //     Navigator.of(context).pop(false);
                //   },
                // ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Replace'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );

        if (!replaceFile) {
          return;
        }
      }

      //   if (conflictResult == FileConflictResult.changeName) {
      //     fileName = await displayFileNameDialog(context);
      //     if (fileName == null || fileName.isEmpty) {
      //       _scaffoldMessengerKey.currentState?.showSnackBar(
      //         SnackBar(
      //           content: Text('No filename provided. Note was not saved.'),
      //           // Red color for failure
      //         ),
      //       );
      //       return;
      //     }
      //     filePath = "$directory/$fileName.txt";
      //     file.renameSync(filePath);
      //   } else if (conflictResult == FileConflictResult.replace) {
      //     // Do nothing here, the file will be replaced below
      //   } else {
      //     // User canceled the operation
      //     return;
      //   }
      // }

      String contents = strings.join("\n");

      await file.writeAsString(contents);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('List of texts saved successfully as: $fileName'),
        ),
      );

      setState(() {
        select.clear();
        tikmark = false;
      });
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save list of texts.'),
        ),
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Give Permission for allow management of all files.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // void _downloadListToFile(List<String> strings) async {
  //   try {
  //     PermissionStatus permissionStatus = await Permission.storage.status;
  //     if (!permissionStatus.isGranted) {
  //       PermissionStatus newPermissionStatus =
  //           await Permission.storage.request();
  //       if (!newPermissionStatus.isGranted) {
  //         return;
  //       }
  //     }

  //     String? directory = await FilePicker.platform.getDirectoryPath();
  //     String? fileName;
  //     String filePath;

  //     do {
  //       fileName = await displayFileNameDialog(context);
  //       if (fileName == null || fileName.isEmpty) {
  //         _scaffoldMessengerKey.currentState?.showSnackBar(
  //           const SnackBar(
  //             content: Text('No filename provided. Note was not saved.'),
  //             backgroundColor: Colors.red, // Red color for failure
  //           ),
  //         );
  //         return;
  //       }
  //       filePath = '$directory/$fileName.txt';
  //       final file = File(filePath);
  //       if (file.existsSync()) {
  //         // ignore: use_build_context_synchronously
  //         FileConflictResult conflictResult = await showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('File Already Exists'),
  //               content: const Text(
  //                 'A file with the same name already exists. Do you want to change the file name again?',
  //               ),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('Change Name'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(FileConflictResult.changeName);
  //                   },
  //                 ),
  //                 TextButton(
  //                   child: const Text('Replace'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(FileConflictResult.replace);
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );

  //         if (conflictResult == FileConflictResult.replace) {
  //           // Replace the existing file with the new one
  //           break;
  //         }
  //       } else {
  //         break;
  //       }
  //     } while (true);

  //     String contents = strings.join("\n");
  //     final file = File(filePath);
  //     await file.writeAsString(contents);

  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(
  //         content: Text('List of texts saved successfully as: $fileName'),
  //         backgroundColor: Colors.green, // Green color for success
  //       ),
  //     );
  //     setState(() {
  //       select.clear();
  //       tikmark = false;
  //     });
  //   } catch (e) {
  //     print(e);
  //     _scaffoldMessengerKey.currentState?.showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to save list of texts.'),
  //         backgroundColor: Colors.red, // Red color for failure
  //       ),
  //     );
  //   }
  // }

  // Method to handle the selection of individual and multiple texts
  void toggleSelection(int index) {
    setState(() {
      if (select.contains(widget.notes[index])) {
        select.remove(widget.notes[index]);
      } else {
        select.add(widget.notes[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: bgColor,
        actions: [
          PopupMenuButton(
            child: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(
                      Icons.select_all_sharp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Select all'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    select.clear();
                    select.addAll(widget.notes);
                    //   print('$select');
                    //tikmark = true;
                  });
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(
                      Icons.download_sharp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Download'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (select.isNotEmpty) {
                      _downloadListToFile(select);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select texts to download.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  });
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (select.isNotEmpty) {
                      // int length = select.length;
                      widget.notes.removeWhere((note) => select.contains(note));
                      // print('$select');
                      select.clear();
                      tikmark = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Successfully deleted selected texts.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select texts to delete.'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ],
        centerTitle: true,
        title: const Text('List Of Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter text here..',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 64, 255),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                  borderSide: const BorderSide(
                    color: bgColor,
                    width: 2,
                  ),
                ),
                suffixIcon: AvatarGlow(
                  endRadius: 25.0,
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
                                if (result.finalResult) {
                                  setState(() {
                                    textController.text =
                                        '${textController.text} ${result.recognizedWords}';
                                    textController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                        offset: textController.text.length,
                                      ),
                                    );
                                  });
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
                      radius: 15,
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 35,
                  color: bgColor,
                  child: TextButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      String textNote = textController.text.toString();
                      if (textNote.trim().isNotEmpty) {
                        setState(() {
                          textController.text = '';
                          widget.notes.add(textNote);
                        });
                      } else {
                        textController.text = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter the text on text field.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  height: 35,
                  color: bgColor,
                  child: TextButton(
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      String textNote = textController.text.toString();
                      if (textNote.trim().isNotEmpty) {
                        setState(() {
                          textController.text = '';
                          widget.notes[selectedIndex] = textNote;
                          selectedIndex = -1;
                          // alterIndex = -1;
                        });
                      } else {
                        textController.text = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter the text on text field.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            widget.notes.isEmpty
                ? const Text(
                    'No Texts Yet...',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: widget.notes.length,
                      itemBuilder: (context, index) {
                        final isSelected = select.contains(widget.notes[index]);
                        return Card(
                          shadowColor: bgColor,
                          elevation: 12,
                          child: ListTile(
                            leading: Text('${index + 1}.'),
                            title: Scrollbar(
                                thickness: 2,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(widget.notes[index])))),
                            trailing: SizedBox(
                              width: 72,
                              child: Row(
                                children: [
                                  // const SizedBox(
                                  //   width: 3,
                                  // ),
                                  // Checkbox for individual text selection
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (value) =>
                                        toggleSelection(index),
                                  ),
                                  // const SizedBox(
                                  //   width: 2,
                                  // ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Row(
                                          children: [
                                            Icon(Icons.edit),
                                            SizedBox(width: 10),
                                            Text('Edit'),
                                          ],
                                        ),
                                        onTap: () {
                                          // if (textController.text.isEmpty) {
                                          textController.text =
                                              widget.notes[index];
                                          setState(() {
                                            selectedIndex = index;
                                            //alterIndex = index;
                                          });
                                          // } //else {

                                          // showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext) {
                                          //       return AlertDialog(
                                          //         title: const Text('data'),
                                          //         content: const Text('data'),
                                          //         actions: [
                                          //           TextButton(
                                          //               onPressed: () {
                                          //                 textController
                                          //                         .text =
                                          //                     '${textController.text} ${widget.notes[index]}';
                                          //                 setState(() {
                                          //                   selectedIndex =
                                          //                       index;
                                          //                   widget.notes
                                          //                       .removeAt(
                                          //                           alterIndex);
                                          //                   Navigator.pop(
                                          //                       context);
                                          //                 });
                                          //               },
                                          //               child: const Text(
                                          //                   'Add')),
                                          //           TextButton(
                                          //               onPressed: () {
                                          //                 textController
                                          //                         .text =
                                          //                     widget.notes[
                                          //                         index];
                                          //                 setState(() {
                                          //                   selectedIndex =
                                          //                       index;
                                          //                   Navigator.pop(
                                          //                       context);
                                          //                 });
                                          //               },
                                          //               child: const Text(
                                          //                   'Replace'))
                                          //         ],
                                          //       );
                                          //     });
                                          // }
                                        },
                                      ),
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
                                            widget.notes.removeAt(index);
                                          });
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            InkWell(
                                              child: const Icon(
                                                Icons.download,
                                              ),
                                              onTap: () {
                                                writeToFile(
                                                    widget.notes[index]);
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            const Text('Download'),
                                          ],
                                        ),
                                      ),
                                    ],
                                    child: const Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                            ),
                          ),
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

// enum FileConflictResult {
//   changeName,
//   replace,
// }
