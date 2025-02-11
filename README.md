# Canvas Editor

CanvasEditor allows you to add various widgets over a customizable background (image or color) and provides functionalities to move, resize, rotate, and manipulate these widgets.

<p align="center">
    <img src="https://github.com/niilx/canvas_editor/blob/master/lib/Record_1.gif" alt="screenshot">
</p>

## Features

- Change editor background color.
- Add any widget as the background in the editor.
- Overlay any widget over the editor.
- Move, resize, flip, zoom, and rotate added widgets.
- Update added widgets with another widget.
- Support undo and redo actions.
- Allow single and multiple selections.
- Customize border color and remove icon.
- Remove added widgets.
- Handle all actions manually.

## Installation

Add `canvas_editor` to your `pubspec.yaml` file:

```yaml
dependencies:
  canvas_editor: ^1.0.0
```

Then, import the package:

```dart
import 'package:canvas_editor/canvas_editor.dart';
```

## Usage

```dart
import 'package:canvas_editor/canvas_editor.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CanvasEditorController _canvasEditorController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas Editor Example'),
      ),
      body: EditorView(
        onInitialize: (controller) {
          setState(() {
            _canvasEditorController = controller;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _canvasEditorController.addView(
            child: Text('New Widget'),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## Additional Configuration

- `borderColor`: Sets the border color of widgets (default: `Colors.black`).
- `removeIcon`: Sets the remove icon (default: `Icon(Icons.cancel)`).
- `addBackgroundColor`: Sets the background color.
- `addBackgroundView`: Adds a background widget over the editor.
- `addView`: Adds a new widget over the editor.
- `updateView`: Updates an existing widget in the editor.
- `canEditMultipleView`: Enables multi-selection (default: `true`).
- `hideViewControl`: Hides widget controls (borders/icons).
- `showViewControl`: Shows widget controls (borders/icons).
- `onClick`: Callback when a widget is clicked.
- `clickToFocusAndMove`: Enables movement and transformation on click (default: `false`).
- `moveView`: Moves a widget programmatically.
- `rotateView`: Rotates a widget programmatically.
- `zoomInOutView`: Zooms in or out a widget programmatically.
- `flipView`: Flips a widget horizontally or vertically.
- `updateMatrix`: Updates a widget's matrix.

## Example

For a full implementation, check the `/example/lib/main.dart` file in the package repository.

## License

This package is licensed under the MIT License. See the `LICENSE` file for details.
