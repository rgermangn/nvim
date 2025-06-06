return {
	"3rd/image.nvim",
	config = function()
		require("image").setup({
			backend = "kitty",
			processor = "magick_cli", --"magick_cli" ou "magick_rock"
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					only_render_image_at_cursor_mode = "popup",
					floating_windows = false, -- se true, imagens serão renderizadas em janelas flutuantes de markdown
					filetypes = { "markdown", "vimwiki" }, -- extensões de markdown (ex: quarto) podem ir aqui
				},
				neorg = {
					enabled = true,
					filetypes = { "norg" },
				},
				typst = {
					enabled = true,
					filetypes = { "typst" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = false, -- alterna imagens quando janelas são sobrepostas
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
			editor_only_render_when_focused = false, -- mostra/esconde imagens automaticamente quando o editor ganha/perde foco
			tmux_show_only_in_active_window = false, -- mostra/esconde imagens automaticamente na janela correta do Tmux (precisa de visual-activity off)
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- renderiza arquivos de imagem como imagens ao serem abertos
		})
		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TabEnter" }, {
			pattern = "*.png,*.jpg,*.jpeg,*.gif,*.webp,*.avif", -- Pattern for image files
			callback = function()
				-- Only render if the filetype is indeed 'image'
				if vim.bo.filetype == "image" then
					require("image").render_images()
				end
			end,
			desc = "Render images on buffer/window enter for image files",
		})
	end,
}
