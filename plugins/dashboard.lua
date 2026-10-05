return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local function cal_lines()
				local lines = vim.fn.systemlist("cal -3")
				if vim.v.shell_error ~= 0 then
					return {}
				end
				-- dashboard 會逐行置中，先補成同寬，月曆欄位才會對齊
				local width = 0
				for i, line in ipairs(lines) do
					lines[i] = line:gsub("%s+$", "")
					width = math.max(width, vim.api.nvim_strwidth(lines[i]))
				end
				while lines[#lines] == "" do
					table.remove(lines)
				end
				for i, line in ipairs(lines) do
					lines[i] = line .. string.rep(" ", width - vim.api.nvim_strwidth(line))
				end
				return lines
			end

			local calendar = cal_lines()
			local today_ns = vim.api.nvim_create_namespace("dashboard_today")

			-- cal -3 每個月寬 20、中間隔 2 格，本月在第 23–42 欄；跟 cal 一樣反白 2 格寬的日期欄位
			local function find_today()
				local day = tostring(os.date("*t").day)
				for _, line in ipairs(calendar) do
					local _, e = line:sub(23, 42):find("%f[%d]" .. day .. "%f[%D]")
					if e then
						return line, 20 + e, 22 + e
					end
				end
			end
			local today_line, today_start, today_end = find_today()

			vim.api.nvim_create_autocmd("User", {
				pattern = "DashboardLoaded",
				callback = function()
					if not today_line then
						return
					end
					vim.api.nvim_set_hl(0, "DashboardToday", { reverse = true, default = true })
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.bo[buf].filetype == "dashboard" then
							vim.api.nvim_buf_clear_namespace(buf, today_ns, 0, -1)
							for row, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
								if text:sub(-#today_line) == today_line then
									local offset = #text - #today_line
									vim.api.nvim_buf_set_extmark(buf, today_ns, row - 1, offset + today_start, {
										end_col = offset + today_end,
										hl_group = "DashboardToday",
										priority = 5000,
									})
									break
								end
							end
						end
					end
				end,
			})

			-- 天氣一天抓一次，結果存在 TMPDIR，同一天再開 nvim 就直接讀檔
			local weather_cache = vim.fs.joinpath(vim.env.TMPDIR or "/tmp", "nvim-weather-" .. os.date("%F") .. ".json")

			local function format_weather(json)
				local ok, w = pcall(vim.json.decode, json or "")
				if not ok or type(w) ~= "table" then
					return nil
				end
				return ("🌡️ %s-%s 🌧️ %s%% 💧%s%% 🌀 %s km/h"):format(
					w.min_t,
					w.max_t,
					w.precipitation,
					w.humidity,
					w.wind
				)
			end

			local function read_cached_weather()
				local f = io.open(weather_cache, "r")
				if not f then
					return nil
				end
				local json = f:read("*a")
				f:close()
				return format_weather(json)
			end

			local weather = read_cached_weather()

			-- week_header.append 由上到下每一列放什麼；calendar 是多列，會展開
			local function header_rows()
				return vim.iter({
					weather or "",
					"",
					calendar,
				}):flatten():totable()
			end

			-- 捷徑要跑約 0.6 秒，非同步執行，拿到結果後寫入快取，再讓 dashboard 重畫
			local function fetch_weather()
				vim.system(
					{ "shortcuts", "run", "WeatherInfo" },
					{ text = true, timeout = 10000 },
					vim.schedule_wrap(function(res)
						weather = res.code == 0 and format_weather(res.stdout) or nil
						if not weather then
							return
						end
						local f = io.open(weather_cache, "w")
						if f then
							f:write(res.stdout)
							f:close()
						end
						require("dashboard").opts.config.week_header.append = header_rows()
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							if vim.bo[buf].filetype == "dashboard" then
								vim.api.nvim_exec_autocmds("VimResized", { buffer = buf })
							end
						end
					end)
				)
			end

			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
						concat = "",
						append = header_rows(),
					},
					shortcut = {
						{
							icon = " ",
							icon_hl = "Function",
							desc = "Find file",
							group = "Function",
							key = "f",
							action = "lua Snacks.dashboard.pick('files')",
						},
						{
							icon = " ",
							icon_hl = "String",
							desc = "Recent files",
							group = "String",
							key = "r",
							action = "lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							icon_hl = "DiagnosticHint",
							desc = "Find Text",
							group = "DiagnosticHint",
							key = "g",
							action = "lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							icon_hl = "Number",
							desc = "Config",
							group = "Number",
							key = "c",
							action = "lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{
							icon = " ",
							icon_hl = "Special",
							desc = "Lazy Extras",
							group = "Special",
							key = "x",
							action = "LazyExtras",
						},
						{
							icon = "󰒲 ",
							icon_hl = "Title",
							desc = "Lazy",
							group = "Title",
							key = "l",
							action = "Lazy",
						},
						{
							icon = " ",
							icon_hl = "DiagnosticError",
							desc = "Quit",
							group = "DiagnosticError",
							key = "q",
							action = "qa",
						},
					},
					project = {
						enable = false,
					},
					mru = {
						enable = true,
						limit = 10,
						icon = " ",
						label = " Most Recent Files:",
						cwd_only = false,
					},
					footer = {
						"",
						"ご武運を",
					},
				},
			})
			if not weather then
				fetch_weather()
			end
		end,
	},
}
