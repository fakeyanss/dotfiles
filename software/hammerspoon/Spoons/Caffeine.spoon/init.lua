-- Caffeinate
-- Icon shamelessly copied from https://github.com/BrianGilbert/.hammerspoon
local obj = {}
obj.name = "Caffeine"

local caffeine

function toggleCaffeine()
  setCaffeineMenuItem(hs.caffeinate.toggle("displayIdle"))
end

function setCaffeineMenuItem(isIdle)
  if isIdle then
    caffeine = hs.menubar.new()
    caffeine:setIcon(hs.image.imageFromPath(os.getenv("HOME") .. "/.hammerspoon/Spoons/Caffeine.spoon/caffeine-on.pdf"))
    caffeine:setClickCallback(toggleCaffeine)

    hs.alert.show("Caffeinated!")
  else
    caffeine:delete()
    hs.alert.show("Decaf")
  end
end

hs.hotkey.bind({"ctrl", "alt"}, "m", toggleCaffeine)

function obj:start()
end

return obj