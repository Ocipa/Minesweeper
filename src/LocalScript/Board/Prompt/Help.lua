local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")
local UserInputService = game:GetService("UserInputService")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

return function ()
    local Mouse = UserInputService.MouseEnabled

    local RevealHelp = if Mouse then
        "ℹ️ Click on tiles to reveal nearby mines."
        else "ℹ️ Tap on tiles to reveal nearby mines."

    local FlagHelp = if Mouse then
        "ℹ️ Right click on tiles to flag them as mines."
        else "ℹ️ Long tap on tiles to flag them as mines."

    local GoalHelp = "🏁 Goal: To reveal all numbers and flag all mines."


    return {
        Roact.createElement("UIListLayout", {
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0.05, 3)
        }),

        Roact.createElement("TextLabel", {
            Size = UDim2.fromScale(0.9, 0.08),
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(30, 30, 30),
            Text = RevealHelp,
            ZIndex = 2
        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        }),

        Roact.createElement("TextLabel", {
            Size = UDim2.fromScale(0.9, 0.08),
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(30, 30, 30),
            Text = FlagHelp,
            ZIndex = 2
        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        }),

        Roact.createElement("TextLabel", {
            Size = UDim2.fromScale(0.9, 0.08),
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.fromRGB(30, 30, 30),
            Text = GoalHelp,
            ZIndex = 2
        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        }),

        Roact.createElement("TextButton", {
            Size = UDim2.fromScale(0.35, 0.075),
            TextScaled = true,
            Text = "Continue Playing",
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(160, 160, 160),
            ZIndex = 2,

            [Roact.Event.Activated] = function()
                Accord.Prompt:None()
            end

        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 6)
            }),

            Roact.createElement("UIStroke", {
                Thickness = 1,
                Transparency = 0.6,
                Color = Color3.fromRGB(70, 70, 70)
            })
        }),
    }
end