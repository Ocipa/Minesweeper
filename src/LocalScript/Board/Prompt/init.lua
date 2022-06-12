local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))

local PromptEvent = script.Parent.Parent.Parent:WaitForChild("PromptEvent")

local Prompt = Roact.Component:extend("Prompt")

function Prompt:init(Props)

end

function Prompt:render()
    return Roact.createElement("ImageButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(31, 31, 31),
        Image = "",
        AutoButtonColor = false,
        ZIndex = 2,

        [Roact.Event.Activated] = function()
            if self.props.PromptName == "Help" or self.props.PromptName == "Retry" then
                PromptEvent:Fire(false)
            end
        end

    }, {
        Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),

        Roact.createFragment(require(script:FindFirstChild(self.props.PromptName))())
    })
end

return Prompt