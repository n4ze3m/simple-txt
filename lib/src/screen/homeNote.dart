import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad/src/widget/myButton.dart';
import 'dart:convert';
import 'dart:html' as html;

class HomeNote extends StatefulWidget {
  HomeNote({Key key}) : super(key: key);

  @override
  _HomeNoteState createState() => _HomeNoteState();
}

class _HomeNoteState extends State<HomeNote> {
  TextEditingController _notepadController = TextEditingController();
  TextEditingController _filenameController = TextEditingController();
  String _fileName = 'simple.txt';
  String _endPoint = '.txt';
  ScrollController _scrollController = ScrollController();
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _filenameController.dispose();
    _notepadController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          'Simple.txt',
          style: GoogleFonts.nothingYouCouldDo(fontSize: 35),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              child: Center(
                  child: Icon(
                Icons.clear_all,
                color: Colors.white,
              )),
              size: 25,
              color: Colors.blue,
              onPressed: () {
                _filenameController.clear();
                _notepadController.clear();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              child: Center(
                  child: Icon(
                Icons.save_alt,
                color: Colors.white,
              )),
              size: 25,
              color: Colors.blue,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Download as'),
                        content: Container(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'simple.txt',
                                border: OutlineInputBorder()),
                            controller: _filenameController,
                          ),
                        ),
                        actions: <Widget>[
                          new MyButton(
                            color: Colors.red,
                            size: 25,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Center(
                              child: Icon(Icons.close),
                            ),
                          ),
                          new MyButton(
                            color: Colors.green,
                            size: 25,
                            onPressed: () => dowloadtxt(context),
                            child: Center(
                              child: Icon(Icons.cloud_download),
                            ),
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: SingleChildScrollView(
            physics: PageScrollPhysics(),
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EditableText(
                  showCursor: true,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  focusNode: _focusNode,
                  cursorColor: Colors.black87,
                  enableInteractiveSelection: true,
                  showSelectionHandles: true,
                  autocorrect: true,
                  selectionColor: Colors.blue.withOpacity(0.3),
                  //decoration: InputDecoration(border: InputBorder.none),
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _notepadController,
                  backgroundCursorColor: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dowloadtxt(BuildContext context) {
    if (_filenameController.text.isNotEmpty) {
      if (_filenameController.text.contains('.')) {
        // prepare
        final bytes = utf8.encode(_notepadController.text);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = _filenameController.text;
        html.document.body.children.add(anchor);
        // download
        anchor.click();
        _filenameController.clear();

        // cleanup
        html.document.body.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        Navigator.of(context).pop();
      } else {
        // prepare
        final bytes = utf8.encode(_notepadController.text);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = '${_filenameController.text}$_endPoint';
        html.document.body.children.add(anchor);
        // download
        anchor.click();
        _filenameController.clear();

        // cleanup
        html.document.body.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
        Navigator.of(context).pop();
      }
    } else {
      // prepare
      final bytes = utf8.encode(_notepadController.text);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = _fileName;
      html.document.body.children.add(anchor);
      // download
      anchor.click();
      // cleanup
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      Navigator.of(context).pop();
    }
  }
}
