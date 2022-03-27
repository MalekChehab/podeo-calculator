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