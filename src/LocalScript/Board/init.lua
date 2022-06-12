
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)
local Types = require(script.Parent.Parent:WaitForChild("Types"))

local RevealEvent = script.Parent.Parent:WaitForChild("RevealEvent")
local FlagEvent = script.Parent.Parent:WaitForChild("FlagEvent")
local SettingsChangeEvent = script.Parent.Parent:WaitForChild("SettingsChangeEvent")
local PromptEvent = script.Parent.Parent:WaitForChild("PromptEvent")
local RetryEvent = script.Parent.Parent:WaitForChild("RetryEvent")

local Camera = workspace.CurrentCamera

local Board = Roact.Component:extend("Board")

function Board:init(Props)
    self:setState({
        Size = 10,

        Mines = 12,

        Grid = {},

        Prompt = false
    })

    self.RevealedNumbers = 0
    self.FlaggedMines = 0

    self:GenerateGrid()
end

function Board:GenerateGrid(Seed: number?)
    self.RevealedNumbers = 0
    local Random = if Seed then Random.new(Seed) else Random.new()

    local NewGrid: Types.Grid = {}

    for Y=1, self.state.Size do
        NewGrid[Y] = {}

        for X=1, self.state.Size do
            NewGrid[Y][X] = {Revealed = false, Value = 0}
        end
    end

    local Mines = self.state.Mines

    while Mines > 0 do
        local X = Random:NextInteger(1, self.state.Size)
        local Y = Random:NextInteger(1, self.state.Size)

        if NewGrid[Y][X].Value ~= "Mine" then
            NewGrid[Y][X].Value = "Mine"
            Mines -= 1

        else
            continue
        end

        for Y2=-1, 1 do
            for X2=-1, 1 do
                local InX = X - X2 >= 1 and X - X2 <= self.state.Size
                local InY = Y - Y2 >= 1 and Y - Y2 <= self.state.Size

                if InX and InY then
                    local Value = NewGrid[Y - Y2][X - X2].Value

                    if typeof(Value) == "number" then
                        NewGrid[Y - Y2][X - X2].Value += 1
                    end
                end
            end
        end
    end

    self:setState({
        Grid = NewGrid
    })
end

function Board:Reveal(X: number, Y: number, Grid)
    if not X and Y then
        return Grid
    end

    local TempGrid: Types.Grid = Grid or self.state.Grid

    if not TempGrid[Y] or not TempGrid[Y][X] or TempGrid[Y][X].Revealed or TempGrid[Y][X].Flagged then
        return Grid
    end

    TempGrid[Y][X].Revealed = true

    if TempGrid[Y][X].Value ~= "Mine" then
        self.RevealedNumbers += 1
    end
    local Prompt = if math.pow(self.state.Size, 2) == self.RevealedNumbers + self.state.Mines then "Win" else false

    if TempGrid[Y][X].Value == 0 then
        for Y2=-1, 1 do
            for X2=-1, 1 do
                TempGrid = self:Reveal(X + X2, Y + Y2, TempGrid) or TempGrid
            end
        end
    end

    if not Grid then
        self:setState({
            Grid = TempGrid,
            Prompt = Prompt or if TempGrid[Y][X].Value == "Mine" then "Loss" else self.state.Prompt
        })

    elseif Prompt then
        self:setState({
            Prompt = Prompt
        })

    else
        return TempGrid
    end
end

function Board:Flag(X: number, Y: number)
    if not X and Y then
        return
    end

    local Grid: Types.Grid = self.state.Grid

    if not Grid[Y] or not Grid[Y][X] or Grid[Y][X].Revealed then
        return
    end

    Grid[Y][X].Flagged = not Grid[Y][X].Flagged

    if Grid[Y][X].Value == "Mine" then
        self.FlaggedMines += if Grid[Y][X].Flagged then 1 else -1
    end

    self:setState({
        Grid = Grid
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
    self.RevealEvent = RevealEvent.Event:Connect(function(X, Y)
        self:Reveal(X, Y)
    end)

    self.FlagEvent = FlagEvent.Event:Connect(function(X, Y)
        self:Flag(X, Y)
    end)

    self.SettingsChangeEvent = SettingsChangeEvent.Event:Connect(function(SettingsName: string, SettingsValue: any)
        self.state[SettingsName] = SettingsValue

        if math.pow(self.state.Size, 2) <= self.state.Mines then
            SettingsChangeEvent:Fire("Mines", math.pow(self.state.Size, 2) - 1)

            return
        end

        self:GenerateGrid()
    end)

    self.PromptEvent = PromptEvent.Event:Connect(function(PromptName: string)
        if self.state.Prompt ~= "Win" and self.state.Prompt ~= "Loss" then
            self:setState({
                Prompt = if self.state.Prompt ~= PromptName then PromptName else false
            })
        end
    end)

    self.RetryEvent = RetryEvent.Event:Connect(function()
        self:GenerateGrid()

        self:setState({
            Prompt = false
        })
    end)
end

function Board:willUnmount()
    if self.RevealEvent and typeof(self.RevealEvent) == "RBXScriptConnection" then
        self.RevealEvent:Disconnect()
    end
    self.RevealEvent = nil

    if self.FlagEvent and typeof(self.FlagEvent) == "RBXScriptConnection" then
        self.FlagEvent:Disconnect()
    end
    self.FlagEvent = nil

    if self.SettingsChangeEvent and typeof(self.SettingsChangeEvent) == "RBXScriptConnection" then
        self.SettingsChangeEvent:Disconnect()
    end
    self.SettingsChangeEvent = nil
end

return Board