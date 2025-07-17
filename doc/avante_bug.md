https://github.com/yetone/avante.nvim/pull/2185

## Bug Fix Attempts
- Set `enable_streaming` to `false`  
- Tried using tags `v0.0.25` and `v0.0.24` instead of `version = false`
- Changed model to `claude-3-opus-20240229`
- Adjusted other `behaviour` settings like disabling `enable_token_counting`

## Reverting to Stable Version
Once a stable version of Avante is released, revert the following in the `/home/banister/.config/nvim/lua/plugins/avante.lua` file:
1. Remove the `tag` or `commit` line
2. Change model back to `claude-sonnet-4-20250514` or the latest recommended model 
3. Set `enable_streaming` and other `behaviour` settings back to their defaults
4. Remove any other temporary workarounds added during debugging

