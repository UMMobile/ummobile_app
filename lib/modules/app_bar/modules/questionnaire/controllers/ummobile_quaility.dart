import 'package:ummobile/modules/app_bar/modules/questionnaire/models/departments.dart';
import 'package:http/http.dart' as http;

class UMMobileQuality {
  Future<List<Departments>?> getPosts() async {
    var client = http.Client();

    var uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return departmentsFromJson(json);
    }
  }
}
