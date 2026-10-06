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

			-- 外部排程每個整點更新這個檔案，這裡只負責讀
			local weather_file = vim.fs.normalize("~/Downloads/WeatherInfo.json")

			local function floor_hour(t)
				local d = os.date("*t", t)
				d.min, d.sec = 0, 0
				return os.time(d)
			end
			local this_hour = floor_hour(os.time())

			-- 每小時預報 "23°C，下雨" 拆成 { temp = "23°C", condition = "下雨" }；保留原本的位置，位置就代表時段
			local function parse_hours(hours)
				local parsed = {}
				for i, h in ipairs(hours) do
					if type(h) == "string" then
						local temp, condition = h:match("^(.-)，(.*)$")
						parsed[i] = { temp = temp or h, condition = condition or "" }
					end
				end
				return parsed
			end

			local function parse_weather(json)
				local ok, w = pcall(vim.json.decode, json or "")
				if not ok or type(w) ~= "table" then
					return nil
				end
				return {
					-- sunset_time 是 "2026年10月6日 17:36"，只留時間
					summary = ("🌧️ %s%%  💧 %s%%  🌀 %s km/h  🔆 UV %s  🌇 %s"):format(
						w.precipitation,
						w.humidity,
						w.wind,
						w.uv,
						tostring(w.sunset_time):match("%d+:%d+") or ""
					),
					hours = type(w.hours) == "table" and parse_hours(w.hours) or {},
				}
			end

			-- hours[1] 是檔案更新當下那個整點，往後共 25 小時，用檔案修改時間當起點
			-- 正常檔案是這個整點的，或剛過整點、排程還沒跑完時是上個整點的；其他（漏跑、時間在未來）都當成不可信，不顯示
			local function read_weather()
				local stat = vim.uv.fs_stat(weather_file)
				if not stat then
					return nil
				end
				local start = floor_hour(stat.mtime.sec)
				local age = (this_hour - start) / 3600
				if age < 0 or age > 1 then
					return nil
				end
				local f = io.open(weather_file, "r")
				if not f then
					return nil
				end
				local json = f:read("*a")
				f:close()
				local w = parse_weather(json)
				if w then
					w.start = start
				end
				return w
			end

			local weather = read_weather()

			-- 從現在的整點開始，每 3 小時一格，共 6 格
			local forecast_step, forecast_count = 3, 6

			-- 時段、溫度、天氣各一列；每格補成同寬置中，dashboard 逐行置中後欄位才會對齊
			local function forecast_rows()
				local columns = {}
				for i = 0, forecast_count - 1 do
					local t = this_hour + i * forecast_step * 3600
					local h = weather.hours[(t - weather.start) / 3600 + 1]
					if h then
						table.insert(columns, { os.date("%H", t) .. "時", h.temp, h.condition })
					end
				end
				if #columns == 0 then
					return {}
				end
				local width = 0
				for _, column in ipairs(columns) do
					for _, cell in ipairs(column) do
						width = math.max(width, vim.api.nvim_strwidth(cell))
					end
				end
				local rows = {}
				for r = 1, 3 do
					local cells = {}
					for c, column in ipairs(columns) do
						local pad = width - vim.api.nvim_strwidth(column[r])
						cells[c] = string.rep(" ", math.floor(pad / 2))
							.. column[r]
							.. string.rep(" ", math.ceil(pad / 2))
					end
					rows[r] = table.concat(cells, "  ")
				end
				return rows
			end

			-- week_header.append 由上到下每一列放什麼；沒有天氣就整段拿掉，連空行一起；多列的部分會展開
			local function header_rows()
				return vim.iter({
					"",
					weather and { weather.summary, "", forecast_rows(), "" } or {},
					calendar,
				})
					:flatten(2)
					:totable()
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
		end,
	},
}
