import java.util.Stack;
import java.util.ArrayList;

String infix = "";
String postfix = "";
String result = "Press ENTER to calculate";

// 연산자 우선순위
int priority(String op) {
  if (op.equals("u-") || op.equals("u+")) return 3;
  if (op.equals("*") || op.equals("/")) return 2;
  if (op.equals("+") || op.equals("-")) return 1;
  return 0;
}

boolean isOperator(String s) {
  return s.equals("+") || s.equals("-") ||
         s.equals("*") || s.equals("/") ||
         s.equals("u-") || s.equals("u+");
}

// 문자열을 숫자, 연산자, 괄호로 분리
ArrayList<String> tokenize(String input) {
  ArrayList<String> tokens = new ArrayList<String>();

  for (int i = 0; i < input.length();) {
    char c = input.charAt(i);

    if (c == ' ') {
      i++;
      continue;
    }

    if (Character.isDigit(c) || c == '.') {
      String number = "";

      while (i < input.length() &&
             (Character.isDigit(input.charAt(i)) ||
              input.charAt(i) == '.')) {
        number += input.charAt(i++);
      }

      tokens.add(number);
      continue;
    }

    String op = "" + c;

    // 단항 연산자 처리 (-3, +5 등)
    if (c == '-' || c == '+') {
      if (tokens.size() == 0 ||
          tokens.get(tokens.size()-1).equals("(") ||
          isOperator(tokens.get(tokens.size()-1))) {
        op = (c == '-') ? "u-" : "u+";
      }
    }

    if (!isOperator(op) &&
        !op.equals("(") && !op.equals(")")) {
      throw new RuntimeException("Invalid character: " + c);
    }

    tokens.add(op);
    i++;
  }

  return tokens;
}

// Infix -> Postfix 변환
ArrayList<String> infixToPostfix(String input) {
  Stack<String> stack = new Stack<String>();
  ArrayList<String> output = new ArrayList<String>();
  ArrayList<String> tokens = tokenize(input);

  for (String token : tokens) {

    // 숫자는 바로 출력
    if (!isOperator(token) &&
        !token.equals("(") && !token.equals(")")) {
      output.add(token);
    }

    // 여는 괄호
    else if (token.equals("(")) {
      stack.push(token);
    }

    // 닫는 괄호
    else if (token.equals(")")) {
      while (!stack.empty() &&
             !stack.peek().equals("(")) {
        output.add(stack.pop());
      }

      if (stack.empty()) {
        throw new RuntimeException("Parenthesis error");
      }

      stack.pop();
    }

    // 연산자
    else {
      // 단항 연산자는 우선 스택에 저장
      if (token.equals("u-") || token.equals("u+")) {
        stack.push(token);
        continue;
      }

      while (!stack.empty() &&
             isOperator(stack.peek()) &&
             priority(stack.peek()) >= priority(token)) {
        output.add(stack.pop());
      }

      stack.push(token);
    }
  }

  // 스택에 남은 연산자 출력
  while (!stack.empty()) {
    String op = stack.pop();

    if (op.equals("(")) {
      throw new RuntimeException("Parenthesis error");
    }

    output.add(op);
  }

  return output;
}

// Postfix 계산
double calculatePostfix(ArrayList<String> tokens) {
  Stack<Double> stack = new Stack<Double>();

  for (String token : tokens) {

    if (!isOperator(token)) {
      stack.push(Double.parseDouble(token));
      continue;
    }

    if (token.equals("u-") || token.equals("u+")) {
      if (stack.size() < 1)
        throw new RuntimeException("Invalid expression");

      double a = stack.pop();
      stack.push(token.equals("u-") ? -a : a);
      continue;
    }

    if (stack.size() < 2)
      throw new RuntimeException("Invalid expression");

    double b = stack.pop();
    double a = stack.pop();
    double value = 0;

    if (token.equals("+")) value = a + b;
    if (token.equals("-")) value = a - b;
    if (token.equals("*")) value = a * b;

    if (token.equals("/")) {
      if (b == 0)
        throw new RuntimeException("Division by zero");

      value = a / b;
    }

    stack.push(value);
  }

  if (stack.size() != 1)
    throw new RuntimeException("Invalid expression");

  return stack.pop();
}

// 후위 표기법 문자열 출력
String joinTokens(ArrayList<String> tokens) {
  String output = "";

  for (String s : tokens) {
    if (output.length() > 0) output += " ";
    output += s;
  }

  return output;
}

void setup() {
  size(900, 300);
  textSize(24);
}

void draw() {
  background(25);

  fill(255);
  textSize(20);
  text("Infix to Postfix Calculator", 30, 40);

  textSize(22);
  fill(120, 200, 255);
  text("Infix: " + infix, 30, 100);

  fill(255, 200, 100);
  text("Postfix: " + postfix, 30, 160);

  fill(120, 255, 150);
  text("Result: " + result, 30, 220);

  fill(170);
  textSize(14);
  text("ENTER: Calculate | BACKSPACE: Delete | DELETE: Clear",
       30, 275);
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    try {
      ArrayList<String> tokens = infixToPostfix(infix);

      postfix = joinTokens(tokens);

      double answer = calculatePostfix(tokens);

      result = String.valueOf(answer);
    }
    catch (Exception e) {
      result = "Error: " + e.getMessage();
    }
  }
  else if (key == BACKSPACE && infix.length() > 0) {
    infix = infix.substring(0, infix.length() - 1);
  }
  else if (key == DELETE) {
    infix = "";
    postfix = "";
    result = "";
  }
  else if ("0123456789.+-*/() ".indexOf(key) >= 0) {
    infix += key;
  }
}
