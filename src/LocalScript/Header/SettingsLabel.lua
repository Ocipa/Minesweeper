
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)

local SettingsChangeEvent = script.Parent.Parent.Parent:WaitForChild("SettingsChangeEvent")

local Setting = Roact.Component:extend("Setting")

function Setting:init(Props)
    self:setState(Props)
end

function Setting:render()
    return Roact.createElement("Frame", {
        Size = UDim2.fromScale(2.8, 0.7),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        BackgroundTransparency = 1

    }, {
        Roact.createElement("TextLabel", {
            Size = UDim2.fromScale(2.5, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Text = ("%s: "):format(self.state.Name or ""),
            TextScaled = true,
            TextColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSansBold
        }),
    
        Roact.createElement("TextBox", {
            Size = UDim2.fromScale(1.4, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Text = self.state.Current,
            TextScaled = true,
            TextColor3 = Color3.new(0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            ClearTextOnFocus = false,
            Font = Enum.Font.SourceSansBold,
    
            [Roact.Change.Text] = function(TextBox: TextBox)
                local ToNumber = tonumber(TextBox.Text)

                local ClampedNumber = math.clamp(ToNumber or self.state.Min, self.state.Min, self.state.Max)

                if ToNumber == ClampedNumber then
                    SettingsChangeEvent:Fire(self.state.Name, ClampedNumber)
                end
            end,
    
            [Roact.Event.FocusLost] = function(TextBox: TextBox)
                local ToNumber = tonumber(TextBox.Text)

                local ClampedNumber = math.clamp(ToNumber or self.state.Min, self.state.Min, self.state.Max)

                SettingsChangeEvent:Fire(self.state.Name, ClampedNumber)
            end
        }, {
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0.15, 0)
            })
        }),

        Roact.createElement("UIListLayout", {
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 0),
            FillDirection = Enum.FillDirection.Horizontal
        })
    })
end

function Setting:didMount()
    self.SettingsChangeEvent = SettingsChangeEvent.Event:Connect(function(SettingsName: string, SettingsValue: any)
        if self.state.Name == SettingsName and self.state.Current ~= SettingsValue then
            self:setState({
                Current = SettingsValue
            })
        end
    end)
end

function Setting:willUnmount()
    if self.SettingsChangeEvent and typeof(self.SettingsChangeEvent) == "RBXScriptConnection" then
        self.SettingsChangeEvent:Disconnect()
    end
    self.SettingsChangeEvent = nil
end


return Setting