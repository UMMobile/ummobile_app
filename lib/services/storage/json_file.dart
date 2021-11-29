import 'dart:convert';
import 'dart:io';

///Template class used for storing json files inside the user's phone
class JsonStorage {
  /// The file path in the user's device
  String path = '';

  /// The file object for read and write in user's device
  File file = File('');

  /// True if file exists in the user's device
  bool isCreated = false;

  /// The content in file as String value
  String _textContent = '{}';

  /// The content in file as a map value
  dynamic _dynamicContent = {};

  /// The last time this file was edited in milliseconds
  int _lastEdited = 0;

  /// The last time this file was read in milliseconds
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

  /// Returns an instance of the storage class allocated in [withPath]
  ///
  /// Updates the class content with the stored content on the
  /// device if file exists
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

  /// Returns true if succesfully stored [jsonText] into the file
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

  ///Returns the content stored in the file
  ///
  ///Returns a String value if [asText] is true, else returns a map value
  dynamic readContent({bool asText: false}) {
    if (this.exist) {
      if (this._lastRead == 0 || this._lastRead < this._lastEdited) {
        this._updateLocalContent(this.file.readAsStringSync());
        this._updateLastRead();
      }
    }
    return asText ? this._textContent : this._dynamicContent;
  }

  /// Deletes the file from the user's device storage
  ///
  /// Returns the last copy of the content as a map
  dynamic delete() {
    this._updateLocalContent(this.readContent(asText: true));
    this.file.deleteSync();
    return this._dynamicContent;
  }

  /// Parses the map value [dynamicContent] into a class
  T contentAs<T>(T Function(dynamic) mapper) => mapper(this._dynamicContent);

  /// Returns true if [text] is equals to the file content
  bool contentEqualTo(String text) => text == this.readContent(asText: true);

  /// Updates the class content registries
  void _updateLocalContent(String content) {
    this._textContent = content;
    this._dynamicContent = jsonDecode(content);
  }

  /// Updates the class [_lastRead] registry
  void _updateLastRead() {
    if (this._lastRead < this._lastEdited) {
      this._lastRead = DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Updates the class [_lastEdited] registry
  void _updateLastEdited() {
    if (this._lastEdited < this._lastRead) {
      this._lastEdited = DateTime.now().millisecondsSinceEpoch;
    }
  }
}
