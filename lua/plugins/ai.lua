-- AI assistance.
--
-- Every plugin in this config carries an `enabled` flag. Flip it and run
-- `:Lazy sync` -- disabled plugins are never downloaded or loaded.

-- Inline completion trigger. false = suggestions only appear when you press
-- <M-y>. true = they appear on their own after you pause typing, the way
-- Copilot behaves. Manual is the default: it costs nothing in the background
-- and never surprises you mid-thought.
local AUTO_TRIGGER = false

return {
  -----------------------------------------------------------------------
  -- Inline ghost-text completion, running locally through Ollama.
  -- Free, private (nothing leaves the machine) and offline.
  --
  -- Setup, once:
  --   brew install ollama
  --   brew services start ollama          # or just: ollama serve
  --   ollama pull qwen2.5-coder:1.5b      # ~1GB
  --
  -- Until Ollama is running this simply does nothing: completion is manual
  -- (<M-y>), so there are no background requests to fail.
  --
  -- Models, all `ollama pull <name>` then change `model` below:
  --   qwen2.5-coder:1.5b   ~1GB    fastest, the default here
  --   qwen2.5-coder:3b     ~2GB    noticeably better, still comfortably fast
  --   qwen2.5-coder:7b     ~4.7GB  best quality, wants 16GB+ RAM
  --   deepseek-coder-v2:16b ~9GB   strong alternative if you have the RAM
  --   starcoder2:3b        ~1.7GB  broader language coverage, weaker at Python
  --
  -- All of the above support fill-in-the-middle, which is what this needs --
  -- a general chat model (llama3, mistral) will give poor completions here.
  -----------------------------------------------------------------------
  {
    "milanglacier/minuet-ai.nvim",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "InsertEnter",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 2048,
      request_timeout = 3,
      throttle = 1000,
      debounce = 400,
      notify = "warn", -- only real problems, not every request
      virtualtext = {
        -- Filetypes that complete automatically. AUTO_TRIGGER at the top of
        -- this file switches it on for everything; `debounce` above is how
        -- long you must pause first. Replace with an explicit list such as
        -- { "python", "go", "lua" } to auto-trigger only in some filetypes.
        auto_trigger_ft = AUTO_TRIGGER and { "*" } or {},
        -- Filetypes never to auto-trigger in, even when the above is on.
        auto_trigger_ignore_ft = { "markdown", "text", "gitcommit", "help" },
        keymap = {
          accept = "<M-y>",
          accept_line = "<M-Y>",
          prev = "<M-[>",
          next = "<M-]>",
          dismiss = "<M-e>",
        },
      },
      provider_options = {
        openai_fim_compatible = {
          -- Ollama needs no key, but minuet wants the name of an env var that
          -- exists; TERM is always set and its value is ignored.
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:1.5b",
          optional = { max_tokens = 128, top_p = 0.9 },
        },
      },
    },
    keys = {
      { "<leader>am", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle inline AI completion" },
    },
  },

  -----------------------------------------------------------------------
  -- Claude Code in a split: chat, refactors and multi-file edits, with the
  -- same diff-accept flow as the VSCode extension. Uses your existing
  -- `claude` CLI login, so no API key.
  --
  -- This cannot do inline completion -- `claude -p` takes 8-26s per request
  -- because it starts a full agent session each time. That is what the
  -- Ollama setup above is for.
  -----------------------------------------------------------------------
  {
    "coder/claudecode.nvim",
    enabled = true,
    dependencies = { "folke/snacks.nvim" },
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
    opts = { terminal = { split_side = "right", split_width_percentage = 0.35 } },
    keys = {
      { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to context" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ax", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
    },
  },
}
