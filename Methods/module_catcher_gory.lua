local CatchedModules = Instance.new("Folder", game)
CatchedModules.Name = "Catched_Modules"
local CachedModulesInText = {} 
local BlacklistedParents = {"StarterPlayerScripts", "StarterCharacterScripts", "RbxCharacterSounds", "AtomicBinding", "PlayerScriptsLoader", "PlayerModule", "CameraModule", "ControlModule"}
local BlacklistedKeywords = {"rodux", "roact"}

function HasItemBeenCached(object) 
    return table.find(CachedModulesInText, object.Name)
end 

function IsBlacklisted(object) 
    if object == nil or object.Parent == nil or object.Name == nil or object.Parent.Name == nil then return end 
    
    if table.find(BlacklistedParents, object.Name) ~= nil then 
        return true 
    end

    if table.find(BlacklistedParents, object.Parent.Name) ~= nil then 
        return true 
    end

    return false 
end

function IsBlacklistedKeywords(object) 
    if object == nil or object.Name == nil then return end 

    if table.find(BlacklistedKeywords, string.lower(object.Name)) ~= nil then 
        return true 
    end

    if string.lower(object.Name) == object.Name then -- "Hello" -> hello == Hello | "hello" -> hello == hello  
        return true 
    end 

    return false
end

function AddModuletoCatcher(object)
    if (#object.Name <= 5) then 
        return 
    end
    if HasItemBeenCached(object) ~= nil then 
        return 
    end

    if IsBlacklisted(object) then 
        return 
    end

    if IsBlacklistedKeywords(object) then 
        return 
    end

    if object ~= nil and object.Parent ~= nil then 
        spawn(function()
            object:Clone().Parent = CatchedModules -- avoid possible errors here too 
        end)
        table.insert(CachedModulesInText, object.Name)
    end
end

while wait(.5) do 
    for i,v in pairs(game:GetDescendants()) do 
        if v:IsA("ModuleScript") then 
            AddModuletoCatcher(v)
        end
    end
end