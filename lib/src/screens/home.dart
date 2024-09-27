import 'dart:io';

import 'package:bank_check/src/excel.dart';
import 'package:bank_check/src/utils/backup.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/widgets/history_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key, required this.results});

  @override
  State<MyHome> createState() => _MyHomeState();
  final List<Result> results;
}

class _MyHomeState extends State<MyHome> {
  File file = File('');
  File file2 = File('');

  @override
  Widget build(BuildContext context) {
    print("rabanada:");
    print(MediaQuery.of(context).size.height);
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
                    //backgroundColor: secondaryColor,
                    iconColor: Colors.white,
                    maximumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        double.infinity),
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        MediaQuery.of(context).size.height * 0.128),
                    foregroundColor: Colors.white,
                    side: const BorderSide(width: 1.5, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    FilePickerResult? results =
                        await FilePicker.platform.pickFiles();

                    if (results != null) {
                      setState(() {
                        file = File(results.files.single.path!);
                        print(file.path);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nenhum arquivo selecionado'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Column(
                      children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          MediaQuery.of(context).size.width > 360
                              ? 'Inserir Extrato'
                              : 'Extrato',
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        if (file.path != '')
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.4,
                            child: Text(
                              basename(file.path).replaceAll('.xlsx', ''),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                      ],
                    )),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    maximumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        double.infinity),
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 20,
                        MediaQuery.of(context).size.height * 0.075),
                    foregroundColor: Colors.white,
                    side: const BorderSide(width: 1.5, color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () async {
                    FilePickerResult? results =
                        await FilePicker.platform.pickFiles();

                    if (results != null) {
                      setState(() {
                        file2 = File(results.files.single.path!);
                        print(file2.path);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nenhum arquivo selecionado',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          elevation: 1,
                        ),
                      );
                    }
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
                              ? 'Inserir Despesas ou Faturas'
                              : 'Despesas ou Faturas',
                          //style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        if (file2.path != '')
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.4,
                            child: Text(
                              basename(file2.path).replaceAll('.xlsx', ''),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 16.0 : 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.07),
                foregroundColor: Colors.white,
                side: const BorderSide(width: 1.5, color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () async {
                if (file.path == '' || file2.path == '') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Erro',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: const Text('Selecione os arquivos necessários'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Gerando relatório...',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      elevation: 1,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    widget.results.add(compareDebit(context, file, file2));
                    saveData(widget.results);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gerar relatório de Despesas'),
                    SizedBox(width: 4),
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.07),
                foregroundColor: Colors.white,
                side: const BorderSide(width: 1.5, color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () async {
                if (file.path == '' || file2.path == '') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Erro',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: const Text('Selecione os arquivos necessários'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Gerando relatório...',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      elevation: 1,
                    ),
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                  setState(() {
                    widget.results.add(compareCredit(context, file, file2));
                    saveData(widget.results);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gerar relatório de Receitas'),
                    SizedBox(width: 4),
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
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
