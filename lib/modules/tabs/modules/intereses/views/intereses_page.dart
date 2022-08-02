import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ummobile/modules/tabs/controllers/navigation_controller.dart';

import 'package:ummobile/modules/app_bar/views/appBar.dart';
import 'package:ummobile/modules/tabs/modules/intereses/controllers/inreses_controller.dart';
import 'package:ummobile/modules/tabs/modules/intereses/models/interes.dart';

class NoticesPage extends StatefulWidget {
  NoticesPage({Key? key}) : super(key: key);

  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Datum>? interes;
  var isLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    interes = (await RemoteService().getPost());
    if (interes != null) {
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
        title: 'De interes'.tr.capitalizeFirst!,
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
          itemCount: interes?.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Text(
                    interes![index].titulo,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Image.network(interes![index].fullUrl),
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
