return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = { enabled = false },
        kotlin_language_server = { enabled = false },
      },
    },
  },
}
