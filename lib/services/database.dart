import 'package:hive/hive.dart';

import '../models/calculation.dart';


class Database {

  Future<String?> signIn(String email, String password) async {
    var users = await Hive.openBox('users');
      if(users.containsKey(email)){
        if(password == users.get(email)){
          await Hive.box('loginData').put('isLogged', email);
          return null;
        }else{
          return 'Password incorrect';
        }
      }else{
        return 'Email does not exist';
      }
  }

  Future<String?> register(String email, String password) async {
    var users = await Hive.openBox('users');
      if(users.containsKey(email)){
        return 'Email already exist';
      }
    users.put(email, password);
    await Hive.box('loginData').put('isLogged', email);
    return null;
  }

  Future<bool> putData(Calculation calculation) async {
    bool isDone = false;
    var calculations = await Hive.openBox<Calculation>('calculations');
    calculations.add(calculation).then((value) => isDone = true);
    return isDone;
  }

  Future<List<Calculation>> getData(String email) async {
    var calculations = await Hive.openBox<Calculation>('calculations');
    List<Calculation> listOfCalculation =
    calculations.values.where((element) => element.email == email).toList();
    return listOfCalculation;
  }

  Future<void> logOut() async {
    await Hive.box('loginData').put('isLogged', null);
  }
}