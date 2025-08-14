-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy relative path to clipboard
vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.fnamemodify(vim.fn.expand("%"), ":~:."))
  vim.notify("Copied relative path: " .. vim.fn.fnamemodify(vim.fn.expand("%"), ":~:."))
end, { desc = "Copy relative path" })

-- Copy absolute path to clipboard
vim.keymap.set("n", "<leader>cP", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Copied absolute path: " .. vim.fn.expand("%:p"))
end, { desc = "Copy absolute path" })

-- Copy relative path with line number
vim.keymap.set("n", "<leader>cl", function()
  local path_with_line = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", path_with_line)
  vim.notify("Copied: " .. path_with_line)
end, { desc = "Copy path:line" })
