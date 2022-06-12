

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)

local Player = Players.LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui")


local App = Roact.createElement("ScreenGui", {
    IgnoreGuiInset = true
}, {
    Roact.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(243, 77, 44)

    }, {
        Roact.createElement(require(script.Header)),
        Roact.createElement(require(script.Board)),

        Roact.createElement("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0.0125, 2)
        })
    })
})

Roact.mount(App, PlayerGui)