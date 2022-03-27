import 'package:flutter/material.dart';
import 'package:podeo_calculator/services/database.dart';
import 'package:podeo_calculator/view/home/history_screen.dart';
import '../../models/calculation.dart';
import '../../services/calculator_notifier.dart';
import '../auth/login.dart';
import '../widgets/button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.only(left: 8),
          child:  Row(
            children: [
              SizedBox(
                  height: 50,
                  child: Image.asset('assets/images/podeo_logo.jpg'),
              ),
              const SizedBox(width: 6),
              const Hero(
                tag: 'calculator-tag',
                child: Text(
                  'Calculator',
                  style: TextStyle(
                    fontSize: 23
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
            children: [
              Expanded(child: buildResult()),
              Expanded(flex: 2, child: buildButtons()),
            ]
        ),
      ),
    );
  }

  Widget buildResult() {
    final state = ref.watch(calculatorProvider);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              state.equation,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                height: 1
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            state.result,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ]
      ),
    );
  }

  Widget buildButtons(){
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
            children: [
              buildButtonsRow('C', '<', '@', '÷'),
              buildButtonsRow('7', '8', '9', '⨯'),
              buildButtonsRow('4', '5', '6', '-'),
              buildButtonsRow('1', '2', '3', '+'),
              buildButtonsRow('', '0', '.', '='),
            ]
        )
    );
  }

  Widget buildButtonsRow(String first, String second, String third, String fourth){
    final row = [first, second, third, fourth];
    return Expanded(
      child: Row(
        children: row.map((item) => MyButton(
          text: item,
          onPressed: () => item == '' ? null : onClickedButton(item),
        )).toList(),
      ),
    );
  }

  void onClickedButton(String buttonText){
    final state = ref.watch(calculatorProvider);
    final calculator = ref.read(calculatorProvider.notifier);

    switch(buttonText){
      case '=' :
        calculator.equals();
        putData(state.equation, state.result);
        break;
      case '<' :
        calculator.delete();
        break;
      case 'C' :
        calculator.reset();
        break;
      case '+' :
      case '-' :
      case '÷' :
      case '⨯' :
        calculator.append(buttonText);
        break;
      case '@':
        showHistory();
        break;
      default:
        calculator.append(buttonText);
        calculator.calculate();
        break;
    }
  }

  putData(String equation, String result) async {
    var calculationId = const Uuid().v4();
    Calculation calculation = Calculation(
        id: calculationId,
        email: widget.email,
        equation: equation,
        result: result
    );
    try{
      bool dataUploaded = await Database().putData(calculation);
      if(dataUploaded){
        debugPrint('true');
      }
    } catch(e){
      debugPrint(e.toString());
    }
  }

  void showHistory(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => HistoryScreen(
                email: widget.email
            )
        )
    );
  }

  void logOut() async {
    var state = ref.watch(calculatorProvider);
    state = state.copy(equation: '0', result: '0');
    Database().logOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false);
  }
}
