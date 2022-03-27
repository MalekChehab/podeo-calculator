import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import '../constants/utils.dart';
import '../models/calculator.dart';

final calculatorProvider =
  StateNotifierProvider<CalculatorNotifier, Calculator>((ref) => CalculatorNotifier());

class CalculatorNotifier extends StateNotifier<Calculator>{
  CalculatorNotifier() : super(const Calculator());

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
  
  void equals(){
    calculate();
    resetResult();
  }
  
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

  void reset(){
    const equation = '0';
    const result = '0';
    state = state.copy(equation: equation, result: result);
  }

  void resetResult(){
    final result = state.result;
    state = state.copy(equation: result, result: '', shouldAppend: false,);
  }
}