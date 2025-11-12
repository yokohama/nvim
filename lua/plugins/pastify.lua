return {
  "TobinPalmer/pastify.nvim",
  cmd = { "Pastify", "PastifyAfter" },
  main = "pastify",              -- ← これで require("pastify").setup(opts) を確実に呼ぶ
  opts = {
    save = "local",              -- 画像をファイル保存
    local_path = "images",       -- ./images に保存
    use_relative_path = true,    -- Markdownには相対パスを挿入
    prompt_for_file_name = true, -- 貼り付け時にファイル名を入力
  },
}
