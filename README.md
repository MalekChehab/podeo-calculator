# Podeo Calculator

A simple calculator for podeo using Flutter.
A mobile application with Dart as the programming language, Flutter as the framework, Riverpod as state management and Hive as local database.

## Features
- [x] Calculator
- [x] Register and login
- [x] Local Database
- [x] Keep user logged in after app restart
- [x] Save user data in history

## Preview

https://user-images.githubusercontent.com/34037921/160305130-8e9595d5-6878-4b5a-8fea-cdbb77fbd78a.mp4

<img src="https://user-images.githubusercontent.com/34037921/160303778-b5deca57-153e-4626-a6b2-1f15882b266d.png" width="300"/>
<img src="https://user-images.githubusercontent.com/34037921/160303780-0e624368-c812-4ccc-97f8-d365f02e3dcc.png" width="300"/>
<img src="https://user-images.githubusercontent.com/34037921/160303782-178a4fb7-0226-4a35-be67-18f7db646f43.png" width="300"/>
<img src="https://user-images.githubusercontent.com/34037921/160303785-4411a03e-2750-4e83-b870-5732ed153de0.png" width="300"/>
<img src="https://user-images.githubusercontent.com/34037921/160303789-7d1ec629-55ec-4682-8baf-859296b48f10.png" width="300"/>
<img src="https://user-images.githubusercontent.com/34037921/160303794-5a71431d-c90a-4129-8f1f-29f62febccfb.png" width="300"/>

## Functionality

Register user
```dart
Future<String?> register(String email, String password) async {
    var users = await Hive.openBox('users');
      if(users.containsKey(email)){
        return 'Email already exist';
      }
    users.put(email, password);
    await Hive.box('loginData').put('isLogged', email);
    return null;
  }
```
Sign in user
```dart
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
```
Calculation model for database
```dart
@HiveType(typeId: 0)
class Calculation extends HiveObject{
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String equation;

  @HiveField(3)
  late String result;

  Calculation({
    required this.id,
    required this.email,
    required this.equation,
    required this.result
  });
}
```
Update user's history (put data in database)
```dart
Future<bool> putData(Calculation calculation) async {
    bool isDone = false;
    var calculations = await Hive.openBox<Calculation>('calculations');
    calculations.add(calculation).then((value) => isDone = true);
    return isDone;
  }
```
Fetch user's history (get data from database)
```dart
Future<List<Calculation>> getData(String email) async {
    var calculations = await Hive.openBox<Calculation>('calculations');
    List<Calculation> listOfCalculation =
    calculations.values.where((element) => element.email == email).toList();
    return listOfCalculation;
  }
```

Calculator model for handling the calculator functionality and using State Notifier and Riverpod
```dart
class Calculator{

  final String equation;
  final String result;
  final bool shouldAppend;

  const Calculator({
    this.equation = '0',
    this.result = '0',
    this.shouldAppend = true,
  });

  Calculator copy({
    bool? shouldAppend, String? equation, String? result,
  }) => Calculator(
    shouldAppend: shouldAppend?? this.shouldAppend,
    equation: equation ?? this.equation,
    result: result?? this.result,
  );

}
```
Append a number or operator to the equation
```dart
void append(String buttonText){
    final String? equation = (){
      if(Utils.isOperator(buttonText) &&
          Utils.isOperatorAtEnd(state.equation)){
        final newEquation = state.equation.substring(0, state.equation.length -1);
        return newEquation+buttonText;
      } else if(state.shouldAppend){
        return state.equation == '0' ?
          buttonText : state.equation + buttonText;
      } else {
        return Utils.isOperator(buttonText)
            ? state.equation + buttonText
            : buttonText;
      }
    }();

    state = state.copy(equation: equation, shouldAppend: true);
  }
```
Calculate the equation
```dart
void calculate(){
    final expression = state.equation.replaceAll('⨯', '*').replaceAll('÷', '/');
    try {
      final exp = Parser().parse(expression);
      final model = ContextModel();
      final result = '${exp.evaluate(EvaluationType.REAL, model)}';
      state = state.copy(result: result);
    }catch (e){
      print(e);
    }
  }
  ```
  Remove the last entry
  ```dart
  void delete(){
    final equation = state.equation;
    if(equation.isNotEmpty) {
      final newEquation = equation.substring(0, equation.length - 1);
      if (newEquation.isEmpty) {
        reset();
      }else {
        state = state.copy(equation: newEquation);
        calculate();
      }
    }
  }
  ```
  Reset the equation
  ```dart
  void reset(){
    const equation = '0';
    const result = '0';
    state = state.copy(equation: equation, result: result);
  }
  ```



