local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local target = plr.Character or plr.CharacterAdded:Wait()
target = target:WaitForChild("Head")

local GunSoundRemote = game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gu1nSound1s")
local OutfitRemote = game:GetService("ReplicatedStorage").Remotes.LoadOutfit

local SLOT_2 = getgenv().Sonic_Slot or 4
local SLOT_1 = getgenv().SuperSonic_Slot or 5
local currentSlot = SLOT_1

local TARGET_ID = "8404814227"

local function extractId(raw)
    return raw and string.match(raw, "%d+")
end

local function sendSlot(v)
    OutfitRemote:InvokeServer(v)
end

sendSlot(SLOT_2)

local function trackSound(sound)
    if sound:IsA("Sound") then
        sound.Played:Connect(function()
            local id = extractId(sound.SoundId)
            if not id then return end

            GunSoundRemote:FireServer(workspace, id, 1)

            if id == TARGET_ID then
                sendSlot(currentSlot)
                if currentSlot == SLOT_1 then
                    currentSlot = SLOT_2
                else
                    currentSlot = SLOT_1
                end
            end
        end)
    end
end

for _, obj in ipairs(target:GetChildren()) do
    trackSound(obj)
end

target.ChildAdded:Connect(function(child)
    task.wait()
    trackSound(child)
end)

loadstring(game:HttpGet("https://github.com/AdmBrookhavenScripts/Sonic1/raw/refs/heads/main/Protected%20SonicXSuper.txt"))()
