import 'package:bank_check/src/screens/report/credit/report_credit.dart';
import 'package:bank_check/src/screens/report/debit/report_debit.dart';
import 'package:bank_check/src/utils/classes.dart';
import 'package:bank_check/src/utils/constants.dart';
import 'package:bank_check/src/utils/methods.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  final List<Result> results;
  const HistoryList({
    super.key,
    required this.results,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  Set<int> _selectedRows = {};
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    bool? isAllSelected;
    if (_selectedRows.length == widget.results.length &&
        widget.results.isNotEmpty) {
      isAllSelected = true;
    } else if (_selectedRows.isEmpty) {
      isAllSelected = false;
    } else {
      isAllSelected = null;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        // Add this line to minimize the Column's height
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Delete/Cancel buttons
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
                                        setState(() {
                                          widget.results.removeWhere((item) =>
                                              _selectedRows.contains(widget
                                                  .results
                                                  .indexOf(item)));
                                          saveData(widget.results);
                                          _selectedRows.clear();
                                          isDeleting = false;
                                        });
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
                        key: ValueKey<bool>(isDeleting),
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
          // Column Headers
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                if (!isDeleting)
                  const SizedBox(
                    width: 30,
                  ),
                const SizedBox(width: 8),
                if (isDeleting)
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Checkbox(
                      tristate: true,
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        print(value);
                        setState(() {
                          if (value == true) {
                            // Select all
                            _selectedRows = Set<int>.from(List<int>.generate(
                                widget.results.length, (i) => i));
                          } else {
                            // Deselect all
                            _selectedRows.clear();
                          }
                        });
                      },
                    ),
                  ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    "Data",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    "Extrato",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    "Balanço",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Use Flexible instead of Expanded here
          Flexible(
            child: ListView.builder(
              shrinkWrap: true, // Add this line
              itemCount: widget.results.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedRows.contains(index);
                return buildListItem(isSelected, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItem(bool isSelected, int index) {
    Result result = widget.results[index];

    return Column(
      children: [
        const Divider(),
        Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            onLongPress: () {
              if (!isDeleting) {
                isDeleting = true;
                setState(() {
                  if (isSelected) {
                    _selectedRows.remove(index);
                  } else {
                    _selectedRows.add(index);
                  }
                });
              } else {
                pushToReport(context, result);
              }
            },
            onTap: () {
              if (!isDeleting) {
                pushToReport(context, result);
              } else {
                isDeleting = true;
                setState(() {
                  if (isSelected) {
                    _selectedRows.remove(index);
                  } else {
                    _selectedRows.add(index);
                  }
                });
              }
            },
            child: Container(
              decoration: isSelected
                  ? const BoxDecoration(
                      color: Color.fromRGBO(
                          54, 59, 81, 1), // Adjusted for dark mode
                    )
                  : null,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                children: [
                  if (isDeleting)
                    Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRows.add(index);
                          } else {
                            _selectedRows.remove(index);
                          }
                        });
                      },
                    ),
                  // Date Column
                  Container(
                    height: 22,
                    width: 20,
                    decoration: BoxDecoration(
                      color: result is ResultDebit
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      dateTimeFormat.format(result.time),
                    ),
                  ),
                  // File Name Column
                  Expanded(
                    flex: 3,
                    child: Text(
                      result.name.replaceAll('.xlsx', '').replaceAll(' ', ''),
                    ),
                  ),
                  // File Name2 Column
                  Expanded(
                    flex: 3,
                    child: Text(
                      result.name2.replaceAll('.xlsx', '').replaceAll(' ', ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void pushToReport(BuildContext context, Result result) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) {
      switch (result) {
        case ResultDebit():
          // Handle PaymentResult
          return ReportDebit(result: result);
        case ResultCredit():
          // Handle SupplierResult
          return ReportCredit(result: result);
        default:
          throw Exception('Unknown result type');
      }
    }),
  );
}
