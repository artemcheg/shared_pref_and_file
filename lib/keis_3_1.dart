import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stless extends StatelessWidget {
  const Stless({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShprefFile(storage: CounterStorage());
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeFile(int count) async {
    final file = await _localFile;
    return file.writeAsString('$count');
  }

  Future<int> readFile() async {
    try {
      final file = await _localFile;

      final text = await file.readAsString();

      return int.parse(text);
    } catch (e) {
      return 0;
    }
  }
}

class ShprefFile extends StatefulWidget {
  const ShprefFile({Key? key, required this.storage}) : super(key: key);
  final CounterStorage storage;

  @override
  _ShprefFileState createState() => _ShprefFileState();
}

class _ShprefFileState extends State<ShprefFile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _firstCount = 0;
  int _secondCount = 0;
  String mail = "";
  final _incomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCount();
    _getMailForm();
    widget.storage.readFile().then((value) {
      setState(() {
        _secondCount = value;
      });
    });
  }

  Future<File> addFileCount() async {
    setState(() {
      _secondCount++;
    });
    return widget.storage.writeFile(_secondCount);
  }

  void _getMailForm() async {
    final pref = await SharedPreferences.getInstance();
   mail = pref.getString("mail") ?? "Привет!";
  }

  void _addMailForm(String value) async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      mail=value;
    });
    pref.setString("mail", mail);
  }

  void _getCount() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _firstCount = pref.getInt("firstCount") ?? 0;
    });
  }

  void _addCount() async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      _firstCount = (pref.getInt("firstCount") ?? 0) + 1;
    });
    pref.setInt("firstCount", _firstCount);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Кейс задание 3.1"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(margin: const EdgeInsets.only(left: 20,bottom: 10),child: const Text("ShPref")),
                        Container(
                            margin: const EdgeInsets.only(left: 25, bottom: 25),
                            child: Text(
                              "$_firstCount",
                              style: const TextStyle(fontSize: 25),
                            )),
                        IconButton(
                            iconSize: 50,
                            onPressed: () {
                              _addCount();
                            },
                            icon: const Icon(Icons.add_circle_outline_sharp))
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(margin: const EdgeInsets.only(left: 20,bottom: 10),child: const Text("Файл")),
                        Container(
                            margin: const EdgeInsets.only(left: 25, bottom: 25),
                            child: Text(
                              "$_secondCount",
                              style: const TextStyle(fontSize: 25),
                            )),
                        IconButton(
                            iconSize: 50,
                            onPressed: () {
                              addFileCount();
                            },
                            icon: const Icon(Icons.add_circle)),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: TextField(
                    controller: _incomeController,
                    decoration: const InputDecoration(
                      hintText: 'Введите логин',
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _addMailForm(_incomeController.text);
                   },
                  child: const Text("Отправить")),
              Container(
                margin: const EdgeInsets.all(25),
                  child: Text("Привет $mail!",
                style: const TextStyle(fontSize: 30),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
