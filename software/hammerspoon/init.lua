-- luacheck: globals hs spoon

-- define spoons and config, which will be passed to :start
local spoons = {
	HoldToQuit = {},
	SpeedMenu = {},
	HSaria2 = {},
	Caffeine = {},
	ReloadConfiguration = {},
	-- UnsplashZ = {},
    Window = {},
    Clipboard = {},
    EjectMenu = {},
    TimeFlow = {}
}

-- load spoons
for spoonName, spoonConfig in pairs(spoons) do
	hs.loadSpoon(spoonName)
	spoon[spoonName]:start(spoonConfig)
end

-- load vim mode
local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()
vim:disableForApp('Code')
vim:enterWithSequence('jk')
vim:useFallbackMode('Google Chrome')
vim:shouldDimScreenInNormalMode(false)

-- ModalMgr Spoon must be loaded explicitly, because HSaria2 relies upon it.
hs.loadSpoon("ModalMgr")

-- Register HSaria2
if spoon.HSaria2 then
    -- First we need to connect to aria2 rpc host
    hsaria2_host = "http://localhost:6800/jsonrpc"
    hsaria2_secret = "fakeyanss"
    spoon.HSaria2:connectToHost(hsaria2_host, hsaria2_secret)

    hsaria2_keys = hsaria2_keys or {"alt", "D"}
    if string.len(hsaria2_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaria2_keys[1], hsaria2_keys[2], 'Toggle aria2 Panel', function() spoon.HSaria2:togglePanel() end)
    end
end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
