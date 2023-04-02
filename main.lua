local games = {
    gory = {
        name = "gory.lua",
        gameId = 12068120918
    }
} 

function LoadGameScript(name)
    loadstring(game:HttpGet("https://flavored.fun/rblx/branches/" .. name))()
end

-- whitelist(?)

for gameCategory, gameTable in pairs(games) do 
    if gameTable.gameId == game.GameId then 
        LoadGameScript(gameTable.name) 
    end
end