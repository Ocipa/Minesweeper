local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

return function ()
    return {
        Roact.createElement("UIListLayout", {
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0.05, 3)
        }),

        Roact.createElement("TextButton", {
            Size = UDim2.fromScale(0.3, 0.075),
            TextScaled = true,
            Text = "Play Again",
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.3,
            BackgroundColor3 = Color3.fromRGB(160, 160, 160),
            ZIndex = 2,

            [Roact.Event.Activated] = function()
                Accord.Prompt:None()
                Accord.Grid:Generate()
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

        Roact.createElement("TextButton", {
            Size = UDim2.fromScale(0.3, 0.075),
            TextScaled = true,
            Text = "Cancel",
            Font = Enum.Font.SourceSansBold,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(220, 30, 30),
            ZIndex = 2,

            [Roact.Event.Activated] = function()
                Accord.Prompt:None()
            end

        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 6)
            })
        })
    }
end