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

-- LSP go to definition in splits
vim.keymap.set("n", "gv", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (vsplit)" })

vim.keymap.set("n", "gs", function()
  vim.cmd("split")
  vim.lsp.buf.definition()
end, { desc = "Goto Definition (split)" })

-- Python-specific keymaps
vim.keymap.set("n", "<leader>pr", function()
  local file = vim.fn.expand("%")
  if vim.bo.filetype == "python" then
    -- Check if we're in a uv project
    if vim.fn.filereadable(vim.fn.getcwd() .. "/.venv/bin/python") == 1 then
      vim.cmd("!uv run python " .. file)
    else
      vim.cmd("!python " .. file)
    end
  end
end, { desc = "Run Python file" })

vim.keymap.set("n", "<leader>pt", function()
  if vim.bo.filetype == "python" then
    -- Check if we're in a uv project
    if vim.fn.filereadable(vim.fn.getcwd() .. "/.venv/bin/pytest") == 1 then
      vim.cmd("!uv run pytest -xvs")
    else
      vim.cmd("!pytest -xvs")
    end
  end
end, { desc = "Run Python tests" })
