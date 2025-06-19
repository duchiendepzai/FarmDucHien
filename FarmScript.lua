local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "🌱 FarmDucHien | Grow a Garden",
   LoadingTitle = "Đang khởi động...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "GrowFarm",
      FileName = "FarmDucHien"
   }
})

local autoPick, autoSell, autoBuy = false, false, false

local RS = game:GetService("ReplicatedStorage")
local pickRemote = RS:FindFirstChild("PickFruit")
local sellRemote = RS:FindFirstChild("SellFruit")
local buyRemote = RS:FindFirstChild("BuySeed")
local WS = game:GetService("Workspace")

local function isNormalFruit(fruit)
    return fruit:IsA("Model") and not fruit:FindFirstChild("Effect")
end

task.spawn(function()
    while task.wait(0.5) do
        if autoPick then
            for _, fruit in ipairs(WS:GetDescendants()) do
                if isNormalFruit(fruit) then
                    pcall(function()
                        pickRemote:FireServer(fruit)
                    end)
                end
            end
        end
        if autoSell then pcall(function() sellRemote:FireServer() end) end
        if autoBuy then pcall(function() buyRemote:FireServer("Rare") end) end
    end
end)

local Tab = Window:CreateTab("🌿 Auto Farm", 4483362458)
Tab:CreateToggle({Name = "🌾 Auto thu trái", CurrentValue = false, Callback = function(v) autoPick = v end})
Tab:CreateToggle({Name = "💰 Auto bán trái", CurrentValue = false, Callback = function(v) autoSell = v end})
Tab:CreateToggle({Name = "🛒 Auto mua trái (Rare)", CurrentValue = false, Callback = function(v) autoBuy = v end})
