--      VariablesClass
-- Directed for module "Variables", 
-- Before-scramble location: ReplicatedStorage (Service) -> Variables (ModuleScript)
-- 
-- Gory loves me 💖
-- IndexesInside offsets updated: 4/2/2023 
-- Extra Notes: Gory inserts the variables into the module metatable. 

local VariablesClass = {} 

VariablesClass.ClassName = "VariablesClass"
VariablesClass.Location = nil 
VariablesClass.RequiredMetaTable = nil 
VariablesClass.IndexesInside = {"ChantMoraleFactor"} -- TODO; add more function examples later 

function VariablesClass.Check(TableToCheck)
    if table.isfrozen(TableToCheck) then -- good sign 
        local HasIndexMatched = false 
        for indexIndex, indexMatch in pairs(VariablesClass.IndexesInside) do 
            if TableToCheck[indexMatch] ~= nil then -- bingo 
                return true -- yup; we got it. 
            end
        end 
    end
    return false 
end

function VariablesClass.UnlockTable() 
    local NewTable = {} 
    local NewMeta = {} 

    for i,v in pairs(VariablesClass.RequiredMetaTable) do 
        NewTable[i] = v 
    end 

    -- theory: no need to set a new meta, when module is called it returns a frozen table ;this time it won't return a frozen because we overrid it ? 

    VariablesClass.RequiredMetaTable = NewTable -- overrid ?
end 

function VariablesClass.ChangeValue(IndexString, NewValue) 
    -- todo ; 
end 

return VariablesClass