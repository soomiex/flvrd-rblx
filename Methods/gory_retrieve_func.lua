-- as of 4/1/2023 "AfterAllScatterClient" only scatters to the following services: 
local SpottedServices = { "RunService", "TweenService", "TextService", "ContextActionService", "LocalizationService" }

local ClassesToRegister = { }
local FireActionClientClass = loadstring(game:HttpGet("https://raw.githubusercontent.com/soomiex/flvrd-rblx/main/Classes/FireActionClient.lua"))()
local VariablesClass = loadstring(game:HttpGet("https://raw.githubusercontent.com/soomiex/flvrd-rblx/main/Classes/Variables.lua"))()

table.insert(ClassesToRegister, FireActionClientClass)
table.insert(ClassesToRegister, VariablesClass)

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

                    if ModuleClass.Check == nil then 
                        local totalOffsetsVerified = 0 
                        for classIndex, classOffset in pairs(ModuleClass.IndexesInside) do 
                            if DoesIndexExist(requiredModule, classOffset) then 
                                totalOffsetsVerified = totalOffsetsVerified + 1
                            end
                        end

                        if totalOffsetsVerified == #ModuleClass.IndexesInside then 
                            ModuleClass.Location = b 
                            ModuleClass.RequiredMetaTable = requiredModule
                            HasInitClass = true 
                        end
                    else -- custom check function implemented 
                        if ModuleClass.Check(requiredModule) then 
                            ModuleClass.Location = b 
                            ModuleClass.RequiredMetaTable = requiredModule
                            HasInitClass = true 
                        end 
                    end 
                end)
            end
        end
    end
end

for index, _class in pairs(ClassesToRegister) do 
    repeat print("Finding class"); FindAndInitModuleByClass(_class); wait(); until _class.RequiredMetaTable ~= nil; 
    print("Found!") 
end 
print("Finished registering classes.")


-- variables testing 101 
VariablesClass.UnlockTable() 
print(VariablesClass.RequiredMetaTable.DefaultWalkSpeed)
VariablesClass.RequiredMetaTable.DefaultWalkSpeed = 25