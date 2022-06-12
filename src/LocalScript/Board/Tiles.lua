
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Packages.roact)
local Types = require(script.Parent.Parent.Parent:WaitForChild("Types"))

local RevealEvent = script.Parent.Parent.Parent:WaitForChild("RevealEvent")
local FlagEvent = script.Parent.Parent.Parent:WaitForChild("FlagEvent")

local NumberColors = {
    [1] = Color3.fromRGB(0, 0, 255),
    [2] = Color3.fromRGB(0, 128, 0),
    [3] = Color3.fromRGB(255, 0, 0),
    [4] = Color3.fromRGB(0, 0, 128),
    [5] = Color3.fromRGB(128, 0, 0),
    [6] = Color3.fromRGB(0, 128, 128),
    [7] = Color3.fromRGB(0, 0, 0),
    [8] = Color3.fromRGB(128, 128, 128)
}

local ValueText = {
    [0] = "",
    ["Mine"] = "💣"
}

return function(Grid: Types.Grid)
    local Tiles = {}

    for Y=1, #Grid do
        for X=1, #Grid[Y] do

            local TLCorner = if X == 1 and Y == 1 then Vector2.new(0, 0) else nil
            local TRCorner = if X == #Grid[Y] and Y == 1 then Vector2.new(1, 0) else nil
            local BLCorner = if X == 1 and Y == #Grid then Vector2.new(0, 1) else nil
            local BRCorner = if X == #Grid[Y] and Y == #Grid then Vector2.new(1, 1) else nil

            local Offset = TLCorner or TRCorner or BLCorner or BRCorner

            local Revealed = Grid[Y][X].Revealed or false
            local Flagged = Grid[Y][X].Flagged or false
            local BgColor = if Revealed then Color3.new(1, 1, 1) else Color3.new(0.7, 0.7, 0.7)

            local Value = Grid[Y][X].Value
            local Text = if Flagged then "🚩" elseif Revealed then ValueText[Value] or Value else ""


            table.insert(Tiles, Roact.createElement("ImageButton", {
                BackgroundColor3 = BgColor,
                BackgroundTransparency = if Offset then 1 else 0,
                Image = "",
                AutoButtonColor = false,
                LayoutOrder = (Y - 1) * #Grid + X,
                BorderSizePixel = 0,

                [Roact.Event.Activated] = if not Revealed and not Flagged then function()
                    RevealEvent:Fire(X, Y)
                end else nil,

                [Roact.Event.MouseButton2Click] = if not Revealed then function()
                    FlagEvent:Fire(X, Y)
                end else nil

            }, {
                Roact.createElement("TextLabel", {
                    Size = UDim2.fromScale(0.7, 0.7),
                    Position =  UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = NumberColors[tonumber(Grid[Y][X].Value)] or Color3.new(0, 0, 0),
                    Font = Enum.Font.Bangers,
                    TextScaled = true,
                    ZIndex = 2
                }),

                if Offset then Roact.createElement("Frame", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = BgColor,
                    BorderSizePixel = 0

                }, {
                    Roact.createElement("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    }),

                    Roact.createElement("Frame", {
                        Size = UDim2.fromScale(0.5, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(Offset.X, 0.5),
                        BackgroundColor3 = BgColor,
                        BorderSizePixel = 0,
                    }),

                    Roact.createElement("Frame", {
                        Size = UDim2.fromScale(1, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, Offset.Y),
                        BackgroundColor3 = BgColor,
                        BorderSizePixel = 0,
                    })
                }) else nil,
            }))
        end
    end

    return Tiles
end