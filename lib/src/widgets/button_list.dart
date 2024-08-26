import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

List<Widget> buttonList(context, file, file2, setState) {
  return [
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconColor: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width / 2 - 20, 48),
              foregroundColor: Colors.white,
              side: const BorderSide(width: 1.5, color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                setState(() {
                  file = File(result.files.single.path!);
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
                  const Text('Inserir Extrato'),
                  SizedBox(
                    height: file.path != '' ? 4.0 : 0.0,
                  ),
                  if (file.path != '') Text(basename(file.path)),
                ],
              )),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              iconColor: Colors.white,
              minimumSize: Size(MediaQuery.of(context).size.width / 2 - 20, 48),
              foregroundColor: Colors.white,
              side: const BorderSide(width: 1.5, color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                setState(() {
                  file2 = File(result.files.single.path!);
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
                  const Text('Contas a Pagar'),
                  SizedBox(
                    height: file2.path != '' ? 4.0 : 0.0,
                  ),
                  if (file2.path != '') Text(basename(file2.path)),
                ],
              )),
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 24),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 48),
        foregroundColor: Colors.white,
        side: const BorderSide(width: 1.5, color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () {
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
        }
        //Navigator.pushNamed(context, '/sampleItemListView');
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gerar relatório'),
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
  ];
}
