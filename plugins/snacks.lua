return {
	{
		"folke/snacks.nvim",
		opts = {
			image = {
				enabled = true,
				formats = {
					"png",
					"jpg",
					"jpeg",
					"gif",
					"bmp",
					"webp",
					"tiff",
					"heic",
					"avif",
				},
			},
			picker = {
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
					},
				},
			},
		},
	},
}
