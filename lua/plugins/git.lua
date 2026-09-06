return {
  {
    "lewis6991/gitsigns.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      current_line_blame = true, -- the GitLens inline blame
      current_line_blame_opts = { delay = 400, virt_text_pos = "eol" },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev hunk")

        map({ "n", "v" }, "<leader>gs", gs.stage_hunk, "Stage hunk")
        map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line (full)")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>ub", gs.toggle_current_line_blame, "Toggle inline blame")
        map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
      end,
    },
  },

  -- Side-by-side diffs and file history: the VSCode diff editor and GitLens
  -- file-history equivalents.
  {
    "sindrets/diffview.nvim",
    enabled = true,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    opts = { enhanced_diff_hl = true },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (branch)" },
      { "<leader>gh", "<Esc><cmd>'<,'>DiffviewFileHistory<cr>", mode = "v", desc = "History of selection" },
    },
  },
}
