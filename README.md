# 简介

一个通过补全的方式在 NeoVim 中输入中文的插件。

# 演示

[Screencast from 07-19-2022 01:19:05 PM.webm](https://user-images.githubusercontent.com/17873203/179807390-63111509-acb0-4870-927b-b44b728c39bf.webm)


# 依赖

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [pyrime](https://github.com/Ninlives/pyrime)

# 配置

```lua
local cmp = require('cmp')
cmp.setup {
  -- 各种其他配置
  sources = {
    -- 各种其他 source
    { name = 'rime', 
      option = {
        shared_data_dir = '/usr/share/rime-data',
        user_data_dir = vim.fn.getenv('HOME') .. '/.local/share/cmp-rime',
        max_candidates = 10 -- 设置过高会影响补全速度。
      } 
    }
  },
}
```
