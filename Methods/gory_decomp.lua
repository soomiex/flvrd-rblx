repeat wait() until game:GetService("ReplicatedFirst"):FindFirstChild("ServerType")
local runservice = game:GetService('RunService')

local old
old = hookmetamethod(game, '__namecall', function(self, ...) 
    if (self == runservice and getnamecallmethod() == 'IsStudio') then
        return true
    end
    return old(self, ...)
end)

print(game:GetService"RunService":IsStudio())