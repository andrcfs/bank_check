import 'dart:io';

import 'package:bank_check/src/excel.dart';
import 'package:bank_check/src/screens/report.dart';
import 'package:bank_check/src/utils/backup.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
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
                    widget.results.add(compare(context, file, file2));
                    saveData(widget.results);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gerar relatório de despesas'),
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
                    widget.results.add(compare(context, file, file2));
                    saveData(widget.results);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gerar relatório de faturas'),
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
              const Text(
                'Relatórios gerados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            SizedBox(
                height: MediaQuery.of(context).size.height > 570 ? 16.0 : 4),
            //if (widget.results.isNotEmpty) Report(widget.results: widget.results[0]),
            if (widget.results.isNotEmpty)
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.49,
                  child: ListView.builder(
                    restorationId: 'missingPayments',
                    shrinkWrap: true,
                    itemCount: widget.results.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  dateTimeFormat
                                      .format(widget.results[index].time),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Report(result: widget.results[index]),
                                ),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 1.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: SizedBox(
                                //width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 4),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text(
                                              widget.results[index].name,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          const Icon(
                                            Icons.close,
                                            size: 24,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 2),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.36,
                                            child: Text(
                                              widget.results[index].name2,
                                              style:
                                                  const TextStyle(fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Deletar',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            content: const Text(
                                                'Deseja excluir este item?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() => widget.results
                                                      .removeAt(index));
                                                  saveData(widget.results);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever_sharp,
                                        size: 28,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
