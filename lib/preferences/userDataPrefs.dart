// ignore_for_file:prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors,file_names
import 'package:get_storage/get_storage.dart';


//USER DATA - STORES USER EMAIL IN PREFERENCES AND LOADS IT WHEN TRIGGERED
class UserData {
  GetStorage g = GetStorage();

  setUserEmail({required String? email}) => g.write('email', email);

  getUserEmail() => g.read('email') ?? '';
}
