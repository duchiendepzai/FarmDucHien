-- Grow a Garden | Auto Farm Script - FarmDucHien Edition
-- UI: Rayfield | Icon: MineHex Network | Tác giả: Duchiendeptrai

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "🌱 FarmDucHien | Grow a Garden",
   LoadingTitle = "Đang khởi động script...",
   LoadingSubtitle = "Farm & bán trái hoàn toàn tự động",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GrowFarmUI",
      FileName = "FarmDucHien"
   },
   IntroText = "FarmDucHien Script v2",
   IntroIcon = "https://raw.githubusercontent.com/duchiendeptrai/FarmDucHien/main/minehex-icon.jpeg" -- Đảm bảo bạn đã upload ảnh này lên GitHub và link đúng
})

-- Biến chức năng
local autoPick, autoSell, autoBuy = false, false, false
local delayFarm = 0.5

-- Remote
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local pickRemote = RS:FindFirstChild("PickFruit")
local sellRemote = RS:FindFirstChild("SellFruit")
local buyRemote = RS:FindFirstChild("BuySeed")

-- Kiểm tra trái thường
local function isNormalFruit(fruit)
    return fruit:IsA("Model") and not fruit:FindFirstChild("Effect")
end

-- Tự động farm
task.spawn(function()
    while task.wait(delayFarm) do
        if autoPick then
            for _, fruit in ipairs(WS:GetDescendants()) do
                if isNormalFruit(fruit) then
                    pcall(function()
                        pickRemote:FireServer(fruit)
                    end)
                end
            end
        end
        if autoSell then
            pcall(function()
                sellRemote:FireServer()
            end)
        end
        if autoBuy then
            pcall(function()
                buyRemote:FireServer("Rare")
            end)
        end
    end
end)

-- Giao diện chính - Farm
local FarmTab = Window:CreateTab("🌾 Farm", "https://raw.githubusercontent.com/duchiendeptrai/FarmDucHien/main/minehex-icon.jpeg")

FarmTab:CreateToggle({
   Name = "🌿 Tự động thu trái (không hiệu ứng)",
   CurrentValue = false,
   Callback = function(v) autoPick = v end
})

FarmTab:CreateToggle({
   Name = "💰 Tự động bán trái",
   CurrentValue = false,
   Callback = function(v) autoSell = v end
})

FarmTab:CreateToggle({
   Name = "🛒 Tự động mua trái Rare",
   CurrentValue = false,
   Callback = function(v) autoBuy = v end
})

FarmTab:CreateSlider({
   Name = "⚙️ Điều chỉnh tốc độ farm (giây)",
   Range = {0.1, 1.5},
   Increment = 0.1,
   Suffix = "s",
   CurrentValue = 0.4,
   Callback = function(v) delayFarm = v end
})
