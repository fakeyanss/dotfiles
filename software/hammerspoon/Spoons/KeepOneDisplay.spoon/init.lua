local obj = {}
obj.__index = obj

-- Metadata
obj.name = "KeepOneMonitor"
obj.version = "1.0"
obj.author = "fakeyanss"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.externalDisplayName = nil
obj.watcher = nil
obj.timer = nil


function obj:init()
    self.watcher = hs.screen.watcher.new(function() self:keepOneDisplay() end)
    self.timer = hs.timer.doEvery(600, function()
        -- 如果设置了镜像，则调用#hs.screen.allScreens()也只会得到一个屏幕；此时无法确定其他显示器（内建retina）是否关闭了亮度。
        -- 所以定时的将所有屏幕的亮度都停止镜像，来自动触发屏幕监听事件，并重新设置镜像和关闭亮度。
        -- 举个例子：
        -- 在笔记本合盖后再重新开盖，或者是熄屏后重新亮屏幕，内建retina屏幕会自动点亮并处于镜像模式，
        -- 这样会导致后续的屏幕监听永远无法触发关闭内建retina屏幕亮度的逻辑，所以加上了定时取消镜像来保证触发。
        for _, screen in pairs(hs.screen.allScreens()) do
            screen:mirrorStop()
        end
    end)
end

function obj:keepOneDisplay()
    if #hs.screen.allScreens() == 1 then           -- 只有一个屏幕(如果设置了镜像，也只会得到一个屏幕)
        if hs.screen.find("Built%-in") == nil then -- 主屏幕不是内建retina屏幕，说明某个外接屏幕是主屏幕，且其他屏幕都处于镜像状态
            if hs.screen.primaryScreen():name() ~= self.externalDisplayName then
                hs.screen.find(self.externalDisplayName):setPrimary()
            end
            return
        end
        if hs.screen.primaryScreen():name() == hs.screen.find("Built%-in"):name() and
            hs.screen.find(self.externalDisplayName) == nil then -- there is no external screen, only builtin screen working
            if hs.screen.find("Built%-in"):getBrightness() == 0 then
                hs.screen.find("Built%-in"):setBrightness(0.5)
            end
        end
    else --  有多个屏幕，且没有设置镜像
        for _, screen in pairs(hs.screen.allScreens()) do
            -- set other screens to mirror of primary screen
            if screen:name() ~= obj.externalDisplayName then
                -- print(screen:name() .. " is not primary screen, set it mirror of " .. obj.externalDisplayName)
                screen:mirrorOf(hs.screen.find(self.externalDisplayName))
                -- set brightness to 0
                screen:setBrightness(0)
            end
        end
    end
end

function obj:start(config)
    for k, v in pairs(config) do
        self[k] = v
    end
    self.watcher:start()
    self.timer:start()
end

function obj:stop()
    self.watcher:stop()
end

return obj
