local servers = {
	-- "cssls",
	-- "html",
    "sumneko_lua",
	"tsserver",
	"pyright",
	-- "bashls",
	"jsonls"
	-- "yamlls",
}

local settings = {
    -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
    -- debugging issues with package installations.
    log_level = vim.log.levels.INFO,

    max_concurrent_installers = 4,
    ui = {
       -- Whether to automatically check for new versions when opening the :Mason window.
        check_outdated_packages_on_open = true,

        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "rounded",

        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
        -- just to rememeber the keymaps
        keymaps = { 
            toggle_package_expand = "<CR>", -- Keymap to expand a package
            install_package = "i", -- Keymap to install the package under the current cursor position
            update_package = "u", -- Keymap to reinstall/update the package under the current cursor position
            check_package_version = "c", -- Keymap to check for new version for the package under the current cursor position
            update_all_packages = "U", -- Keymap to update all installed packages
            check_outdated_packages = "C", -- Keymap to check which installed packages are outdated
            uninstall_package = "X", -- Keymap to uninstall a package
            cancel_installation = "<C-c>", -- Keymap to cancel a package installation
            apply_language_filter = "<C-f>", -- Keymap to apply language filter
        }
    }
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]
	local require_ok, conf_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
