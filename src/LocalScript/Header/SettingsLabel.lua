
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

local Setting = Roact.Component:extend("Setting")

function Setting:init(Props)
    self:setState(Props)

    self.TextBoxRef = Roact.createRef()
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

            [Roact.Ref] = self.TextBoxRef,
    
            [Roact.Change.Text] = function(TextBox: TextBox)
                local number = tonumber(TextBox.Text)

                Accord[self.state.Name]:Set(number or 0)
            end,
    
            [Roact.Event.FocusLost] = function(TextBox: TextBox)
                TextBox.Text = Accord[self.state.Name]:GetValue()
            end,

            [Roact.Event.Focused] = function(TextBox: TextBox)
                local Prompt = Accord.Prompt:GetValue()
                if Prompt == "Win" or Prompt == "Loss" then
                    TextBox:ReleaseFocus()
                end
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
    self.SettingChangedEvent = Accord[self.state.Name]:Connect(function(value, lastValue)
        local TextBox = self.TextBoxRef:getValue()

        if not TextBox:IsFocused() then
            TextBox.Text = value
            self:setState({
                Current = value
            })
        end
    end)
end

function Setting:willUnmount()
    if typeof(self.SettingChangedEvent) == "table" and self.SettingChangedEvent["Connected"] then
        self.SettingChangedEvent:Disconnect()
    end
    self.SettingChangedEvent = nil
end


return Setting