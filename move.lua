


access_wait = 120 --seconds
plant_delay = 180 --miliseconds
dont_plant_over ={6,12,30,686,762,858,886,1040,1294,4698,4582}


bot = getBot()
world = bot:getWorld()
inventory = bot:getInventory()
bot.auto_collect = false
bot.auto_accept = true
bot.move_interval = 150
access_wait = access_wait * 1000

function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end



function contains(table_value, value)
    for k, v in pairs(table_value) do
       if v == value then return true 
       end
    end
    return false
end

function join(worldname,worldid)
    worldname = worldname:upper()
    worldid = worldid or nil
    checkonline()
    tempnumber = 0
    if not bot:isInWorld(worldname) or not world:getLocal() then
        sleep(2500)
        if worldid ~= nil then
            if bot:isInWorld() then
                bot:leaveWorld()
                while bot:isInWorld() do
                    sleep(1000)
                end
                sleep(3500)
            end
        end
        if worldid ~= nil then
            bot:warp(worldname,worldid)
        else
            bot:warp(worldname)
        end
        while not bot:isInWorld(worldname) do
            listenEvents(1)
            if cantenter then
                return false
            end
            tempnumber = tempnumber + 1
            if tempnumber >= 10 then
                bot:warp("EXIT")
                join(worldname)
            end
        end
        while not world:getLocal() do
            sleep(1000)
            tempnumber = tempnumber + 1
            if tempnumber >= 10 then
                bot:warp("EXIT")
                join(worldname)
            end
        end
        
        sleep(3500)
        if bot:isInWorld(worldname) and world:getLocal() and worldid ~= nil then
            tempnumber = 0
            while world:getTile(bot.x,bot.y).fg == 6 do
                checkonline()
                bot:warp(worldname,worldid)
                sleep(4000)
                tempnumber = tempnumber + 1
                if tempnumber >= 3 then
                    LogTheName(worldname.."|"..worldid,"idyanlisplant.txt")
                    return false
                end
            end
        end
    elseif bot:isInWorld(worldname) and worldid ~= nil then
        tempnumber = 0
        while world:getTile(bot.x,bot.y).fg == 6 do
            checkonline()
            bot:warp(worldname,worldid)
            sleep(4000)
            tempnumber = tempnumber + 1
            if tempnumber >= 3 then
                LogTheName(worldname.."|"..worldid,"idyanlisplant.txt")
                return false
            end
        end
    end
    return true
end

function contains(table_value, value)
    for k, v in pairs(table_value) do
       if v == value then return true 
       end
    end
    return false
end

function checkonline(worldnamesi)
    worldnamesi = worldnamesi or nil
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            sleep(1000)
        end
        sleep(3000)
    end
    if worldnamesi ~= nil and not bot:isInWorld(worldnamesi:upper()) then
        if not join(worldnamesi:upper()) then return false end
    end
    return true
end

function LogTheName(text,zort)
	file = io.open(zort, "a")
	file:write(text .. "\n")
	file:close()
end

function checkfloat(idz,worldismisi,worldidsi)
    checkonline2(worldismisi,worldidsi)
    for i, obj in pairs(world:getObjects()) do
        checkonline2(worldismisi,worldidsi)
        objx = math.floor(obj.x/32)
        objy = math.floor(obj.y/32)
        if obj.id == idz and (#bot:getPath(objx,objy) > 0 or bot:isInTile(objx,objy)) and not contains(canttake,tostring(obj.x)..tostring(obj.y)..tostring(obj.id)..tostring(obj.oid)) then
            return true
        end
    end
    return false
end

function getfloatingscount(idz,worldismisi)
    float = 0
    for i, obj in pairs(world:getObjects()) do
        objxxx = math.flor(obj.x/32)
        objyyy = math.flor(obj.y/32)
        if obj.id == idz and (#bot:getPath(objxxx,objyyy) > 0 or bot:isInTile(objxxx,objyyy)) then
            float = float + obj.count
        end
    end
    return {floatcount = float}
end

function gettotal(idz,worldismisi)
    checkonline(worldismisi)
    count = 0
    for i, tile in pairs(world:getTiles()) do
        checkonline(worldismisi)
        if tile.fg == idz then
            count = count + 1          
        end
    end
    return count
end

function checkaccess(worldname)
    checkonline(worldname)
    totalnotaccess = 0
    for _, tile in pairs(world:getTiles()) do
        checkonline(worldname)
        if world:hasAccess(tile.x,tile.y) == 0 then
            totalnotaccess = totalnotaccess + 1
            if totalnotaccess >= 400 then
                return false
            end
        end
    end
    return true
end

function checkstillworking(farmworld,depoworld,seedid)
    
    if bot:isInWorld(farmworld) or bot:isInWorld(depoworld) then
        invitemcount = inventory:getItemCount(seedid)
        sleep(8000)
        if inventory:getItemCount(seedid) == invitemcount then
            isdonecount = isdonecount + 1
        end
        if isdonecount >= 2 then
            return false
        end
        return true
    end
    return true
end

function dropleftovers(worldname,worldid,seedid)
    checkonline(worldname)
    if inventory:getItemCount(seedid) > 0 then
        while world:getTile(bot.x,bot.y).fg == 6 do
            checkonline(worldname)
            bot:warp(worldname,worldid)
            sleep(3500)
        end
        bot:setDirection(false)
        while inventory:getItemCount(seedid) > 0 do
            bot:drop(seedid,inventory:getItemCount(seedid))
            sleep(3000)
            checkonline(worldname)
            while world:getTile(bot.x,bot.y).fg == 6 do
                checkonline(worldname)
                bot:warp(worldname,worldid)
                sleep(3500)
            end           
            if inventory:getItemCount(seedid) > 0 then
                bot:moveUp()
                sleep(1000)
                bot:setDirection(false)
            end
        end
    end
end

function checkonline2(worldname,worldid,spacex,spacey)
    worldname = worldname:upper()
    spacex = spacex or nil
    spacey = spacey or nil
    if bot.status ~= 1 then
        while bot.status ~= 1 do
            sleep(1000)
        end
        sleep(35000)
    end
    if not bot:isInWorld(worldname) or not world:getLocal() or world:getTile(bot.x,bot.y).fg == 6 then
        while not bot:isInWorld(worldname) or not world:getLocal() or world:getTile(bot.x,bot.y).fg == 6 do
            if not join(worldname,worldid) then return false end
        end
    end
    if spacex ~= nil and spacey ~= nil then
        if bot.x ~= spacex or bot.y ~= spacey then
            if #bot:getPath(spacex,spacey) > 0 then
                bot:findPath(spacex,spacey)
            end
        end
    end

    if (bot.x == spacex or spacex == nil) and (bot.y == spacey or spacey == nil) and bot:isInWorld(worldname) and world:getLocal() and world:getTile(bot.x,bot.y).fg ~= 6 then
        return true
    else
        return false
    end
end

function checkstillexists(itemid,x,y,objoid)
    for i, objag in pairs(world:getObjects()) do
        if objag.x == x and objag.y == y and objag.id == itemid and objoid == objag.oid then return true end

    end
    return false
end

function takefloats(worldismisi,worldidsi,itemidsisi)
    ::scanagain::
    checkonline2(worldismisi,worldidsi)
    for i, obj in pairs(world:getObjects()) do
        checkonline2(worldismisi,worldidsi)
        objx = math.floor(obj.x/32)
        objy = math.floor(obj.y/32)
        if obj.id == itemidsisi and (#bot:getPath(objx,objy) > 0 or bot:isInTile(objx,objy)) and not contains(canttake,tostring(obj.x)..tostring(obj.y)..tostring(obj.id)..tostring(obj.oid)) then
            if not bot:isInTile(objx,objy) then
                bot:findPath(objx,objy)
            end
            if checkstillexists(obj.id,obj.x,obj.y,obj.oid) then
                bot:collectObject(obj.oid,10)
                sleep(3000)
                if inventory:getItemCount(obj.id) > 0 then
                    return true
                else
                    table.insert(canttake,tostring(obj.x)..tostring(obj.y)..tostring(obj.id)..tostring(obj.oid))
                end
            else
                table.insert(canttake,tostring(obj.x)..tostring(obj.y)..tostring(obj.id)..tostring(obj.oid))
                goto scanagain
            end
        end
        if inventory:getItemCount(itemidsisi) > 190 then return true end
    end
    return false
end

function planty(worldke,idke,seedidke)
    checkonline2(worldke,idke)
    reversemode = false
    lasty = 0
    for y= 1,53,2 do
        if not reversemode then
            lastx = 1
            for x=1,98,3 do
                tilex = x
                tiley = y

                if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                    checkonline2(worldke,idke)                    
                    if world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex+1,tiley) then
                            bot:findPath(tilex+1,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                         if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end   
                    
                    elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex,tiley) then
                            bot:findPath(tilex,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end

                        end
                        checkonline2(worldke,idke)
                         if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do

                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do

                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end
                        end                     
                        
                    elseif world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex-1,tiley) then
                            bot:findPath(tilex-1,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                         if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end   
                    
                    end
                    lastx = tilex
                    lasty =tiley
                end
                if tilex == 97 then
                    checkonline2(worldke,idke)
                    if world:getTile(tilex+2, tiley).fg == 0 and world:getTile(tilex+2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+2,tiley) > 0 or bot:isInTile(tilex+2,tiley)) and world:getTile(tilex+2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+2,tiley+1).fg) and getInfo(world:getTile(tilex+2, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex+2,tiley) then
                            bot:findPath(tilex+2,tiley)
                        end
                        checkonline2(worldke,idke)
                        while world:getTile(tilex+2, tiley + 1).fg == 0  and  world:hasAccess(tilex+2,tiley) > 0 do
                            if checkonline2(worldke,idke,tilex+2,tiley) then
                                bot:place(tilex+2,tiley,seedidke)
                                sleep(plant_delay)
                            end
                        end
                        
                        lastx = tilex
                        lasty =tiley                    
                    end

                end

            end
        else
            lastx = 98
            for x=98,1,-3 do
                tilex = x
                tiley = y

                if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                    checkonline2(worldke,idke)                    
                    if world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex-1,tiley) then
                            bot:findPath(tilex-1,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do

                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-1,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end                          
                    
                    elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex,tiley) then
                            bot:findPath(tilex,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end

                        end
                        checkonline2(worldke,idke)
                         if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do

                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do

                                if checkonline2(worldke,idke,tilex,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end

                            end
                        end                     
                    elseif world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex+1,tiley) then
                            bot:findPath(tilex+1,tiley)
                        end
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                            while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex-1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                         if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                            while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then

                            while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+1,tiley) then
                                    bot:place(tilex+1,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                        end   
                       
                    end
                    lastx = tilex
                    lasty =tiley
                end

                if tilex == 2 then
                    checkonline2(worldke,idke)
                    if world:getTile(tilex-2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-2,tiley) > 0 or bot:isInTile(tilex-2,tiley)) and world:getTile(tilex-2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-2,tiley+1).fg) and getInfo(world:getTile(tilex-2, tiley + 1).fg).collision_type >= 1 then
                        checkonline2(worldke,idke)
                        if inventory:getItemCount(seedidke) < 1 then
                            return 
                        end
                        if not bot:isInTile(tilex-2,tiley) then
                            bot:findPath(tilex-2,tiley)
                        end
                        checkonline2(worldke,idke)
                        while world:getTile(tilex-2, tiley + 1).fg == 0  and  world:hasAccess(tilex-2,tiley) > 0 do
                            if checkonline2(worldke,idke,tilex-2,tiley) then
                                bot:place(tilex-2,tiley,seedidke)
                                sleep(plant_delay)
                            end
                        end
                        lastx = tilex
                        lasty =tiley                    
                    end
                end
            end            
        end
        
        if lastx > 50 then
            reversemode = true
        else
            reversemode = false
        end
    end

    if lasty > 26 then
        for y= 52,0,-2 do
            if not reversemode then
                lastx = 1
                for x=1,98,3 do
                    tilex = x
                    tiley = y
    
                    if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                        checkonline2(worldke,idke)                    
                        if world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+1,tiley) then
                                bot:findPath(tilex+1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                        
                        elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex,tiley) then
                                bot:findPath(tilex,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
    
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end                     
                            
                        elseif world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-1,tiley) then
                                bot:findPath(tilex-1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                        
                        end
                        lastx = tilex
                        lasty =tiley
                    end
                    if tilex == 97 then
                        checkonline2(worldke,idke)
                        if world:getTile(tilex+2, tiley).fg == 0 and world:getTile(tilex+2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+2,tiley) > 0 or bot:isInTile(tilex+2,tiley)) and world:getTile(tilex+2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+2,tiley+1).fg) and getInfo(world:getTile(tilex+2, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+2,tiley) then
                                bot:findPath(tilex+2,tiley)
                            end
                            checkonline2(worldke,idke)
                            while world:getTile(tilex+2, tiley + 1).fg == 0  and  world:hasAccess(tilex+2,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+2,tiley) then
                                    bot:place(tilex+2,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                            
                            lastx = tilex
                            lasty =tiley                    
                        end
    
                    end
    
                end               
            else
                lastx = 98
                for x=98,1,-3 do
                    tilex = x
                    tiley = y
    
                    if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                        checkonline2(worldke,idke)                    
                        if world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-1,tiley) then
                                bot:findPath(tilex-1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end                          
                        
                        elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex,tiley) then
                                bot:findPath(tilex,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
    
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end                     
                        elseif world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+1,tiley) then
                                bot:findPath(tilex+1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                           
                        end
                        lastx = tilex
                        lasty =tiley
                    end

                    if tilex == 2 then
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-2,tiley) > 0 or bot:isInTile(tilex-2,tiley)) and world:getTile(tilex-2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-2,tiley+1).fg) and getInfo(world:getTile(tilex-2, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-2,tiley) then
                                bot:findPath(tilex-2,tiley)
                            end
                            checkonline2(worldke,idke)
                            while world:getTile(tilex-2, tiley + 1).fg == 0  and  world:hasAccess(tilex-2,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-2,tiley) then
                                    bot:place(tilex-2,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                            lastx = tilex
                            lasty =tiley                    
                        end
                    end
                end                          
            end

        end
        if lastx > 50 then
            reversemode = true
        else
            reversemode = false
        end
    else
        for y= 0,52,2 do
            if not reversemode then
                lastx = 1
                for x=1,98,3 do
                    tilex = x
                    tiley = y
    
                    if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                        checkonline2(worldke,idke)                    
                        if world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+1,tiley) then
                                bot:findPath(tilex+1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                        
                        elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex,tiley) then
                                bot:findPath(tilex,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
    
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end                     
                            
                        elseif world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-1,tiley) then
                                bot:findPath(tilex-1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                        
                        end
                        lastx = tilex
                        lasty =tiley
                    end
                    if tilex == 97 then
                        checkonline2(worldke,idke)
                        if world:getTile(tilex+2, tiley).fg == 0 and world:getTile(tilex+2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+2,tiley) > 0 or bot:isInTile(tilex+2,tiley)) and world:getTile(tilex+2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+2,tiley+1).fg) and getInfo(world:getTile(tilex+2, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+2,tiley) then
                                bot:findPath(tilex+2,tiley)
                            end
                            checkonline2(worldke,idke)
                            while world:getTile(tilex+2, tiley + 1).fg == 0  and  world:hasAccess(tilex+2,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex+2,tiley) then
                                    bot:place(tilex+2,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                            
                            lastx = tilex
                            lasty =tiley                    
                        end
    
                    end
    
                end                                               
            else
                lastx = 98
                for x=98,1,-3 do
                    tilex = x
                    tiley = y
    
                    if (world:getTile(tilex, tiley).fg == 0 or world:getTile(tilex-1, tiley).fg == 0 or world:getTile(tilex+1, tiley).fg == 0)  then  
                        checkonline2(worldke,idke)                    
                        if world:getTile(tilex-1,tiley).fg == 0 and world:getTile(tilex-1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-1,tiley) > 0 or bot:isInTile(tilex-1,tiley)) and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-1,tiley) then
                                bot:findPath(tilex-1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex-1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end                          
                        
                        elseif world:getTile(tilex,tiley).fg == 0 and world:getTile(tilex, tiley + 1).fg ~= 0 and (#bot:getPath(tilex,tiley) > 0 or bot:isInTile(tilex,tiley)) and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex,tiley) then
                                bot:findPath(tilex,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
    
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
    
                                    if checkonline2(worldke,idke,tilex,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
    
                                end
                            end                     
                        elseif world:getTile(tilex+1,tiley).fg == 0 and world:getTile(tilex+1, tiley + 1).fg ~= 0 and (#bot:getPath(tilex+1,tiley) > 0 or bot:isInTile(tilex+1,tiley)) and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex+1,tiley) then
                                bot:findPath(tilex+1,tiley)
                            end
                            checkonline2(worldke,idke)
                            if world:getTile(tilex-1, tiley + 1).fg ~= 0 and world:getTile(tilex-1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-1,tiley+1).fg) and getInfo(world:getTile(tilex-1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex-1,tiley) > 0 then
                                while world:getTile(tilex-1,tiley).fg == 0 and world:hasAccess(tilex-1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex-1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                             if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex, tiley + 1).fg ~= 0 and world:getTile(tilex,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex,tiley+1).fg) and getInfo(world:getTile(tilex, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex,tiley) > 0 then
                                while world:getTile(tilex,tiley).fg == 0 and world:hasAccess(tilex,tiley) > 0 do
        
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if world:getTile(tilex+1, tiley + 1).fg ~= 0 and world:getTile(tilex+1,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex+1,tiley+1).fg) and getInfo(world:getTile(tilex+1, tiley + 1).fg).collision_type >= 1 and world:hasAccess(tilex+1,tiley) > 0 then
    
                                while world:getTile(tilex+1,tiley).fg == 0 and world:hasAccess(tilex+1,tiley) > 0 do
                                    if checkonline2(worldke,idke,tilex+1,tiley) then
                                        bot:place(tilex+1,tiley,seedidke)
                                        sleep(plant_delay)
                                    end
                                end
                            end   
                           
                        end
                        lastx = tilex
                        lasty =tiley
                    end

                    if tilex == 2 then
                        checkonline2(worldke,idke)
                        if world:getTile(tilex-2, tiley + 1).fg ~= 0 and (#bot:getPath(tilex-2,tiley) > 0 or bot:isInTile(tilex-2,tiley)) and world:getTile(tilex-2,tiley+1).fg % 2 == 0 and not contains(dont_plant_over,world:getTile(tilex-2,tiley+1).fg) and getInfo(world:getTile(tilex-2, tiley + 1).fg).collision_type >= 1 then
                            checkonline2(worldke,idke)
                            if inventory:getItemCount(seedidke) < 1 then
                                return 
                            end
                            if not bot:isInTile(tilex-2,tiley) then
                                bot:findPath(tilex-2,tiley)
                            end
                            checkonline2(worldke,idke)
                            while world:getTile(tilex-2, tiley + 1).fg == 0  and  world:hasAccess(tilex-2,tiley) > 0 do
                                if checkonline2(worldke,idke,tilex-2,tiley) then
                                    bot:place(tilex-2,tiley,seedidke)
                                    sleep(plant_delay)
                                end
                            end
                            lastx = tilex
                            lasty =tiley                    
                        end
                    end
                end 
            end
        end
        if lastx > 50 then
            reversemode = true
        else
            reversemode = false
        end
    end
    --[[for _, tile in pairs(world:getTiles()) do
        checkonline2(worldke,idke)
        if world:getTile(tile.x, tile.y).fg == 0 and  world:getTile(tile.x, tile.y + 1).fg ~= 0 and world:getTile(tile.x, tile.y + 1).fg ~= seedidke and world:getTile(tile.x,tile.y+1).fg % 2 == 0 and inventory:getItemCount(seedidke) > 0 and not contains(dont_plant_over,world:getTile(tile.x,tile.y+1).fg) then
            bot:findPath(tile.x,tile.y)
            while world:getTile(tile.x, tile.y).fg == 0 do
                if checkonline2(worldke,idke,tile.x,tile.y) then
                    bot:place(tile.x,tile.y,seedidke)
                    sleep(plant_delay)
                end
            end
        end
        if inventory:getItemCount(seedidke) < 1 then
            return 
        end
    end
    --]]
    worldbitti = true
end



function main()
    while file_exists("bannedplant.txt") do
        sleep(1000)
    end
    cantenter = false
    canttake = {}
    denedik = false
    log = getBot():getLog()
    log:clear()
    function On_Dialog(variant, netid)
        if variant:get(0):getString() == "OnConsoleMessage" then
            if variant:get(1):getString() ~= nil then
                if variant:get(1):getString():find("inaccessible") or variant:get(1):getString():find("been banned") or variant:get(1):getString():find("Try another") or variant:get(1):getString():find("banned from that world") or variant:get(1):getString():find("lower than") or variant:get(1):getString():find("created too many") or variant:get(1):getString():find("The system is currently experiencing") or variant:get(1):getString():find("Unable to enter") or variant:get(1):getString():find("due to") then
                    if variant:get(1):getString():find("been banned") or variant:get(1):getString():find("banned from that world") and not denedik then
                        denedik = true
                        LogTheName("","bannedplant.txt")
                        os.remove("movebotplant.txt")
                        log = getBot():getLog()
                        log:clear()
                        sleep(3000)
                        denedik = false
                    end
                    cantenter = true
                    
                end
            end
        end
    end
    addEvent(Event.variantlist, On_Dialog)
    checkonline()
    if file_exists("movebotplant.txt") then
        totalsleep = 0
        local file = io.open("movebotplant.txt", "r")
        for line in file:lines() do
            linez = line
        end
        file:close()
        fo = {}
        for w in linez:gmatch("([^|]+)|?") do 
            table.insert(fo, w)
        end
        farmworld = fo[1]
        farmworldid = fo[2]
        seedid = tonumber(fo[3])
        depoworld = fo[4]
        depoworldid = fo[5]
        if join(depoworld,depoworldid) then
            seedvarmi = checkfloat(seedid,depoworld,depoworldid)
            if not seedvarmi  then
                LogTheName("","cantfindseedsplant.txt")
                os.remove("movebotplant.txt")
                while file_exists("cantfindseedsplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
                while totalsleep < 5 do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
                totalsleep = 0                
            elseif seedvarmi then
                seedcount = getfloatingscount(seedid,depoworld).floatcount
                LogTheName(tostring(seedcount),"seedcountplant.txt")
            end      
        else
            if file_exists("bannedplant.txt") then
                os.remove("movebotplant.txt")
                while file_exists("bannedplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
  
            else
                LogTheName("","cantenterplant.txt")
                os.remove("movebotplant.txt")
                while file_exists("cantenterplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
            end


            while totalsleep < 5 do
                sleep(1000)
                totalsleep = totalsleep + 1
            end
            totalsleep = 0
            goto endis
        end        
        if join(farmworld) then
            waitingtime = 0
            while not checkaccess(farmworld) do
                sleep(1000)
                waitingtime = waitingtime + 1000
                if waitingtime >= access_wait then
                    LogTheName("","idonthaveaccessplant.txt")
                    os.remove("movebotplant.txt")
                    while file_exists("idonthaveaccessplant.txt") do
                        sleep(1000)
                        totalsleep = totalsleep + 1
                    end
                    while totalsleep < 5 do
                        sleep(1000)
                        totalsleep = totalsleep + 1
                    end
                    totalsleep = 0
                    goto endis                  
                end
            end
            if join(farmworld,farmworldid) then
                baslangictakacvar = gettotal(seedid,farmworld)
                worldbitti = false
                ::checkagain::
                while checkfloat(seedid,depoworld,depoworldid) and not worldbitti do
                    checkonline2(depoworld,depoid)
                    if takefloats(depoworld,depoworldid,seedid) then
                        checkonline2(farmworld,farmworldid)
                        planty(farmworld,farmworldid,seedid)
                    else
                        goto checkagain
                    end
                end
                dropleftovers(depoworld,depoworldid,seedid)
                checkonline(farmworld)
                bitistekacvar = gettotal(seedid,farmworld)
                ekilen = bitistekacvar - baslangictakacvar
                LogTheName(tostring(ekilen),"hallettikplant.txt")
                os.remove("movebotplant.txt")
                while file_exists("hallettikplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
                while totalsleep < 5 do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
                totalsleep = 0
            else
                if file_exists("bannedplant.txt") then
                    os.remove("movebotplant.txt")
                    while file_exists("bannedplant.txt") do
                        sleep(1000)
                        totalsleep = totalsleep + 1
                    end
      
                else
                    LogTheName("","cantenterplant.txt")
                    os.remove("movebotplant.txt")
                    while file_exists("cantenterplant.txt") do
                        sleep(1000)
                        totalsleep = totalsleep + 1
                    end
                end
                while totalsleep < 5 do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
                totalsleep = 0
                goto endis
            end 
        else
            if file_exists("bannedplant.txt") then
                os.remove("movebotplant.txt")
                while file_exists("bannedplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
  
            else
                LogTheName("","cantenterplant.txt")
                os.remove("movebotplant.txt")
                while file_exists("cantenterplant.txt") do
                    sleep(1000)
                    totalsleep = totalsleep + 1
                end
            end
            while totalsleep < 5 do
                sleep(1000)
                totalsleep = totalsleep + 1
            end
            totalsleep = 0
        end
        ::endis::
        if bot:isInWorld() then
            bot:leaveWorld()
            sleep(3000)
        end
    end
end


main()
