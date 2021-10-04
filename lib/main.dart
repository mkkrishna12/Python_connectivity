import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _outputOrError = "", _error = "";

  Map<String, dynamic> data = Map();
  bool loadImageVisibility = true;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<String> fetchData() async {
    Directory getCurrentDirectory = await Directory.current;
    print(getCurrentDirectory);
    return await rootBundle.loadString('Text/test.py');
  }

  void addIntendation() {
    TextEditingController _updatedController = TextEditingController();

    int currentPosition = _controller.selection.start;

    String controllerText = _controller.text;
    String text = controllerText.substring(0, currentPosition) +
        "    " +
        controllerText.substring(currentPosition, controllerText.length);

    _updatedController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _controller.text.length + 4,
        extentOffset: _controller.text.length + 4,
      ),
    );

    setState(() {
      _controller = _updatedController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      minimum: const EdgeInsets.only(top: 4),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  controller: _controller,
                  minLines: 10,
                  maxLines: 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    'This shows Output Or Error : $_outputOrError',
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: Colors.green,
                        onPressed: () => addIntendation(),
                        child: const Icon(
                          Icons.arrow_right_alt,
                          size: 50,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        height: 50,
                        color: Colors.green,
                        child: const Text(
                          'run Code',
                        ),
                        onPressed: () async {
                          // to run PythonCode, just use executeCode function, which will return map with following format
                          // {
                          // "textOutputOrError" : output of the code / error generated while running the code
                          // }5
                          String requiredstring = await fetchData();
                          final _result =
                              await Chaquopy.executeCode(requiredstring);
                          setState(() {
                            _outputOrError = _result['textOutputOrError'] ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
