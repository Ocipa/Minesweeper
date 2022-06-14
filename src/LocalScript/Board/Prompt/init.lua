local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))

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
            Accord.Prompt:None()

            if self.props.PromptName == "Win" or self.props.PromptName == "Loss" then
                Accord.Grid:Generate()
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