
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)

local PrompEvent = script.Parent.Parent:WaitForChild("PromptEvent")
local SettingsChangeEvent = script.Parent.Parent:WaitForChild("SettingsChangeEvent")

local Header = Roact.Component:extend("Header")

function Header:init(Props)
    self:setState({
        Size = 10
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
                Current = 10,
                Min = 3,
                Max = 99
            }),
    
            Roact.createElement(require(script.SettingsLabel), {
                Name = "Mines",
                Current = 12,
                Min = 1,
                Max = math.huge
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
                PrompEvent:Fire("Retry")
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
                PrompEvent:Fire("Help")
            end
        })
    })
end

function Header:didMount()
    self.SettingsChangeEvent = SettingsChangeEvent.Event:Connect(function(SettingsName: string, SettingsValue: any)
        if SettingsName == "Size" then
            self:setState({
                Size = SettingsValue
            })
        end
    end)
end

function Header:willUnmount()
    if self.SettingsChangeEvent and typeof(self.SettingsChangeEvent) == "RBXScriptConnection" then
        self.SettingsChangeEvent:Disconnect()
    end
    self.SettingsChangeEvent = nil
end


return Header