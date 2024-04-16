local servers = { "lua_ls", "pyright", "clangd", "jdtls", "ruff_lsp" }
local sources = {
	--[[ formatters ]]
	"stylua",
	"ruff",
	"clang_format",
	"shfmt",
	--[[ linters ]]
	"codespell",
}

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				ui = {
					icons = {
						package_installed = "󰄬",
						package_pending = "󱦰",
						package_uninstalled = "",
					},
				},
			})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup()

			require("mason-null-ls").setup({
				ensure_installed = sources,
				automatic_installation = true,
				handlers = {
					function() end, -- disables automatic setup of all null-ls sources
					stylua = function(source_name, methods)
						null_ls.register(null_ls.builtins.formatting.stylua)
					end,

					shfmt = function(source_name, methods)
						null_ls.register(null_ls.builtins.formatting.shfmt)

						clang_format = function(source_name, methods)
							null_ls.register(null_ls.builtins.formatting.clang_format)
						end
						require("mason-null-ls").default_setup(source_name, methods) -- to maintain default behavior
					end,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							-- ignore = { "*" },
						},
					},
				},
			})
			lspconfig.ruff_lsp.setup({
				capabilities = capabilities,
			})
			lspconfig.clangd.setup({
				capabilities = capabilities,
			})
			lspconfig.jdtls.setup({
				capabilities = capabilities,
			})
		end,
	},
}
