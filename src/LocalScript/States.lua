
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Accord = require(ReplicatedStorage.Packages.accord)
local Types = require(script.Parent.Parent:WaitForChild("Types"))



Accord:NewState("Size", 10)

function Accord.Size:Set(number: number)
    self.value = math.clamp(number, 3, 49)

    if Accord.Mines:GetValue() > math.pow(Accord.Size:GetValue(), 2) - 1 then
        Accord.Mines:Set(Accord.Mines:GetValue())
    end
end



Accord:NewState("Mines", 12)

function Accord.Mines:Set(number: number)
    self.value = math.min(math.pow(Accord.Size:GetValue(), 2) - 1, math.max(number, 1))
end



Accord:NewState("Prompt", false)

function Accord.Prompt:None()
    self.value = false
end

function Accord.Prompt:Win()
    self.value = "Win"
end

function Accord.Prompt:Loss()
    self.value = "Loss"
end

function Accord.Prompt:Help()
    local Prompt = Accord.Prompt:GetValue()
    if Prompt == "Win" or Prompt == "Loss" then
        return
    end

    self.value = if self.value ~= "Help" then "Help" else false
end

function Accord.Prompt:Retry()
    local Prompt = Accord.Prompt:GetValue()
    if Prompt == "Win" or Prompt == "Loss" then
        return
    end

    self.value = if self.value ~= "Retry" then "Retry" else false
end



Accord:NewState("RevealedTiles", 0)

function Accord.RevealedTiles:Inc()
    self.value += 1
end

function Accord.RevealedTiles:Reset()
    self.value = 0
end



Accord:NewState("Grid", {})

function Accord.Grid:Generate()
    Accord.RevealedTiles:Reset()
    local Random = if Seed then Random.new(Seed) else Random.new()
    
    local NewGrid: Types.Grid = {}
    local Size = Accord.Size:GetValue()

    for Y=1, Size do
        NewGrid[Y] = {}

        for X=1, Size do
            NewGrid[Y][X] = {Revealed = false, Value = 0}
        end
    end

    local Mines = Accord.Mines:GetValue()

    while Mines > 0 do
        local X = Random:NextInteger(1, Size)
        local Y = Random:NextInteger(1, Size)

        if NewGrid[Y][X].Value ~= "Mine" then
            NewGrid[Y][X].Value = "Mine"
            Mines -= 1

        else
            continue
        end

        for Y2=-1, 1 do
            for X2=-1, 1 do
                local InX = X - X2 >= 1 and X - X2 <= Size
                local InY = Y - Y2 >= 1 and Y - Y2 <= Size

                if InX and InY then
                    local Value = NewGrid[Y - Y2][X - X2].Value

                    if typeof(Value) == "number" then
                        NewGrid[Y - Y2][X - X2].Value += 1
                    end
                end
            end
        end
    end

    self.value = NewGrid
end

function Accord.Grid:Reveal(X: number, Y: number)
    local function Reveal(X: number, Y: number)
        if not (X and Y) then
            return
        end
    
        local Grid: Types.Grid = Accord.Grid:GetValue()
        local Size = Accord.Size:GetValue()
    
        if not Grid[Y] or not Grid[Y][X] or Grid[Y][X].Revealed or Grid[Y][X].Flagged then
            return
        end

        self.value[Y][X].Revealed = true

        if Grid[Y][X].Value ~= "Mine" then
            Accord.RevealedTiles:Inc()
        end
    
        if math.pow(Size, 2) == Accord.RevealedTiles:GetValue() + Accord.Mines:GetValue() then
            Accord.Prompt:Win()
            return
    
        elseif Grid[Y][X].Value == "Mine" then
            Accord.Prompt:Loss()
            return
    
        else
            Accord.Prompt:None()
        end
    
        if Grid[Y][X].Value == 0 then
            for Y2=-1, 1 do
                for X2=-1, 1 do
                    Reveal(X + X2, Y + Y2)
                end
            end
        end
    end

    Reveal(X, Y)
end

function Accord.Grid:Flag(X: number, Y: number)
    if not (X and Y) then
        return
    end

    local Grid: Types.Grid = Accord.Grid:GetValue()

    if not Grid[Y] or not Grid[Y][X] or Grid[Y][X].Revealed then
        return
    end

    self.value[Y][X].Flagged = not self.value[Y][X].Flagged
end

return nil