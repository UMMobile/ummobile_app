import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ummobile/modules/app_bar/modules/rules/models/rules.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/statics/widgets/overlays/dialog_overlay.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class RulePage extends StatefulWidget {
  final Rule rule;

  RulePage({required this.rule});

  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  late TextEditingController _searchController;

  bool isSearching = false;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _searchField = TextField(
      autofocus: true,
      cursorColor: Colors.white,
      controller: _searchController,
      style: TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      onSubmitted: (input) async {
        _searchResult = _pdfViewerController.searchText(input,
            searchOption: TextSearchOption.caseSensitive);
        setState(() {});
      },
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),

          /// Se usa para configurar el color del cuadro de entrada cuando se enfoca
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          )),
    );

    Widget _appBar = (isSearching)
        ? _searchField
        : Text(
            widget.rule.name,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          );

    return Scaffold(
      appBar: UmAppBar(
        child: _appBar,
        customActions: <Widget>[
          (isSearching)
              ? IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      _searchController.clear();
                      _searchResult.clear();
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
        showActionIcons: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SfPdfViewer.network(
            this.widget.rule.pdfUrl.toString(),
            controller: _pdfViewerController,
            initialZoomLevel: 1.5,
            initialScrollOffset: Offset(75, 50),
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) =>
                openDialogWindow(
              title: "something_wrong".tr,
              message: "try_again".tr,
              onCancel: () => Get.back(),
              onConfirm: () {
                Get.back();
                Get.back();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 9)],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () => setState(() {
                      _searchResult.previousInstance();
                    }),
                    child: Icon(Icons.keyboard_arrow_up),
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    minWidth: 30,
                  ),
                  Text(
                      "${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}"),
                  MaterialButton(
                    onPressed: () => setState(() {
                      _searchResult.nextInstance();
                    }),
                    child: Icon(Icons.keyboard_arrow_down),
                    shape: CircleBorder(),
                    padding: EdgeInsets.zero,
                    minWidth: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
