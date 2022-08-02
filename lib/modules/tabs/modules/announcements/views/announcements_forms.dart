import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';
import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/modules/announcements/controllers/announcements_controller.dart';
import 'package:ummobile/modules/tabs/modules/announcements/models/announcementes_call.dart';

class AnnouncementsPage extends StatefulWidget {
  AnnouncementsPage({Key? key}) : super(key: key);

  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Datum>? comunicados;
  var isLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    comunicados = (await RemoteService().getPost());
    if (comunicados != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: UmAppBar(
        title: 'comunicados'.tr.capitalizeFirst!,
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get.find<NavigationController>()
                  .drawerKey
                  .currentState!
                  .openDrawer();
            }),
      ),
      body: Visibility(
        visible: isLoaded,
        child: ListView.builder(
          itemCount: comunicados?.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Image.network(comunicados![index].fullUrl),
                  ),
                  ListTile(
                    //leading: Image.network(comunicados![index].fullUrl),
                    title: Text(
                      comunicados![index].titulo,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: SingleChildScrollView(
                        child: Html(
                      data: (comunicados?[index].contenido),
                    )),
                  ),
                ],
              ),
            );
          },
        ),
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
