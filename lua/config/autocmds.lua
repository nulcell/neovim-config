local function augroup(name)
  return vim.api.nvim_create_augroup("cfg_" .. name, { clear = true })
end
local au = vim.api.nvim_create_autocmd

au("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Reopen a file where you left it, unless the mark is stale or it's a commit message.
au("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "gitcommit" or vim.b[ev.buf].last_loc then
      return
    end
    vim.b[ev.buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(ev.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- `q` closes throwaway windows.
au("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "man", "qf", "lspinfo", "checkhealth", "startuptime",
    "notify", "query", "dbout", "gitsigns-blame", "grug-far",
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true, desc = "Close window" })
  end,
})

-- Pressing o/O after a comment line shouldn't start another comment.
au("FileType", {
  group = augroup("no_comment_continuation"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o", "r" })
  end,
})

au("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Trailing whitespace on save, cursor left where it was. Skipped for filetypes
-- where trailing space is meaningful.
au("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function(ev)
    if vim.tbl_contains({ "markdown", "diff", "gitsendemail" }, vim.bo[ev.buf].filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- :w to a path whose directory doesn't exist yet should just work.
au("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+://") then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ":p:h"), "p")
  end,
})

au("TermOpen", {
  group = augroup("term"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.spell = false
  end,
})

-- Equalise splits when the terminal window is resized.
au("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. tab)
  end,
})

-- Diagnostics: inline messages need no plugin on 0.11+.
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  -- virtual_text is the Error Lens equivalent: message inline at end of line.
  -- virtual_lines would render that same message again above the cursor, so it
  -- stays off and lives on <leader>uv for when a message is too long to read.
  virtual_text = { spacing = 2, prefix = "●", source = "if_many" },
  virtual_lines = false,
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})
