
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)
local Accord = require(ReplicatedStorage.Packages.accord)

local Types = require(script.Parent.Parent:WaitForChild("Types"))

local Board = Roact.Component:extend("Board")

function Board:init(Props)
    Accord.Grid:Generate()

    self:setState({
        Size = Accord.Size:GetValue(),
        Mines = Accord.Mines:GetValue(),
        Grid = Accord.Grid:GetValue(),
        Prompt = Accord.Prompt:GetValue()
    })
end

function Board:render()
    local Padding = math.min(1 / (self.state.Size + 1) / self.state.Size, 0.02)
    local CellSize = (1 / self.state.Size) - (self.state.Size ) * Padding / self.state.Size

    return Roact.createElement("Frame", {
        Size = UDim2.fromScale(0.85, 0.65),
        BackgroundColor3 = Color3.new(0, 0, 0),

    }, {
        Roact.createElement("UISizeConstraint", {
            MaxSize = Vector2.new(math.max(512, self.state.Size * 40), math.max(512, self.state.Size * 40))
        }),

        Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1
        }),

        Roact.createElement("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1

        }, {
            Roact.createElement("UIPadding", {
                PaddingTop = UDim.new(Padding, 2),
                PaddingLeft = UDim.new(Padding, 2),
                PaddingRight = UDim.new(0, 0),
                PaddingBottom = UDim.new(0, 0),
            }),

            Roact.createElement("UIGridLayout", {
                CellPadding = UDim2.new(Padding, 2, Padding, 2),
                CellSize = UDim2.new(CellSize, -2, CellSize, -2),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
    
            Roact.createFragment(require(script.Tiles)(self.state.Grid))
        }),

        Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 6)
        }),

        if self.state.Prompt then Roact.createElement(require(script.Prompt), {PromptName = self.state.Prompt}) else nil
    })
end

function Board:didMount()
    self.SizeChangeEvent = Accord.Size:Connect(function(value, lastValue)
        Accord.Grid:Generate()

        self:setState({
            Size = value
        })
    end)

    self.MinesChangeEvent = Accord.Mines:Connect(function(value, lastValue)
        Accord.Grid:Generate()

        self:setState({
            Mines = value
        })
    end)

    self.GridChangeEvent = Accord.Grid:Connect(function(value, lastValue)
        self:setState({
            Grid = value
        })
    end)

    self.PromptChangedEvent = Accord.Prompt:Connect(function(value, lastValue)
        self:setState({
            Prompt = value
        })
    end)
end

function Board:willUnmount()
    if typeof(self.SizeChangeEvent) == "table" and self.SizeChangeEvent["Connected"] then
        self.SizeChangeEvent:Disconnect()
    end
    self.SizeChangeEvent = nil

    if typeof(self.MinesChangeEvent) == "table" and self.MinesChangeEvent["Connected"] then
        self.MinesChangeEvent:Disconnect()
    end
    self.MinesChangeEvent = nil

    if typeof(self.GridChangeEvent) == "table" and self.GridChangeEvent["Connected"] then
        self.GridChangeEvent:Disconnect()
    end
    self.GridChangeEvent = nil

    if typeof(self.PromptChangedEvent) == "table" and self.PromptChangedEvent["Connected"] then
        self.PromptChangedEvent:Disconnect()
    end
    self.PromptChangedEvent = nil
end

return Board