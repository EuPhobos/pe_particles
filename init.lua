
pe_particles = {}

--performance config
local RADIUS = 16				-- searching radius
local SOURCES = 20				-- maximum source(spawners) per effect
local SPAWNERS = 50				-- maximum amount of particle spawners in world (too big value may freeze the server)

--effects
local pTORCHES		= true		-- smoke from torches
local pWDROPS		= true		-- water drops in the cave if water above the stone
local pLDROPS		= true		-- lava drops in the cave if lava flows above
local pLAVABOIL		= true		-- boiling lava
local pFIRE			= true		-- fire smoke effect
local pWATER		= true		-- underwater effect
local pCLAUSTRUM	= true
local pVEIL			= true
local pLEAVES		= false
local pRAIN			= false
local pSNOW			= false
local pHEIL			= false
local pASH			= false
--mods
local pACRIUM		= false
local pMOREFX		= false
local pSTORM		= false
local pGLOOPTEST	= true
local pCAVEREALMS	= true








local debug = false

--mods auto
if minetest.get_modpath("pe_acrium") == nil		then pACRIUM = false end
if minetest.get_modpath("pe_morefx") ==	nil		then pMOREFX = false end
if minetest.get_modpath("pe_storm") == nil		then pSTORM = false end
if minetest.get_modpath("glooptest") == nil		then pGLOOPTEST = false end
if minetest.get_modpath("caverealms") == nil	then pCAVEREALMS = false end
if not pACRIUM		then minetest.log("pe_particles: Mod pe_acrium not found")
if not pMOREFX		then minetest.log("pe_particles: Mod pe_morefx not found")
if not pSTORM		then minetest.log("pe_particles: Mod pe_storm not found")
if not pGLOOPTEST	then minetest.log("pe_particles: Mod glooptest not found")
if not pCAVEREALMS	then minetest.log("pe_particles: Mod caverealms not found")



local spawners = {}

local round = function(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

local pr = function(txt,player)
	if not debug then return end
	if player ~= nil then
		local name = player:get_player_name()
		minetest.chat_send_player(name, txt)
	else
		minetest.chat_send_all(txt)
	end
end

--[[pe_particles.partspawn = function(
	amount,
	time,
	minpos,
	maxpos,
	minvel,
	maxvel,
	minacc,
	maxacc,
	minexptime,
	maxexptime,
	minsize,
	maxsize,
	collisiondetection,
	texture,
	playername)
print(minpos.x.." - "..maxpos.x)
	local spawner = minetest.add_particlespawner({
		amount=amount,
		time=time,
		minpos=minpos,
		maxpos=maxpos,
		minvel=minvel,
		maxvel=maxvel,
		minexptime=minexptime,
		maxexptime=maxexptime,
		minsize=minsize,
		maxsize=maxsize,
		collisiondetection=collisiondetection,
		texture=texture,
		playername=playername
	})
	table.insert(spawners, spawner)
end
--]]
pe_particles.partspawn = function(params)
	local spawner = minetest.add_particlespawner(params)
	if debug then print("Add spawner #"..spawner) end
--	if debug then print(dump(params)) end
	table.insert(spawners,spawner)
end

pe_particles.torches = function(player)
	local nodes = pe_particles.searchForNodes(player, "default:torch")
--	pr(dump(player:get_look_dir()),player)
--	pr(table.getn(nodes),player)
--	pr(dump(nodes),player)
--	print(dump(nodes))
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		if i >= SOURCES+1 then break end
		pe_particles.partspawn({
			amount = 2,
			time = 2,
			minpos = {x=np.x,y=np.y+.4,z=np.z},
			maxpos = {x=np.x,y=np.y+.4,z=np.z},
			minvel = {x=-.5,y=1,z=-.5},
			maxvel = {x=.5,y=1,z=.5},
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = 1,
			maxexptime = 1,
			minsize = 1,
			maxsize = 2,
			collisiondetection = true,
			texture = "torch_1.png",
			playername = player:get_player_name()
		})	
		pe_particles.partspawn({
			amount = 1,
			time = 2,
			minpos = {x=np.x,y=np.y+.4,z=np.z},
			maxpos = {x=np.x,y=np.y+.4,z=np.z},
			minvel = {x=-.5,y=1,z=-.5},
			maxvel = {x=.5,y=1,z=.5},
			minacc = vector.new(),
			minacc = vector.new(),
			minexptime = 1,
			maxexptime = 1,
			minsize = 1,
			maxsize = 2,
			collisiondetection = true,
			texture = "torch_2.png",
			playername = player:get_player_name()
		})	
	end
end
pe_particles.g_torches = function(player)
	local nodes = pe_particles.searchForNodes(player, "glooptest:kalite_torch")
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		if i >= SOURCES+1 then break end
		pe_particles.partspawn({
			amount = 5,
			time = 2,
			minpos = {x=np.x,y=np.y+.5,z=np.z},
			maxpos = {x=np.x,y=np.y+.5,z=np.z},
			minvel = {x=-.5,y=2,z=-.5},
			maxvel = {x=.5,y=3,z=.5},
			minacc = vector.new(),
			maxacc = vector.new(),
			minexptime = .5,
			maxexptime = .5,
			minsize = 1,
			maxsize = 1,
			collisiondetection = true,
			texture = "ktorch_1.png",
			playername = player:get_player_name()
		})
	end
end

pe_particles.fire = function(player)
	local nodes = pe_particles.searchForNodes(player, "fire:basic_flame")
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		if i >= SOURCES+1 then break end
		pe_particles.partspawn({
			amount = 10,
			time = 2,
			minpos = {x=np.x-.4,y=np.y+.4,z=np.z-.4},
			maxpos = {x=np.x+.4,y=np.y+.4,z=np.z+.4},
			minvel = {x=-.5,y=2,z=-.5},
			maxvel = {x=.5,y=3,z=.5},
			minacc = vector.new(),
			minacc = vector.new(),
			minexptime = .5,
			maxexptime = 1,
			minsize = 2,
			maxsize = 4,
			collisiondetection = true,
			texture = "torch_1.png",
			playername = player:get_player_name()
		})	
	end
end

pe_particles.cr_fire = function(player)
	local nodes = pe_particles.searchForNodes(player, "caverealms:constant_flame")
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		if i >= SOURCES+1 then break end
		pe_particles.partspawn({
			amount = 10,
			time = 2,
			minpos = {x=np.x-.4,y=np.y+.4,z=np.z-.4},
			maxpos = {x=np.x+.4,y=np.y+.4,z=np.z+.4},
			minvel = {x=-.5,y=2,z=-.5},
			maxvel = {x=.5,y=3,z=.5},
			minacc = vector.new(),
			minacc = vector.new(),
			minexptime = .5,
			maxexptime = 1,
			minsize = 2,
			maxsize = 4,
			collisiondetection = true,
			texture = "ktorch_1.png",
			playername = player:get_player_name()
		})	
	end
end

pe_particles.water = function(player)
	local nodes = pe_particles.searchForNodes(player, "default:water_source")
	local source = 0
	for i, arr in ipairs(nodes) do
		local random = math.random()
		if random < .01 then
			source = source + 1
			minetest.add_particle({
				pos = {x=arr.x-1+random, y=arr.y-1+random, z=arr.z-1+random},
				velocity = vector.new(),
				acceleration = vector.new(),
				expirationtime = 20,
				size = .5,
				collisiondetection = false,
				vertical = false,
				texture = "waterpixel_1.png",
				playername = player:get_player_name()
			})
		elseif random > .99 then
			minetest.add_particle({
				pos = {x=arr.x-1+random, y=arr.y-1+random, z=arr.z-1+random},
				velocity = vector.new(),
				acceleration = vector.new(),
				expirationtime = 10,
				size = .7,
				collisiondetection = false,
				vertical = false,
				texture = "waterpixel_2.png",
				playername = player:get_player_name()
			})
		end
		if source > SOURCES then break end
	end
end

pe_particles.waterdrops = function(player)
	local nodes = pe_particles.searchForNodes(player, {"default:water_source","default:water_flowing","default:river_water_source","default:river_water_flowing"})
	local source = 0
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		local beneath = minetest.get_node({x=arr.x,y=arr.y-2,z=arr.z})
		if beneath == nil then break end
		if beneath.name == "air" then --wtf.. lua has no loop/continue?!... shi..
			source = source + 1
			if source > SOURCES then break end
			pe_particles.partspawn({
				amount = 2,
				time = 2,
				minpos = {x=np.x-.4,y=np.y-1.5,z=np.z-.4},
				maxpos = {x=np.x+.4,y=np.y-1.5,z=np.z+.4},
				minvel = {x=0,y=-1,z=0},
				maxvel = {x=0,y=-3,z=0},
				minacc = {x=0,y=-15,z=0},
				minacc = {x=0,y=-20,z=0},
				minexptime = .2,
				maxexptime = .5,
				minsize = 1,
				maxsize = 2,
				collisiondetection = true,
				texture = "waterdrop_1.png",
				playername = player:get_player_name()
			})	
			pe_particles.partspawn({
				amount = 3,
				time = 2,
				minpos = {x=np.x-.4,y=np.y-1.5,z=np.z-.4},
				maxpos = {x=np.x+.4,y=np.y-1.5,z=np.z+.4},
				minvel = {x=0,y=-1,z=0},
				maxvel = {x=0,y=-3,z=0},
				minacc = {x=0,y=-15,z=0},
				minacc = {x=0,y=-20,z=0},
				minexptime = .2,
				maxexptime = .5,
				minsize = 1,
				maxsize = 2,
				collisiondetection = true,
				texture = "waterdrop_2.png",
				playername = player:get_player_name()
			})	
			
		end
	end
end
pe_particles.lavadrops = function(player)
	local nodes = pe_particles.searchForNodes(player, {"default:lava_source","default:lava_flowing"})
	local source = 0
	for i, arr in ipairs(nodes) do
		local np = {x=arr.x,y=arr.y,z=arr.z}
		local beneath = minetest.get_node({x=arr.x,y=arr.y-2,z=arr.z})
		if beneath == nil then break end
		if beneath.name == "air" then 
			source = source + 1
			if source > SOURCES then break end
			pe_particles.partspawn({
				amount = 4,
				time = 2,
				minpos = {x=np.x-.4,y=np.y-1.5,z=np.z-.4},
				maxpos = {x=np.x+.4,y=np.y-1.5,z=np.z+.4},
				minvel = {x=0,y=-.5,z=0},
				maxvel = {x=0,y=-1,z=0},
				minacc = {x=0,y=-1,z=0},
				minacc = {x=0,y=-2,z=0},
				minexptime = 1,
				maxexptime = 1,
				minsize = 1,
				maxsize = 2,
				collisiondetection = true,
				texture = "lavadrop_1.png",
				playername = player:get_player_name()
			})	
			pe_particles.partspawn({
				amount = 2,
				time = 2,
				minpos = {x=np.x-.4,y=np.y-1.5,z=np.z-.4},
				maxpos = {x=np.x+.4,y=np.y-1.5,z=np.z+.4},
				minvel = {x=0,y=-2,z=0},
				maxvel = {x=0,y=-3,z=0},
				minacc = {x=0,y=-15,z=0},
				minacc = {x=0,y=-20,z=0},
				minexptime = .2,
				maxexptime = .5,
				minsize = 1,
				maxsize = 2,
				collisiondetection = true,
				texture = "lavadrop_2.png",
				playername = player:get_player_name()
			})	
			
		end
	end
end

pe_particles.claustrum = function(player)
	local plpos = player:getpos()
	if plpos.y > -100 then return end
	local nodes = pe_particles.searchForNodes(player, "air")
--	print("nodes: "..dump(nodes))
	local source = 0
    for i, arr in ipairs(nodes) do
		local xp = minetest.get_node({x=arr.x+1,y=arr.y,z=arr.z})
		local xm = minetest.get_node({x=arr.x-1,y=arr.y,z=arr.z})
		local zp = minetest.get_node({x=arr.x,y=arr.y,z=arr.z+1})
		local zm = minetest.get_node({x=arr.x,y=arr.y,z=arr.z-1})
		if (xp.name ~= "air" and xm.name ~= "air" and zp.name == "air" and zm.name == "air")
		 or (zp.name ~= "air" and zm.name ~= "air" and xp.name == "air" and xm.name == "air") then
			local random = math.random()
			if random < .7 and plpos.y < -100 then
				local r1 = math.random(1,9)/10
				local r2 = math.random(1,9)/10
				local r3 = math.random(1,9)/10
				source = source + 1
				minetest.add_particle({
					pos = {x=arr.x-.5+r1, y=arr.y-.5+r2, z=arr.z-.5+r3},
					velocity = vector.new(),
					acceleration = vector.new(),
					expirationtime = 20,
					size = .3,
					collisiondetection = false,
					vertical = false,
					texture = "claustpixel_1.png",
					playername = player:get_player_name()
				})
			elseif random > .3 and plpos.y < -500 then
				local r1 = math.random(1,9)/10
				local r2 = math.random(1,9)/10
				local r3 = math.random(1,9)/10
				source = source + 1
				minetest.add_particle({
					pos = {x=arr.x-.5+r3, y=arr.y+.5-r2, z=arr.z-.5+r1},
					velocity = vector.new(),
					acceleration = vector.new(),
					expirationtime = 20,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "claustpixel_2.png",
					playername = player:get_player_name()
				})
			elseif random < .8 and plpos.y < - 1000 then
				local r1 = math.random(1,9)/10
				local r2 = math.random(1,9)/10
				local r3 = math.random(1,9)/10
				source = source + 1
				minetest.add_particle({
					pos = {x=arr.x+.5-r1, y=arr.y-.5+r2, z=arr.z+.5-r3},
					velocity = vector.new(),
					acceleration = vector.new(),
					expirationtime = 20,
					size = .5,
					collisiondetection = false,
					vertical = false,
					texture = "claustpixel_1.png",
					playername = player:get_player_name()
				})
			end
			if source > SOURCES then break end
		end
	end
end

pe_particles.lavaboil = function(player)
	local nodes = pe_particles.searchForNodes(player, "default:lava_source")
	local source = 0
	for i, arr in ipairs(nodes) do
		local above = minetest.get_node({x=arr.x,y=arr.y+1,z=arr.z})
		if above == nil then break end
		if above.name == "air" then
			local random = math.random()
			if random < .007 then
				source = source + 1
				pe_particles.partspawn({
					amount = 1,
					time = 2,
					minpos = {x=arr.x,y=arr.y+1,z=arr.z},
					maxpos = {x=arr.x,y=arr.y+1,z=arr.z},
					minvel = {x=-.5,y=1,z=-.5},
					maxvel = {x=.5,y=1,z=.5},
					minacc = vector.new(),
					minacc = vector.new(),
					minexptime = 3,
					maxexptime = 4,
					minsize = 2,
					maxsize = 4,
					collisiondetection = true,
					texture = "torch_2.png",
					playername = player:get_player_name()
				})	
			elseif random > .99 then
				source = source + 1
				pe_particles.partspawn({
					amount = 20,
					time = 1,
					minpos = {x=arr.x-.4,y=arr.y+1,z=arr.z-.4},
					maxpos = {x=arr.x+.4,y=arr.y+1,z=arr.z+.4},
					minvel = {x=-1,y=1,z=-1},
					maxvel = {x=1,y=2,z=1},
					minacc = {x=0,y=-15,z=0},
					minacc = {x=0,y=-20,z=0},
					minexptime = .5,
					maxexptime = 1,
					minsize = 1,
					maxsize = 2,
					collisiondetection = false,
					texture = "lavadrop_1.png",
					playername = player:get_player_name()
				})	
				pe_particles.partspawn({
					amount = 1,
					time = 2,
					minpos = {x=arr.x,y=arr.y+1,z=arr.z},
					maxpos = {x=arr.x,y=arr.y+1,z=arr.z},
					minvel = {x=-.5,y=1,z=-.5},
					maxvel = {x=.5,y=1,z=.5},
					minacc = vector.new(),
					minacc = vector.new(),
					minexptime = 3,
					maxexptime = 4,
					minsize = 2,
					maxsize = 4,
					collisiondetection = true,
					texture = "torch_1.png",
					playername = player:get_player_name()
				})	
			end	
			if source > SOURCES then break end
		end
	end
end

pe_particles.veil = function(player)
	local nodes = pe_particles.searchForNodes(player, "default:river_water_source")
	local source = 0
	for i, arr in ipairs(nodes) do
		local above = minetest.get_node({x=arr.x,y=arr.y+1,z=arr.z})
		if above == nil then break end
		if above.name == "air" then
			local random = math.random()
			local time = minetest.get_timeofday()*24000
			if random < .1 and time > 6000 and time < 6700 then
				local r1 = math.random(1,9)/10
				local r2 = math.random(1,9)/10
				source = source + 1
				minetest.add_particle({
					pos = {x=arr.x-.5+r1, y=arr.y+.9, z=arr.z-.5+r2},
					velocity = vector.new(),
					acceleration = vector.new(),
					expirationtime = 20,
					size = 7,
					collisiondetection = false,
					vertical = false,
					texture = "riverveil_1.png",
					playername = player:get_player_name()
				})
			elseif random > .9 and time > 5000 and time < 6500 then
			local r1 = math.random(1,9)/10
				local r2 = math.random(1,9)/10
				source = source + 1
				minetest.add_particle({
					pos = {x=arr.x-.5+r1, y=arr.y+.7, z=arr.z-.5+r2},
					velocity = vector.new(),
					acceleration = vector.new(),
					expirationtime = 20,
					size = 5,
					collisiondetection = false,
					vertical = false,
					texture = "riverveil_2.png",
					playername = player:get_player_name()
				})
			end
			if source > SOURCES then break end
		end
	end
	local nodes = pe_particles.searchForNodes(player, "default:snow")
	for i, arr in ipairs(nodes) do
		local random = math.random()
		local time = minetest.get_timeofday()*24000
		if random < .3 and time > 6000 and time < 18000 then
			local r1 = math.random(1,9)/10
			local r2 = math.random(1,9)/10
			local vx = math.random(-10,10)/200
			local vz = math.random(-10,10)/200
			minetest.add_particle({
				pos = {x=arr.x-.5+r1, y=arr.y-.2, z=arr.z-.5+r2},
				velocity = {x=vx,y=0,z=vz},
				acceleration = vector.new(),
				expirationtime = 5,
				size = 1,
				collisiondetection = false,
				vertical = false,
				texture = "snowpixel_1.png",
				playername = player:get_player_name()
			})
		elseif random > .7 and time > 6000 and time < 18000 then
			local r1 = math.random(1,9)/10
			local r2 = math.random(1,9)/10
			local vx = math.random(-10,10)/200
			local vz = math.random(-10,10)/200
			minetest.add_particle({
				pos = {x=arr.x-.5+r1, y=arr.y-.2, z=arr.z-.5+r2},
				velocity = {x=vx,y=0,z=vz},
				acceleration = vector.new(),
				expirationtime = 7,
				size = 1,
				collisiondetection = false,
				vertical = false,
				texture = "snowpixel_2.png",
				playername = player:get_player_name()
			})
		end
	end
end

pe_particles.cr_veil = function(player)
	local nodes = pe_particles.searchForNodes(player, "caverealms:hot_cobble")
	for i, arr in ipairs(nodes) do
		local above = minetest.get_node({x=arr.x,y=arr.y+1,z=arr.z})
		if above == nil then break end
		if above.name == "air" then
			local random = math.random()
			local time = minetest.get_timeofday()*24000
			if random < .7 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=0,y=ry,z=0},
					acceleration = vector.new(),
					expirationtime = 3,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "redpixel_1.png",
					playername = player:get_player_name()
				})
			elseif random > .3 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=0,y=ry,z=0},
					acceleration = vector.new(),
					expirationtime = 7,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "redpixel_2.png",
					playername = player:get_player_name()
				})
			end
		end
	end
	local nodes = pe_particles.searchForNodes(player, {"caverealms:coal_dust","caverealms:glow_obsidian_2"})
	for i, arr in ipairs(nodes) do
		local above = minetest.get_node({x=arr.x,y=arr.y+1,z=arr.z})
		if above == nil then break end
		if above.name == "air" then
			local random = math.random()
			local time = minetest.get_timeofday()*24000
			if random < .7 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				local vx = math.random(-10,10)/100
				local vz = math.random(-10,10)/100
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=vx,y=ry/2,z=vz},
					acceleration = vector.new(),
					expirationtime = 2,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "darkpixel_1.png",
					playername = player:get_player_name()
				})
			elseif random > .3 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				local vx = math.random(-10,10)/100
				local vz = math.random(-10,10)/100
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=vx,y=ry/2,z=vz},
					acceleration = vector.new(),
					expirationtime = 3,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "redpixel_2.png",
					playername = player:get_player_name()
				})
			end
		end
	end
	local nodes = pe_particles.searchForNodes(player, "caverealms:glow_obsidian")
	for i, arr in ipairs(nodes) do
		local above = minetest.get_node({x=arr.x,y=arr.y+1,z=arr.z})
		if above == nil then break end
		if above.name == "air" then
			local random = math.random()
			local time = minetest.get_timeofday()*24000
			if random < .7 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				local vx = math.random(-10,10)/100
				local vz = math.random(-10,10)/100
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=vx,y=ry,z=vz},
					acceleration = vector.new(),
					expirationtime = 2,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "darkpixel_1.png",
					playername = player:get_player_name()
				})
			elseif random > .3 then
				local rx = math.random(1,9)/10
				local ry = math.random(1,2)/10
				local rz = math.random(1,9)/10
				local vx = math.random(-10,10)/100
				local vz = math.random(-10,10)/100
				minetest.add_particle({
					pos = {x=arr.x-.5+rx, y=arr.y+.55+ry, z=arr.z-.5+rz},
					velocity = {x=vx,y=ry,z=vz},
					acceleration = vector.new(),
					expirationtime = 3,
					size = .2,
					collisiondetection = false,
					vertical = false,
					texture = "waterpixel_2.png",
					playername = player:get_player_name()
				})
			end
		end
	end
end

pe_particles.searchForNodes = function(player,nodes)
	local pos = player:getpos()

	--Определяем, куда направлен взор игрока,
	--нам ведь не нужно рисовать частицы там, где их не видно(за спиной)
	local dir = player:get_look_dir()
--	local x = round(dir.x)
--	local z = round(dir.z)
	local x = dir.x
	local z = dir.z
--	pr(player, "x: "..x)
--	pr(player, "z: "..z)
	local minp = {y=pos.y-RADIUS}
	local maxp = {y=pos.y+RADIUS}
	if x > 0 then 
		minp["x"] = pos.x - 3
		maxp["x"] = pos.x + RADIUS
	elseif x < 0 then
		minp["x"] = pos.x - RADIUS
		maxp["x"] = pos.x + 3
	else
		minp["x"] = pos.x - 3
		maxp["x"] = pos.x + 3
	end
	if z > 0 then 
		minp["z"] = pos.z - 3
		maxp["z"] = pos.z + RADIUS
	elseif z < 0 then
		minp["z"] = pos.z - RADIUS
		maxp["z"] = pos.z + 3
	else
		minp["z"] = pos.z - 3
		maxp["z"] = pos.z + 3
	end

--	print(dump(minp))
--	print(dump(maxp))
--	pr(player, dump(dir))
	
	return minetest.env:find_nodes_in_area(minp,maxp,nodes)

end




timer = 0
particles = {}
minetest.register_globalstep(function(dtime)

	timer = timer + dtime;

	if timer < 2 then return
	else timer = 0 end

--	cleaning old spawners, cause minetest do not clean it
--	even where spawners out of time, hi is use memory and
--	minetest engine does not clear them, and this leads to 
--	overflow and server freeze (not crash, but 100% CPU consumes and totally freeze)
	local nspawners = table.getn(spawners)
	if nspawners > SPAWNERS then
		if debug then print("spawners: "..nspawners.."/"..SPAWNERS) end
		for i=1, (nspawners-SPAWNERS) do
			if debug then print("remove spawner #"..spawners[1]) end
			minetest.delete_particlespawner(spawners[1])
			table.remove(spawners, 1)
		end
	end

	if debug then print(dump(spawners)) end

    for _, player in ipairs(minetest.get_connected_players()) do
		
		if pTORCHES					then pe_particles.torches(player) end
		if pWDROPS					then pe_particles.waterdrops(player) end
		if pLDROPS					then pe_particles.lavadrops(player) end
		if pLAVABOIL				then pe_particles.lavaboil(player) end
		if pFIRE					then pe_particles.fire(player) end
		if pWATER					then pe_particles.water(player) end
		if pCLAUSTRUM				then pe_particles.claustrum(player) end
		if pVEIL					then pe_particles.veil(player) end
		--mods
		if pGLOOPTEST and pTORCHES	then pe_particles.g_torches(player) end
		if pCAVEREALMS and pFIRE	then pe_particles.cr_fire(player) end
		if pCAVEREALMS and pVEIL	then pe_particles.cr_veil(player) end

	end
end)

