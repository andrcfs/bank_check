import 'dart:io';

import 'package:bank_check/src/excel.dart';
import 'package:bank_check/src/utils/backup.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart'; // Added import for secondaryColor
import 'package:bank_check/src/widgets/history_list.dart';
import 'package:bank_check/src/widgets/home_buttons.dart'; // Import the new widgets
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
    final bool isSmallScreenHeight = MediaQuery.of(context).size.height <= 570;
    final double verticalPadding = isSmallScreenHeight ? 8.0 : 16.0;
    final double generalSpacing = isSmallScreenHeight ? 8.0 : 16.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(verticalPadding),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: generalSpacing, horizontal: generalSpacing),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gerar Relatório",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: generalSpacing),
                  Row(
                    children: [
                      FilePickerButton(
                        icon: Icons.monetization_on_outlined,
                        label: MediaQuery.of(context).size.width > 360
                            ? 'Inserir Extrato'
                            : 'Extrato',
                        filePath: file.path,
                        onPressed: () async {
                          FilePickerResult? results =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );
                          if (results != null) {
                            setState(() {
                              file = File(results.files.single.path!);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nenhum arquivo selecionado'),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      FilePickerButton(
                        icon: Icons.list_alt,
                        label: MediaQuery.of(context).size.width > 360
                            ? 'Despesas ou Faturas'
                            : 'Balanço',
                        filePath: file2.path,
                        onPressed: () async {
                          FilePickerResult? results =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );
                          if (results != null) {
                            setState(() {
                              file2 = File(results.files.single.path!);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nenhum arquivo selecionado'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: generalSpacing),
                  GenerateReportButton(
                    label: 'Gerar relatório de Despesas',
                    iconData: Icons.arrow_downward,
                    onPressed: () async {
                      if (file.path == '' || file2.path == '') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Erro',
                                style: TextStyle(color: Colors.red)),
                            content: const Text(
                                'Selecione os arquivos necessários.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gerando relatório...',
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          widget.results
                              .add(compareDebit(context, file, file2));
                          saveData(widget.results);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  GenerateReportButton(
                    label: 'Gerar relatório de Receitas',
                    iconData: Icons.arrow_upward,
                    onPressed: () async {
                      if (file.path == '' || file2.path == '') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Erro',
                                style: TextStyle(color: Colors.red)),
                            content: const Text(
                                'Selecione os arquivos necessários.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gerando relatório...',
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await Future.delayed(const Duration(milliseconds: 500));
                        setState(() {
                          widget.results
                              .add(compareCredit(context, file, file2));
                          saveData(widget.results);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreenHeight ? 8.0 : 24.0),
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
