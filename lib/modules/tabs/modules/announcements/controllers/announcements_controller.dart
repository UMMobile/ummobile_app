import 'package:http/http.dart' as http;
import 'package:ummobile/modules/tabs/modules/announcements/models/announcementes_call.dart';

class RemoteService {
  Future<List<Datum>?> getPost() async {
    var client = http.Client();

    var uri =
        Uri.parse('https://portalempleado.um.edu.mx/API/comunicados/all/');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return comunicadosFromJson(json).data;
    }
  }
}
