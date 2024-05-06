function checkbanned()
    
    function file_exists(name)
        local f = io.open(name, "r")
        return f ~= nil and io.close(f)
    end
    
    while true do
        if file_exists("bannedplant.txt") then
              limk = "https://raw.githubusercontent.com/deezy154/myscripts/main/move.lua"
              client = HttpClient.new()
              client.url = limk
              local script1 = client:request().body
             getBot():stopScript()
            
            getBot():runScript(script1)
        end

        sleep(5000)
    end

end

runThread(checkbanned)

while true do
    LINK = "https://raw.githubusercontent.com/deezy154/myscripts/main/move.lua"
    client = HttpClient.new()
    client.url = LINK
    local response = client:request().body
    assert(load(response))()
    sleep(250)
end
