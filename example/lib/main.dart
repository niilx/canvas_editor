import 'package:example/result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canvas_editor/canvas_editor.dart';
import 'dart:io';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Editor Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Canvas Editor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CanvasImageEditorController _easyImageEditorController;
  final ImagePicker _picker = ImagePicker();
  //late EditorView editorView;

  final List<Color> _colorArray = [
    Colors.red,
    Colors.black,
    Colors.white,
    Colors.amber,
    Colors.black38,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.pink,
    Colors.blue,
    Colors.cyan,
    Colors.deepPurple,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () =>
                _easyImageEditorController.canEditMultipleView(false),
            icon: const Icon(Icons.photo_size_select_large),
          ),
          IconButton(
            onPressed: () =>
                _easyImageEditorController.canEditMultipleView(true),
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () => _easyImageEditorController.undo(),
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: () => _easyImageEditorController.redo(),
            icon: const Icon(Icons.redo),
          ),
          IconButton(
            onPressed: () {
              _easyImageEditorController.saveEditing().then((value) {
                if (value != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => Result(uint8list: value)));
                }
              });
            },
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: CanvasEditorView(
        borderColor: Colors.red,
        clickToFocusAndMove: false,
        onInitialize: (controller) {
          setState(() {
            _easyImageEditorController = controller;
          });
        },
        removeIcon: const CircleAvatar(
          radius: 12,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.clear,
            size: 20.0,
          ),
        ),
        onViewTouchOver: (position, widget, widgetType) {
          debugPrint("onViewTouch: $position, $widgetType");
        },
        onViewTouch: (position, widget, widgetType) {
          debugPrint("onViewTouch: $position, $widgetType");
        },
        onClick: (position, widget, widgetType) {
          debugPrint("onViewClick $position");
          if (widgetType == "text") {
            Text _text = widget as Text;
            _addText(position, _text);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: "Add Text",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "Add Image",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: "Add Color",
          ),
        ],
        onTap: (position) {
          switch (position) {
            case 0:
              _addText(null, null);
              break;
            case 1:
              _addImage();
              break;
            case 2:
              _addBg();
              break;
          }
        },
      ),
    );
  }

  void _addText(int? position, Text? text) {
    final textEditController = TextEditingController(text: text?.data);
    Color? textColor = text?.style?.color;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: textEditController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: "Enter Text",
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _colorArray.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          stateSetter(() {
                            textColor = _colorArray[index];
                          });
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          color: _colorArray[index],
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (textEditController.text.isNotEmpty) {
                      Navigator.pop(context);

                      if (text == null) {
                        _easyImageEditorController.addView(
                          Text(
                            textEditController.text,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: textColor,
                            ),
                          ),
                          widgetType: "text",
                        );
                      } else {
                        _easyImageEditorController.updateView(
                          position!,
                          Text(
                            textEditController.text,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: 100.0,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                      child: Text("Add"),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  _addBg() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 60,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _colorArray.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _easyImageEditorController
                        .addBackgroundColor(_colorArray[index]);
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    color: _colorArray[index],
                  ),
                );
              },
            ),
          );
        });
  }

  _addImage() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    Navigator.pop(context);
                    _easyImageEditorController
                        .addBackgroundView(Image.file(File(image.path)));
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Set Background",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final XFile? image =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    Navigator.pop(context);
                    _easyImageEditorController.addView(
                        Image.file(
                          File(image.path),
                          height: 200,
                          width: 200,
                        ),
                        widgetType: "image");
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Add View",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          );
        });
  }

}
