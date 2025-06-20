-- Grow a Garden | Auto Farm Script chính thức by duchiendepzai
-- Yêu cầu: chạy trên PC với executor hỗ trợ Rayfield (KRNL, Synapse, Fluxus…)

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "🌱 𝗙𝗮𝗿𝗺𝗗𝘂𝗰𝗛𝗶𝗲𝗻 | Grow a Garden",
   LoadingTitle = "Đang tải giao diện...",
   LoadingSubtitle = "Farm tự động bằng Rayfield UI",
   ConfigurationSaving = { Enabled = true, FolderName = "GrowGardenFarm", FileName = "FarmDucHien" },
   IntroText = "FarmDucHien Script v2",
   IntroIcon = "https://raw.githubusercontent.com/duchiendepzai/FarmDucHien/main/minehex-icon.jpeg"
})

-- Các biến điều khiển chức năng
local autoPick, autoSell, autoBuy = false, false, false
local delayFarm = 0.4

-- Game Services & Remotes
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local pickRemote = RS:FindFirstChild("PickFruit")
local sellRemote = RS:FindFirstChild("SellFruit")
local buyRemote = RS:FindFirstChild("BuySeed")

-- Hàm kiểm tra trái "thường" (không có child 'Effect')
local function isNormalFruit(fruit)
    return fruit:IsA("Model") and not fruit:FindFirstChild("Effect")
end

-- Luồng chính tự động farm
task.spawn(function()
    while task.wait(delayFarm) do
        if autoPick then
            for _, fruit in ipairs(WS:GetDescendants()) do
                if isNormalFruit(fruit) then
                    pcall(function() pickRemote:FireServer(fruit) end)
                end
            end
        end
        if autoSell then
            pcall(function() sellRemote:FireServer() end)
        end
        if autoBuy then
            pcall(function() buyRemote:FireServer("Rare") end)
        end
    end
end)

-- Giao diện tab duy nhất "Farm"
local FarmTab = Window:CreateTab("🌾 Farm", 4483362458)

FarmTab:CreateToggle({
    Name = "🌿 Auto thu trái (ko hiệu ứng)",
    CurrentValue = false,
    Callback = function(v) autoPick = v end
})

FarmTab:CreateToggle({
    Name = "💰 Auto bán trái",
    CurrentValue = false,
    Callback = function(v) autoSell = v end
})

FarmTab:CreateToggle({
    Name = "🛒 Auto mua trái Rare",
    CurrentValue = false,
    Callback = function(v) autoBuy = v end
})

FarmTab:CreateSlider({
    Name = "⚙️ Tốc độ farm (giây)",
    Range = {0.1, 1.5},
    Increment = 0.1,
    Suffix = " s",
    CurrentValue = delayFarm,
    Callback = function(v) delayFarm = v end
})
