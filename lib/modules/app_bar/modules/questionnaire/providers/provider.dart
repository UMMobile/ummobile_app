import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../login/controllers/login_controller.dart';

class QuestionnairProvider {
  // ignore: non_constant_identifier_names
  Future PostQuestionnair(int pasos, double distancia) async {
    print("pasos: $pasos, distancia $distancia");

    var token = "Bearer " + await Get.find<LoginController>().token;

    await Clipboard.setData(ClipboardData(text: token));

    var response = await Dio()
        .post('https://wso2am.um.edu.mx/um-health/1.0.0/health/add-report',
            options: Options(
              headers: {
                "Authorization": token,
              },
            ),
            data: {
          "pasos": pasos,
          "distancia": distancia,
        });

    print(response.data);

    return response;
  }
}
