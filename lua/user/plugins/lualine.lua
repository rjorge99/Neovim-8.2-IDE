-- -- try git status

-- helper function to loop over string lines
-- copied from https://stackoverflow.com/a/19329565
local function iterlines(s)
	if s:sub(-1) ~= "\n" then
		s = s .. "\n"
	end
	return s:gmatch("(.-)\n")
end

-- find directory
function find_dir(d)
	-- return if root
	if d == "/" then
		return d
	end
	-- check renaming
	local ok, err, code = os.rename(d, d)
	if not ok then
		if code ~= 2 then
			-- all other than not existing
			return d
		end
		-- not existing
		local newd = d:gsub("(.*/)[%w._-]+/?$", "%1")
		return find_dir(newd)
	end
	-- d ok write 'ok_dir' variable & return d
	vim.b["ok_dir"] = d
	return d
end

-- get git status
local function git_status()
	-- get & check file directory
	local file_dir = vim.b["ok_dir"]
	if file_dir == nil then
		file_dir = find_dir(vim.fn.expand("%:p:h"))
	end
	-- capture git status call
	local cmd = "git -C " .. file_dir .. " status --porcelain -b 2> /dev/null"
	local handle = assert(io.popen(cmd, "r"), "")
	-- output contains empty line at end (removed by iterlines)
	local output = assert(handle:read("*a"))
	-- close io
	handle:close()

	-- git_state is array with entries branch/staged/modified/untracked
	local git_state = { "", "", "", "" }
	-- branch coloring: 'o': up to date with origin; 'd': head detached; 'm': not up to date with origin
	local branch_col = "o"

	-- check if git repo
	if output == "" then
		-- not a git repo
		-- save to variable
		vim.g.git_state = git_state
		-- exit
		return branch_col
	end

	-- iterate over lines
	-- get line iterator
	local line_iter = iterlines(output)

	-- process first line (HEAD)
	local line = line_iter()
	if line:find("%(no branch%)") ~= nil then
		-- detached head
		branch_col = "d"
	else
		-- on branch
		local ahead = line:gsub(".*ahead (%d+).*", "%1")
		local behind = line:gsub(".*behind (%d+).*", "%1")
		-- convert non-numeric to nil
		ahead = tonumber(ahead)
		behind = tonumber(behind)
		if behind ~= nil then
			git_state[1] = "↓ " .. tostring(behind) .. " "
		end
		if ahead ~= nil then
			git_state[1] = git_state[1] .. "↑ " .. tostring(ahead) .. " "
		end
	end

	-- loop over residual lines (files) &
	-- store number of files
	local git_num = { 0, 0, 0 }
	for line in line_iter do
		branch_col = "m"
		-- get first char
		local first = line:gsub("^(.).*", "%1")
		if first ~= " " then
			if first == "?" then
				-- untracked
				git_num[3] = git_num[3] + 1
			else
				-- staged
				git_num[1] = git_num[1] + 1
			end
		else
			-- modified
			git_num[2] = git_num[2] + 1
		end
	end

	-- build output string
	if git_num[1] ~= 0 then
		git_state[2] = " ● " .. git_num[1]
	end
	if git_num[2] ~= 0 then
		git_state[3] = " + " .. git_num[2]
	end
	if git_num[3] ~= 0 then
		git_state[4] = " … " .. git_num[3]
	end

	-- save to variable
	vim.b.git_state = git_state

	-- return color for branch
	return branch_col
end

-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine nightfly theme
local lualine_nightfly = require("lualine.themes.nightfly")

-- new colors for theme
local new_colors = {
	blue = "#65D1FF",
	green = "#3EFFDC",
	violet = "#FF61EF",
	yellow = "#FFDA7B",
	black = "#000000",
}

-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black, -- black
	},
}

-- configure lualine with modified theme
lualine.setup({
	options = {
		theme = lualine_nightfly,
	},
	sections = {
		lualine_b = {
			{
				"branch",
				color = function(section)
					local gs = git_status()
					if gs == "d" then
						return { fg = "#916BDD" }
					elseif gs ~= "m" then
						return { fg = "#769945" }
					end
				end,
			},
			{
				-- head status
				"vim.b.git_state[1]",
				padding = { left = 0, right = 0 },
			},
			{
				-- staged files
				"vim.b.git_state[2]",
				color = { fg = "#769945" },
				padding = { left = 0, right = 1 },
			},
			{
				-- modified files
				"vim.b.git_state[3]",
				color = { fg = "#D75F00" },
				padding = { left = 0, right = 1 },
			},
			{
				-- untracked files
				"vim.b.git_state[4]",
				color = { fg = "#D99809" },
				padding = { left = 0, right = 1 },
			},
		},
	},
})
