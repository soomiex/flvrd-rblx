--      FireActionClientClass
-- Directed for module "FireActionClient", 
-- Before-scramble location: StartClient (LocalScript) -> WeaponsClient (ModuleScript) -> WeaponModules (Folder) -> FireActionClient (ModuleScript)
-- 
-- Gory loves me 💖
-- IndexesInside offsets updated: 4/2/2023 
-- Extra Notes: No other extra functions should be required here(?) I don't see anything exploit-worthy in FireActionClient anyways /shrug 

local FireActionClientClass = {}

FireActionClientClass.ClassName = "FireActionClientClass"
FireActionClientClass.Location = nil 
FireActionClientClass.RequiredMetaTable = nil 
FireActionClientClass.IndexesInside = {"UpdateReticle", "LockedAim", "ReloadTrackStopped", "BeginReload"} -- TODO; add more function examples later 

function FireActionClientClass.SetReload(NewValue) 
    if FireActionClientClass.RequiredMetaTable == nil then 
        warn("[FireActionClientClass] .RequiredMetaTable has not been initialized.")
        return 
    end
    FireActionClientClass.RequiredMetaTable.reloaded = NewValue
end

return FireActionClientClass