import 'dart:convert';
import 'package:customer_ui/model/user_model.dart';
import 'package:http/http.dart' as http;
// Controller class to fetch users
class UserController {

  Future<List<UserModel>> fetchUsers() async {
    final url = Uri.parse('https://post-product-beac8-default-rtdb.asia-southeast1.firebasedatabase.app/customers.json'); // Replace with your Firebase URL

    final res = await http.get(url);

    if (res.statusCode == 200 && res.body != 'null') {
      final Map<String, dynamic> data = json.decode(res.body);
      final List<UserModel> loaded = [];

      data.forEach((key, value) {
        loaded.add(UserModel.fromJson({"id": key, ...value}));
      });

      return loaded;
    } else {
      return [];
    }
  }
}

