# Ruby LSP Test (solargraph)
# 期待される動作: 補完、ホバー情報、定義ジャンプ

class User
  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
  end

  def greet
    "Hello, #{@name}!"
  end

  def valid_email?
    @email.include?('@')
  end
end

# テスト: userの後にドットを入力 → 補完が出るか
user = User.new('Test User', 'test@example.com')
puts user.greet
user.Hello

# テスト: Stringメソッドの補完
message = 'Hello World'
puts message.upcase

# テスト: Arrayメソッドの補完
numbers = [1, 2, 3, 4, 5]
puts numbers.map { |n| n * 2 }
