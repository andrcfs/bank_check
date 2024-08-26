import 'dart:io';

import 'package:bank_check/src/excel.dart';
import 'package:bank_check/src/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File file = File('');
  File file2 = File('');
  Map<String, Map<String, List>> result = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conciliação Bancária'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.white,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width / 2 - 20, 48),
                      foregroundColor: Colors.white,
                      side: const BorderSide(width: 1.5, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

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
                          if (file.path != '')
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.4,
                              child: Text(
                                basename(file.path),
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
                      minimumSize:
                          Size(MediaQuery.of(context).size.width / 2 - 20, 48),
                      foregroundColor: Colors.white,
                      side: const BorderSide(width: 1.5, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

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
                          if (file2.path != '')
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.4,
                              child: Text(
                                basename(file2.path),
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
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width * 0.6, 48),
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
                    result = compare(context, file, file2);
                  });
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
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (result.isNotEmpty && !isError)
                    Container(
                      height: MediaQuery.of(context).size.height - 310,
                      width: MediaQuery.of(context).size.width - 16,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result['priceDiff']!.values.first.isNotEmpty
                                    ? 'As seguintes ${result['priceDiff']!.values.first.length} contas não foram encontradas no extrato:'
                                    : 'Todas as contas foram encontradas no extrato',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    result['priceDiff']!.values.first.isNotEmpty
                                        ? [
                                            const Text('Data'),
                                            const Text('Fornecedor'),
                                            const Text('Valor(R\$)'),
                                          ]
                                        : [],
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 490,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      result['priceDiff']!.values.first.length,
                                  itemBuilder: (context, index) {
                                    DateTime date =
                                        result['priceDiff']!['Data']![index];
                                    String formattedDate =
                                        dateFormat.format(date);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Row(
                                        children: [
                                          Text(formattedDate),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              '${result['priceDiff']!['Fornecedor']![index]}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7.0,
                                          ),
                                          Text(
                                              '${result['priceDiff']!['Valor']![index]}'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                result['dateDiff']!.values.first.isNotEmpty
                                    ? 'As seguintes ${result['dateDiff']!.values.first.length} contas possuem discrepância maior que 3 dias no seu pagamento:'
                                    : 'Nenhuma discrepância de data encontrada.',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    result['dateDiff']!.values.first.isNotEmpty
                                        ? [
                                            const Text('Data'),
                                            const Text('Fornecedor'),
                                            const Text('Valor(R\$)'),
                                          ]
                                        : [],
                              ),
                              const SizedBox(
                                height: 4.0,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 490,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      result['dateDiff']!.values.first.length,
                                  itemBuilder: (context, index) {
                                    DateTime date =
                                        result['dateDiff']!['Data']![index];
                                    String formattedDate =
                                        dateFormat.format(date);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: Row(
                                        children: [
                                          Text(formattedDate),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Text(
                                              '${result['dateDiff']!['Fornecedor']![index]}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 7.0,
                                          ),
                                          Text(
                                              '${result['dateDiff']!['Valor']![index]}'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
