import 'package:bank_check/src/screens/report/debit/report_debit.dart';
import 'package:bank_check/src/utils/backup.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:bank_check/src/widgets/history_list.dart';
import 'package:flutter/material.dart';

class HistoryListView extends StatefulWidget {
  final List<Result> results;

  const HistoryListView({
    super.key,
    required this.results,
  });

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.49,
        child: ListView.builder(
          restorationId: 'history',
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
                        dateTimeFormat.format(widget.results[index].time),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: widget.results[index] is ResultDebit
                            ? (context) => ReportDebit(
                                result: widget.results[index] as ResultDebit)
                            : (context) => ReportDebit(
                                result: widget.results[index] as ResultDebit),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SizedBox(
                      //width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 4),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    widget.results[index].name,
                                    style: const TextStyle(fontSize: 11),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.36,
                                  child: Text(
                                    widget.results[index].name2,
                                    style: const TextStyle(fontSize: 11),
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
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content:
                                      const Text('Deseja excluir este item?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() =>
                                            widget.results.removeAt(index));
                                        saveData(widget.results);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.red),
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
    );
  }
}

class HistoryList2 extends StatefulWidget {
  final List<Result> results;
  const HistoryList2({
    super.key,
    required this.results,
  });

  @override
  State<HistoryList2> createState() => _HistoryList2State();
}

class _HistoryList2State extends State<HistoryList2> {
  final Set<int> _selectedRows = {};
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Relatórios",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isDeleting
                    ? Row(
                        key: ValueKey<bool>(isDeleting),
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedRows.clear();
                                isDeleting = false;
                              });
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Deletar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(_selectedRows.length > 1
                                      ? 'Deseja excluir os ${_selectedRows.length} itens selecionados?'
                                      : 'Deseja excluir o item selecionado?'),
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
                                            .removeWhere((item) => _selectedRows
                                                .contains(widget.results
                                                    .indexOf(item))));
                                        saveData(widget.results);
                                        _selectedRows.clear();
                                        isDeleting = false;
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text(
                              'Deletar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isDeleting = true;
                          });
                        },
                        icon: const Icon(
                          Icons.delete_forever_sharp,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              checkboxHorizontalMargin: 2,
              showBottomBorder: false,
              showCheckboxColumn: isDeleting,
              columnSpacing: 8.0,
              columns: const [
                DataColumn(
                  label: Text("Date"),
                ),
                DataColumn(
                  label: Text("File Name"),
                ),
                DataColumn(
                  label: Text("File Name2"),
                ),
              ],
              rows: List.generate(widget.results.length, (index) {
                bool isSelected = _selectedRows.contains(index);
                return resultDataRow(isSelected, index);
              }),
            ),
          ),
        ],
      ),
    );
  }

  DataRow resultDataRow(bool isSelected, int index) {
    return DataRow(
      selected: isSelected,
      onLongPress: () {
        Result result = widget.results[index];
        pushToReport(context, result);
      },
      onSelectChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedRows.add(index);
          } else {
            _selectedRows.remove(index);
          }
        });
      },
      cells: [
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                    height: 18,
                    width: 16,
                    decoration: BoxDecoration(
                        color: widget.results[index] is ResultDebit
                            ? Colors.redAccent
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 16,
                    )),
                Flexible(
                  child: Text(
                    dateTimeFormat.format(widget.results[index].time),
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Text(widget.results[index].name
              .replaceAll('.xlsx', '')
              .replaceAll(' ', '')),
        ),
        DataCell(
          Text(widget.results[index].name2
              .replaceAll('.xlsx', '')
              .replaceAll(' ', '')),
        ),
      ],
    );
  }
}
