import 'package:http/http.dart' as http;
import 'package:ummobile/modules/tabs/modules/intereses/models/interes.dart';

class RemoteService {
  Future<List<Datum>?> getPost() async {
    var client = http.Client();

    var uri = Uri.parse('https://portalempleado.um.edu.mx/API/interes/leer/');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return interesFromJson(json).data;
    }
    return null;
  }
}
