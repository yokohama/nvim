// Rust LSP Test (rust-analyzer)
// 期待される動作: 型推論、補完、ホバー情報、インレイヒント

use std::collections::HashMap;

#[derive(Debug, Clone)]
struct User {
    name: String,
    age: u32,
}

impl User {
    fn new(name: &str, age: u32) -> Self {
        Self {
            name: name.to_string(),
            age,
        }
    }

    fn greet(&self) -> String {
        format!("Hello, {}!", self.name)
    }
}

fn process_users(users: Vec<User>) -> Option<User> {
    users.into_iter().next()
}

fn main() {
    // テスト: userの後にドットを入力 → 補完が出るか
    let user = User::new("Test", 25);
    println!("{}", user.greet());

    // テスト: 型推論のインレイヒント
    let numbers = vec![1, 2, 3, 4, 5];
    let sum: i32 = numbers.iter().sum();

    // テスト: HashMap補完
    let mut map = HashMap::new();
    map.insert("key", "value");

    // テスト: 未使用変数の警告
    let unused_var = "unused";
}

  let v: Vec<i32> = vec![1, 2, 3];
  let s: String = String::from("hello");
  let opt: Option<i32> = Some(42);
