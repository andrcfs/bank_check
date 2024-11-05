import 'dart:io';

import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:bank_check/src/utils/methods.dart';
import 'package:bank_check/src/widgets/history_list.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    super.key,
    required this.results,
    required this.savedFiles,
  });

  @override
  State<MyHome> createState() => _MyHomeState();
  final List<Result> results;
  final List<SavedFile> savedFiles;
}

class _MyHomeState extends State<MyHome> {
  File file = File('');
  File file2 = File('');
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    print(widget.savedFiles);
    print(widget.savedFiles[0].name);
    print(widget.savedFiles[1].name);
    print(widget.savedFiles.length);
    print("Height:");
    print(MediaQuery.of(context).size.height);
    print('Width:');
    print(MediaQuery.of(context).size.width);
    return Center(
      child: Padding(
        padding:
            EdgeInsets.all(MediaQuery.of(context).size.height > 570 ? 16.0 : 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        width: 1.5, color: primaryColor.withOpacity(0.15)),
                    backgroundColor: secondaryColor,
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shadowColor: Colors.grey[500],
                    iconColor: Colors.blueAccent,
                    maximumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        double.infinity),
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        MediaQuery.of(context).size.height * 0.128),
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    await selectAndSaveFiles(context);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Column(
                      children: [
                        const Icon(
                          Icons.upload_file_rounded,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          MediaQuery.of(context).size.width > 360
                              ? 'Adicionar arquivos'
                              : 'Arquivos',
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                      ],
                    )),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        width: 1.5,
                        color: Colors.orangeAccent.withOpacity(0.15)),
                    padding: EdgeInsets.zero,
                    backgroundColor: secondaryColor,
                    elevation: 0,
                    shadowColor: Colors.grey[500],
                    iconColor: Colors.orangeAccent,
                    maximumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        double.infinity),
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        MediaQuery.of(context).size.height * 0.075),
                    foregroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Text("teste"),
                          );
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Column(
                      children: [
                        const Icon(
                          Icons.list_alt,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          MediaQuery.of(context).size.width > 360
                              ? 'Criar relatórios'
                              : 'Relatórios',
                          //style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 24.0 : 8),
            if (widget.results.isNotEmpty)
              Expanded(
                child: HistoryList(
                  results: widget.results,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
