
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

local Header = Roact.Component:extend("Header")

function Header:init(Props)
    self:setState({
        Size = Accord.Size:GetValue()
    })
end

function Header:render()
    return Roact.createElement("Frame", {
        Size = UDim2.fromScale(0.85, 0.065),
        BackgroundColor3 = Color3.new(1, 1, 1),
    }, {
        Roact.createElement("UISizeConstraint", {
            MaxSize = Vector2.new(math.max(512, self.state.Size * 40), math.max(512, self.state.Size * 40) / 4)
        }),

        Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 10
        }),

        Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),

        Roact.createElement("UIPadding", {
            PaddingLeft = UDim.new(0.01, 4),
            PaddingRight = UDim.new(0.01, 4)
        }),

        Roact.createElement("Frame", {
            Size = UDim2.new(9, -24, 1, 0),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            BackgroundTransparency = 1

        }, {
            Roact.createElement("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0.01, 4),
                FillDirection = Enum.FillDirection.Horizontal
            }),
    
            Roact.createElement(require(script.SettingsLabel), {
                Name = "Size",
                Current = Accord.Size:GetValue()
            }),
    
            Roact.createElement(require(script.SettingsLabel), {
                Name = "Mines",
                Current = Accord.Mines:GetValue()
            })
        }),

        Roact.createElement("TextButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            Position = UDim2.fromScale(1, 0.53),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Text = "🔄",
            TextScaled = true,

            [Roact.Event.Activated] = function()
                Accord.Prompt:Retry()
            end
        }),

        Roact.createElement("TextButton", {
            Size = UDim2.fromScale(0.8, 0.8),
            Position = UDim2.fromScale(0.9, 0.53),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Text = "ℹ️",
            TextScaled = true,

            [Roact.Event.Activated] = function()
                Accord.Prompt:Help()
            end
        })
    })
end

function Header:didMount()
    self.SizeChangeEvent = Accord.Size:Connect(function(value, lastValue)
        self:setState({
            Size = value
        })
    end)
end

function Header:willUnmount()
    if typeof(self.SizeChangeEvent) == "table" and self.SizeChangeEvent["Connected"] then
        self.SizeChangeEvent:Disconnect()
    end
    self.SizeChangeEvent = nil
end


return Header