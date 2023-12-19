local obj = {}
obj.__index = obj

-- Metadata
obj.name = "InputSourceSwitcher"
obj.version = "1.0"
obj.author = "ibreathebsb"
obj.github = "https://gist.github.com/ibreathebsb/65fae9d742c5ebdb409960bceaf934de"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:start()
	appWatcher = hs.application.watcher.new(applicationWatcher)
	appWatcher:start()
end

function obj:stop() end

local function Chinese()
	-- 简体拼音
	hs.keycodes.currentSourceID("com.apple.imputmethod.SCIM.ITABC")
end

local function English()
	-- ABC
	hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- app to expected ime config
-- app和对应的输入法
local app2Ime = {
	{ "/Applications/iTerm.app", "English" },
	{ "/Applications/Visual Studio Code.app", "English" },
	{ "/Applications/Google Chrome.app", "English" },
	{ "/System/Library/CoreServices/Finder.app", "English" },
	{ "/System/Applications/System Settings.app", "English" },
	{ "/Applications/如流.app", "Chinese" },
	{ "/Applications/WeChat.app", "Chinese" },
	{ "/Applications/Microsoft PowerPoint.app", "English" },
}

function updateFocusAppInputMethod()
	local ime = "English"
	local focusAppPath = hs.window.frontmostWindow():application():path()
	for index, app in pairs(app2Ime) do
		local appPath = app[1]
		local expectedIme = app[2]

		if focusAppPath == appPath then
			ime = expectedIme
			break
		end
	end

	if ime == "English" then
		English()
	else
		Chinese()
	end
end

-- Handle cursor focus and application's screen manage.
-- 窗口激活时自动切换输入法
function applicationWatcher(appName, eventType, appObject)
	if eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched then
		updateFocusAppInputMethod()
	end
end

-- helper hotkey to figure out the app path and name of current focused window
-- 当选中某窗口按下ctrl+command+.时会显示应用的路径等信息
hs.hotkey.bind({ "ctrl", "option" }, ".", function()
	hs.pasteboard.setContents(hs.window.focusedWindow():application():path())
	hs.alert.show(
		"App path:        "
			.. hs.window.focusedWindow():application():path()
			.. "\n"
			.. "App name:      "
			.. hs.window.focusedWindow():application():name()
			.. "\n"
			.. "IM source id:  "
			.. hs.keycodes.currentSourceID()
	)
end)

return obj
