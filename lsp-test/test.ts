// TypeScript LSP Test (ts_ls)
// 期待される動作: 型チェック、補完、ホバー情報

interface User {
  id: number;
  name: string;
  email: string;
}

function greet(user: User): string {
  return `Hello, ${user.name}!`;
}

const user: User = {
  id: 1,
  name: "Test User",
  email: "test@example.com",
};

// テスト: userの後にドットを入力 → 補完が出るか
console.log(user.name);

// テスト: 型エラー（numberに文字列を代入）
// const wrongType: number = "string";

// テスト: 未使用変数の警告
const unusedVar = "unused";
