require("lualine").setup()
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    'rust_analyzer',
  }
})


local cmp = require'cmp'

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})


local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_attach = function(client, bufnr)
end


local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
    })
  end,

  ["rust_analyzer"] = function ()
    lspconfig.rust_analyzer.setup({
      on_attach = lsp_attach,
      capabilities = lsp_capabilities,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = false;
          },
          check = {
            command = "clippy";
            extraArgs = {"--",
              "-Dclippy::all", -- this is kinda eh
              "-Wclippy::pedantic",
              "-Dclippy::restriction", -- literally not a particularly good idea
              "-Wclippy::nursery",
              "-Aclippy::self-named-module-files", "-Aclippy::mod-module-files",
              "-Aclippy::implicit-return", -- please pick one, clippy
              "-Aclippy::missing-docs-in-private-items", -- annoying
              "-Aclippy::print-stdout", -- I like println
              "-Aclippy::print-stderr", -- and eprintln
              "-Aclippy::question-mark-used", -- why, seriously
              "-Aclippy::float-arithmetic", -- I am not doing kernel dev for now
              "-Wclippy::wildcard-enum-match-arm", -- can be good, not as deny
              "-Aclippy::too-many-lines", -- please don't mark everything thanks
              "-Aclippy::single-call-fn", -- literally says "it's usually not bad"
            };
            features = "all";
          },
        },
      },
    })
  end
})
