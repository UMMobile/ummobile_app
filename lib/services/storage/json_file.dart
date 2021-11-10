import 'dart:convert';
import 'dart:io';

class JsonStorage {
  String path = '';
  File file = File('');
  bool isCreated = false;

  String _textContent = '{}';
  dynamic _dynamicContent = {};
  int _lastEdited = 0;
  int _lastRead = 0;

  dynamic get dynamicContent => this._dynamicContent;
  String get textContent => this._textContent;

  bool get exist => this.file.existsSync();
  bool get isList => this.dynamicContent is List;
  bool get isMap => this.dynamicContent is Map;

  set initialContent(dynamic intialContent) {
    this._dynamicContent = intialContent;
    this._textContent = jsonEncode(intialContent);
  }

  JsonStorage({dynamic initialContent: const {}, bool create: false})
      : this._textContent = jsonEncode(initialContent),
        this._dynamicContent = initialContent {
    if (create) {
      this.create(withPath: this.path, initialContent: this._dynamicContent);
    } else if (this.exist) {
      this._updateLocalContent(this.readContent(asText: true));
    }
  }

  JsonStorage create({
    required String withPath,
    dynamic initialContent,
  }) {
    this.file = File(withPath);
    if (!this.exist) {
      String textInitialContent =
          jsonEncode(initialContent ?? this._dynamicContent);
      this.file.writeAsStringSync(textInitialContent);
      this._updateLocalContent(textInitialContent);
    } else {
      this._updateLocalContent(this.readContent(asText: true));
    }
    this.isCreated = true;
    return this;
  }

  bool writeContent(String jsonText) {
    bool wrote = false;
    if (this.exist && this._textContent != jsonText) {
      this.file.writeAsStringSync(jsonText);
      this._updateLocalContent(jsonText);
      this._updateLastEdited();
      wrote = true;
    }
    return wrote;
  }

  dynamic readContent({bool asText: false}) {
    if (this.exist) {
      if (this._lastRead == 0 || this._lastRead < this._lastEdited) {
        this._updateLocalContent(this.file.readAsStringSync());
        this._updateLastRead();
      }
    }
    return asText ? this._textContent : this._dynamicContent;
  }

  dynamic delete() {
    this._updateLocalContent(this.readContent(asText: true));
    this.file.deleteSync();
    return this._dynamicContent;
  }

  T contentAs<T>(T Function(dynamic) mapper) => mapper(this._dynamicContent);

  bool contentEqualTo(String text) => text == this.readContent(asText: true);

  void _updateLocalContent(String content) {
    this._textContent = content;
    this._dynamicContent = jsonDecode(content);
  }

  void _updateLastRead() {
    if (this._lastRead < this._lastEdited) {
      this._lastRead = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void _updateLastEdited() {
    if (this._lastEdited < this._lastRead) {
      this._lastEdited = DateTime.now().millisecondsSinceEpoch;
    }
  }
}
