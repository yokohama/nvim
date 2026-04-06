// JavaScript LSP Test (ts_ls + eslint)
// 期待される動作: 補完、ESLintルール適用

const users = [
  { id: 1, name: "Alice" },
  { id: 2, name: "Bob" },
];

// テスト: usersの後にドットを入力 → Array補完
const names = users.map((user) => user.name);

// テスト: console補完
console.log(names);

// テスト: ESLint警告（未使用変数）
const unusedVariable = "unused";

// テスト: 関数の補完
function fetchData(url) {
  return fetch(url).then((res) => res.json());
}

// テスト: async/await
async function getData() {
  const data = await fetchData("https://api.example.com");
  return data;
}
