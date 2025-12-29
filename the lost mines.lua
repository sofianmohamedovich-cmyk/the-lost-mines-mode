local SoundService = game:GetService("SoundService")

for _, group in ipairs(SoundService:GetChildren()) do
    if group:IsA("SoundGroup") then
        -- Apply or update Reverb
        local reverb = group:FindFirstChild("CaveReverb")
        if not reverb then
            reverb = Instance.new("ReverbSoundEffect")
            reverb.Name = "CaveReverb"
            reverb.Parent = group
        end
        
        reverb.DecayTime = 2.5     -- Shorter decay for less echo
        reverb.Density = 0.8       -- Slightly less dense reflections
        reverb.Diffusion = 0.8     -- Slightly less spread
        reverb.DryLevel = 0        -- Original sound volume
        reverb.WetLevel = -0.5     -- Slightly quieter reverb
    end
end

 
  

task.spawn(function()
    task.wait()
    if game:GetService("Lighting"):FindFirstChild("Atmosphere") then
        game.Lighting.Atmosphere:Destroy()
    end
    game.Lighting.FogColor = Color3.new(0.133333, 0.149020, 0.239216)
    game.Lighting.FogEnd = 100
    game.Lighting.FogStart = 0
end)


local Workspace = game:GetService("Workspace")

-- Materials & colors
local ROOM_MATERIAL = Enum.Material.Slate
local ROOM_COLOR = Color3.fromRGB(70, 70, 70)

local DOOR_MATERIAL = Enum.Material.Cobblestone
local DOOR_COLOR = Color3.fromRGB(55, 55, 55)

local LOCK_COLOR = Color3.fromRGB(95, 95, 95)

local FORCE_COLOR = true

-- Models / folders we NEVER touch
local BLACKLIST_NAMES = {
	figure = true,
	elgoblino = true,
	el goblino = true,
	bob = true,
	jeff = true,
	eyes = true,
	seek = true,
	rush = true,
	ambush = true,
	entity = true,
	monster = true,
	item = true,
	pickup = true
}

local function isBlacklisted(part)
	local ancestor = part
	while ancestor do
		if ancestor:IsA("Model") or ancestor:IsA("Folder") then
			local name = ancestor.Name:lower()
			for blocked in pairs(BLACKLIST_NAMES) do
				if name:find(blocked) then
					return true
				end
			end
		end
		ancestor = ancestor.Parent
	end
	return false
end

local function isDoorPart(part)
	local model = part:FindFirstAncestorWhichIsA("Model")
	return model and model.Name:lower():find("door")
end

local function isLockPart(part)
	return part.Name:lower():find("lock")
end

local function stoneifyPart(part)
	if not part:IsA("BasePart") then return end
	if part.Material == Enum.Material.Neon then return end
	if isBlacklisted(part) then return end

	pcall(function()
		if isDoorPart(part) then
			part.Material = DOOR_MATERIAL
			if FORCE_COLOR then
				if isLockPart(part) then
					part.Color = LOCK_COLOR
				else
					part.Color = DOOR_COLOR
				end
			end
		else
			part.Material = ROOM_MATERIAL
			if FORCE_COLOR then
				part.Color = ROOM_COLOR
			end
		end

		part.Reflectance = 0.05
		part.CastShadow = true
	end)
end

local function stoneifyRooms()
	local rooms = Workspace:FindFirstChild("CurrentRooms")
	if not rooms then return end

	for _, room in ipairs(rooms:GetChildren()) do
		for _, part in ipairs(room:GetDescendants()) do
			stoneifyPart(part)
		end
	end
end

-- Initial pass
stoneifyRooms()

-- Future rooms
Workspace.CurrentRooms.ChildAdded:Connect(function(room)
	room.DescendantAdded:Connect(function(part)
		stoneifyPart(part)
	end)
	stoneifyRooms()
end)


print("🪨 Stone applied ONLY to rooms & doors | Items & entities untouched")


game.Workspace.CurrentRooms.ChildAdded:connect(convert)

convert(game.Workspace.CurrentRooms:GetChildren()[1])
convert(game.Workspace.CurrentRooms:GetChildren()[2])


game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("the lost mines.",true)
wait(4)require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("thanks to venxius or whatever his name is for the entity spawner",true)
wait(2) require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("thanks to kodbol and local playerr for other stuff and also ty @real on dc for some stuff too (good luck, you won't come back.)",true)









coroutine.wrap(function()
    while true do
     wait(math.random(90,210))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
    Entity = {
        Name = "Silence",
        Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/silence.rbxm?raw=true",
        HeightOffset = 0
    },
    Lights = {
        Flicker = {
            Enabled = true,
            Duration = 10
        },
        Shatter = true,
        Repair = false
    },
    Earthquake = {
        Enabled = false
    },
    CameraShake = {
        Enabled = false,
        Range = 100,
        Values = {1.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
    },
    Movement = {
        Speed = 15,
        Delay = 2,
        Reversed = true
    },
    Rebounding = {
        Enabled = false,
        Type = "Ambush", -- "Blitz"
        Min = 1,
        Max = 1,
        Delay = 2
    },
    Damage = {
        Enabled = true,
        Range = 20,
        Amount = 99
    },
    Crucifixion = {
        Enabled = true,
        Range = 40,
        Resist = false,
        Break = true
    },
    Death = {
        Type = "Guiding", -- "Curious"
        Hints = {"You've died to silence..", "When the lights flicker, Hide!", "She really hates noise...", "You can do it!"},
        Cause = ""
    }
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
    if lineOfSight == true then
        print("Player is looking at entity")
    else
        print("Player view is obstructed by something")
    end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
    else
        print("Entity has finished rebounding")
    end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
    if newHealth == 0 then
        print("Entity has killed the player")
    else
        print("Entity has damaged the player")
    end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()







coroutine.wrap(function()
    while true do
     wait(math.random(30,210))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "Depth",
		Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/DEPTHNEWREMAKE.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 5
		},
		Shatter = true,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {1.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 150,
		Delay = 1,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush", -- "Blitz"
		Min = 3,
		Max = 3,
		Delay = 1
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"You've died to depth..", "When the lights flicker, Hide!", "Use what you've learned from ambush.", "You can do it!"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
	else
        print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()





coroutine.wrap(function()
    while true do
     wait(math.random(50,210))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "Bloody rush",
		Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/bloodbathrush.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 3
		},
		Shatter = true,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {1.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 150,
		Delay = 2,
		Reversed = true
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush", -- "Blitz"
		Min = 5,
		Max = 8,
		Delay = 2
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"You've died to bloody rush..", "When the lights flicker, Hide!", "Use what you've learned from Rush, it will just spawn infront instead.", "You can do it!"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
	else
        print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()



coroutine.wrap(function()
    while true do
     wait(math.random(80,255))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "Smiley",
		Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/smiley.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 20
		},
		Shatter = true,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {1.0, 10, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 100,
		Delay = 2,
		Reversed = false
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush", -- "Blitz"
		Min = 5,
		Max = 8,
		Delay = 2
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"You've died to smiley..", "When the lights flicker, Hide!", "Use what you've learned from Rush, its just slower.", "You can do it!"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
	else
        print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()




coroutine.wrap(function()
    while true do
     wait(math.random(90,1000))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "A-60",
		Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/A60.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 30
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = false,
		Range = 100,
		Values = {1.0, 10, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 300,
		Delay = 2,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush", -- "Blitz"
		Min = 20,
		Max = 30,
		Delay = 3
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"You've died to..", "I.. don't know ..?", "Im.. not sure how to help, I'm terribly sorry..", "Be carful next time."},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
	else
        print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()






coroutine.wrap(function()
    while true do
     wait(math.random(100,255))
          local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "A-200",
		Asset = "https://github.com/sofianmohamedovich-cmyk/tes/blob/main/A200.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = true,
			Duration = 10
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = false,
		Range = 100,
		Values = {1.0, 10, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 30,
		Delay = 5,
		Reversed = true
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush", -- "Blitz"
		Min = 20,
		Max = 30,
		Delay = 3
	},
	Damage = {
		Enabled = true,
		Range = 20,
		Amount = 100
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"You've died to..", "I.. don't know ..?", "Im.. not sure how to help, I'm terribly sorry..", "Be carful next time."},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
    if startOfRebound == true then
        print("Entity has started rebounding")
	else
        print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
    print("Entity is despawning")
end)

entity:SetCallback("OnDespawned", function()
    print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run()
      end
end)()
