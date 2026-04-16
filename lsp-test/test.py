# Python LSP Test (pylsp)
# 期待される動作: 型ヒント、補完、ホバー情報、リント

from typing import List, Optional


class User:
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

    def greet(self) -> str:
        return f"Hello, {self.name}!"


def process_users(users: List[User]) -> Optional[User]:
    """ユーザーリストから最初のユーザーを返す"""
    if users:
        return users[0]
    return None


# テスト: userの後にドットを入力 → 補完が出るか
user = User("Test", 25)
print(user.greet())

# テスト: 未使用インポートの警告
import os

# テスト: 未使用変数
unused_var = "unused"

