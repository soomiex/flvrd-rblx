-- as of 4/1/2023 "AfterAllScatterClient" only scatters to the following services: 
local SpottedServices = { "RunService", "TweenService", "TextService", "ContextActionService", "LocalizationService" }

local FireActionClientClass = {}

FireActionClientClass.Location = nil 
FireActionClientClass.RequiredMetaTable = nil 
FireActionClientClass.FunctionsInside = {"UpdateReticle", "LockedAim", "ReloadTrackStopped", "BeginReload"} -- TODO; add more function examples later 

function FireActionClientClass.SetReload(NewValue) 
    if FireActionClientClass.RequiredMetaTable == nil then 
        warn("[FireActionClientClass] .RequiredMetaTable has not been initialized.")
        return 
    end
    FireActionClientClass.reloaded = NewValue
    print("set new reload value")
end


function DoesIndexExist(_table, _index) 
    for index, _ in pairs(_table) do 
        if index == _index then 
            return true 
        end
    end
    return false 
end

function wrapc(todo)
    pcall(function() 
        todo() 
    end)
end

function FindAndInitModuleByClass(ModuleClass) 
    local HasInitClass = false 

    for index, service in pairs(SpottedServices) do 
        if HasInitClass == true then break end 
        local RegisteredService = game:GetService(service) 
        for a,b in pairs(RegisteredService:GetChildren()) do 
            if HasInitClass == true then break end 
            if b:IsA("ModuleScript") then 
                -- new thread to not stop even if it errors (some modules dont return) 
                wrapc(function() 
                    local requiredModule = require(b)

                    local totalOffsetsVerified = 0 
                    for classIndex, classOffset in pairs(ModuleClass.FunctionsInside) do 
                        if DoesIndexExist(requiredModule, classOffset) then 
                            totalOffsetsVerified = totalOffsetsVerified + 1
                        end
                    end

                    if totalOffsetsVerified == #ModuleClass.FunctionsInside then 
                        ModuleClass.Location = b 
                        ModuleClass.RequiredMetaTable = requiredModule
                        print("Verified a class.") 
                        HasInitClass = true 
                    end
                end)
            end
        end
    end
end

repeat FindAndInitModuleByClass(FireActionClientClass); wait(); print("finding fireactionclass") until FireActionClientClass.RequiredMetaTable ~= nil; 

while wait() do 
    FireActionClientClass.SetReload(true)
end 