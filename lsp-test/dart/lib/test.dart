class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  String greet() {
    return 'Hello, I am $name and I am $age years old.';
  }

  bool isAdult() {
    return age >= 18;
  }
}

void main() {
  final user = User(name: 'Alice', age: 30);

  // テスト: userの後にドットを打って補完を確認
  // user.
  print(user.greet());

  user.greet
	user.

  // List補完テスト
  final numbers = [1, 2, 3, 4, 5];
  // numbers.
  final doubled = numbers.map((n) => n * 2).toList();
  print(doubled);

  // String補完テスト
  final message = 'Hello World';
  // message.
  print(message.toUpperCase());
}
