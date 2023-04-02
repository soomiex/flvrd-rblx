local SpottedServices = { "RunService", "TweenService", "TextService", "ContextActionService", "LocalizationService" }

for _,v in pairs(SpottedServices) do 
    local serv = game:GetService(v) 
    for i, modu in pairs(serv:GetChildren()) 
        if modu:IsA("ModuleScript") then 
           pcall(function() 
            local _required = require(modu) 
            if _required ~= nil then 
                if rawget(_required, "ProjectileSpread") ~= nil then 
                    print("Found variables!")
                end 
            end 
        end )
        end 
    end 
end