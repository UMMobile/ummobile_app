import 'package:ummobile/modules/app_bar/modules/questionnaire/models/departments.dart';
import 'package:http/http.dart' as http;

class UMMobileQuality {
  Future<List<Areas>?> getArea() async {
    var client = http.Client();

    var uri = Uri.parse('https://am.um.edu.mx/buzon/api/cuestionario/areas');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return areasFromJson(json);
    }
    return null;
  }
}
