import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:list_view/user_state.dart';
import 'dart:convert';

import 'user_model.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserLoading()) {
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> userList = data['data'];
        final users = userList.map((json) => User.fromJson(json)).toList();
        emit(UserLoaded(users));
      } else {
        emit(UserError());
      }
    } catch (e) {
      emit(UserError());
    }
  }
}
