-- Thugsense
--[[
    Made by samet

    Assign different flags to each element to prevent from configs overriding eachother
    Example script is at the bottom

    Documentation:
    function Library:Window(Data: table
        Name/name: string,
        Size/size: UDim2
    )

    function Window:Page(Data: table
        Name/name: string,
        Columns/columns: number,
        SubTabs/subtabs: boolean
    )

    function Page:SubPage(Data: table
        Icon/icon: string,
        Columns/columns: number
    )

    function Page:Section(Data: table
        Name/name: string,
        Side/side: number,
    )

    function Page:MultiSection(Data: table
        Sections/sections: table,
        Side/side: number
    )

    function Page:ScrollableSection(Data: table
        Name/name: string,
        Side/side: number,
        Size/size: number
    )

    function Section:Divider()

    function Section:Label(Data: table
        Name/name: string,
        Alignment/alignment: string
    )

    function Section:Toggle(Data: table
        Name/name: string,
        Default/default: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Button(Data: table
        Name/name: string,
        Callback/callback: function
    )

    function Section:Slider(Data: table
        Name/name: string,
        Min/min: number,
        Max/max: number,
        Decimals/decimals: number,
        Default/default: number,
        Suffix/suffix: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Dropdown(Data: table
        Name/name: string,
        Items/items: table,
        Default/default: string,
        Flag/flag: string,
        Multi/multi: boolean,
        Callback/callback: function
    )

    function Section:Listbox(Data: table
        Size/size: number,
        Items/items: table,
        Default/default: string,
        Multi/multi: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Sections:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Library:Watermark(Name: string)
    function Library:Notification(Text: string, Duration: number, Color: Color3, Icon: table)
    function Library:KeybindList()
]]

local LoadingTick = os.clock()

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower

    Library = {
        Flags = { },
        
        Theme = {
            ["Background"] = FromRGB(15, 15, 20),
            ["Inline"] = FromRGB(20, 20, 25),
            ["Page Background"] = FromRGB(30, 30, 35),
            ["Border"] = FromRGB(10, 10, 10),
            ["Outline"] = FromRGB(27, 27, 32),
            ["Accent"] = FromRGB(235, 157, 255),
            ["Element"] = FromRGB(33, 33, 36),
            ["Hovered Element"] = FromRGB(40, 40, 43),
            ["Text"] = FromRGB(215, 215, 215),
            ["Text Border"] = FromRGB(0, 0, 0),
            ["Placeholder Text"] = FromRGB(150, 150, 155)
        },

        MenuKeybind = Enum.KeyCode.Z, 

        FontName = "Default",
        FadeSpeed = 0.3,

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Exponential,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "FunctionMeta",
            Configs = "FunctionMeta/Configs",
            Assets = "FunctionMeta/Assets",
            Themes = "FunctionMeta/Themes"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/hue.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Resize"] = { "Resize.png", "https://github.com/sametexe001/images/blob/main/resize.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = nil,
        KeyList = nil,

        CurrentColorpicker = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Files 
    for _, FileName in Library.Folders do
        if not isfolder(FileName) then
            makefolder(FileName)
        end
    end

    for _, ImageData in Library.Images do
        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.Border = function(self, ThemeName)
            if not self.Instance then 
                return
            end

            ThemeName = ThemeName or "Border"

            local Item = self.Instance
            local UIStroke = Instances:Create("UIStroke", {
                Parent = Item,
                Color = Library.Theme[ThemeName] or Library.Theme.Border,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            UIStroke:AddToTheme({Color = ThemeName})

            return UIStroke
        end

        Instances.TextBorder = function(self, ThemeName)
            if not self.Instance then 
                return
            end

            ThemeName = ThemeName or "Text Border"

            local UIStroke = Instances:Create("UIStroke", {
                Parent = self.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Library.Theme[ThemeName] or Library.Theme["Text Border"],
                Thickness = 1
            })

            UIStroke:AddToTheme({Color = ThemeName})

            return UIStroke
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position
                end
            end)

            self:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("TextButton", {
				Parent = Gui,
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, 0, 1, 0),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
                Visible = true,
                Text = ""
			})

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                end
            end)

            ResizeButton:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Resizing then
					ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

					Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
					Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

					Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Windows-XP-Tahoma", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })

        Library.Font = CustomFont:Get("Windows-XP-Tahoma")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2New(0.5, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(0.5, 0, 0, 0),
        Name = "\0",
        Size = UDim2New(0.34, 0, 1, -14),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDimNew(0, 10)
    }) 

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error caught in function, report this to the devs:\n"..Result, 5, FromRGB(255, 0, 0))
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        if type(Config) == "table" then
            Config = HttpService:JSONEncode(Config)
        end

        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        if Success then 
            Library:Notification("Successfully loaded config", 5, Color3.fromRGB(0, 255, 0))
        end

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        local Path = Library.Folders.Configs .. "/" .. Config

        if not isfile(Path) and isfile(Path .. ".json") then
            Path = Path .. ".json"
        end

        if isfile(Path) then 
            delfile(Path)
            Library:Notification("Deleted config " .. Config, 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.SaveConfig = function(self, Config)
        local Path = Library.Folders.Configs .. "/" .. Config

        if not isfile(Path) and isfile(Path .. ".json") then
            Path = Path .. ".json"
        end

        if isfile(Path) then
            writefile(Path, Library:GetConfig())
            Library:Notification("Saved config " .. Config, 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }

        if isfolder(self.Folders.Configs) then
            for _, Value in listfiles(self.Folders.Configs) do
                local FileName = StringGSub(Value, "\\", "/")
                FileName = FileName:match("([^/]+)$")

                if FileName and FileName:sub(-5) == ".json" then
                    TableInsert(List, FileName)
                end
            end
        end

        if Element and Element.Refresh then
            Element:Refresh(List)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Watermark = function(self, Name)
        local Watermark = { } 

        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Size = UDim2New(0, 0, 0, 20),
                Name = "\0",
                Position = UDim2New(0, 15, 0, 15),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Watermark"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                PaddingTop = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -2),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })             
        end

        function Watermark:SetVisibility(Bool)
            Items["Watermark"].Instance.Visible = Bool
        end

        function Watermark:SetText(Text)
            Items["Title"].Instance.Text = tostring(Text)
        end

        Watermark.Elements = Items
        Library.WatermarkObj = Watermark

        return Watermark
    end

    Library.Notification = function(self, Text, Duration, Color, Icon)
        -- Scoot-style compatibility: Notification(title, description, duration)
        if type(Duration) ~= "number" then
            local Title = tostring(Text or "")
            local Description = tostring(Duration or "")
            local FinalDuration = tonumber(Color) or 4

            if Title ~= "" and Description ~= "" then
                Text = Title .. ": " .. Description
            elseif Title == "" then
                Text = Description
            else
                Text = Title
            end

            Duration = FinalDuration
            Color = Library.Theme.Accent
            Icon = nil
        end

        Color = Color or Library.Theme.Accent

        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 22),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                PaddingTop = UDimNew(0, 1),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 13, 0, 2),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 13, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            })  
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Notification"].Instance,
                ImageColor3 = FromRGB(255, 255, 255),
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Image = "rbxassetid://94324346713012",
                BackgroundTransparency = 1,
                Position = UDim2New(0, -2, 0, 3),
                Size = UDim2New(0, 13, 0, 13),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            if not Icon then 
                Items["Icon"]:Clean()
                Items["Title"].Instance.Position = UDim2New(0, 1, 0, 2)
            else
                Items["Icon"].Instance.Image = Icon[1]
                Items["Icon"].Instance.ImageColor3 = Icon[2] or FromRGB(255, 255, 255)
            end
        end

        Items["Notification"].Instance.BackgroundTransparency = 1
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        for Index, Value in Items["Notification"].Instance:GetDescendants() do
            if Value:IsA("UIStroke") then 
                Value.Transparency = 1
            elseif Value:IsA("TextLabel") then 
                Value.TextTransparency = 1
            elseif Value:IsA("ImageLabel") then 
                Value.ImageTransparency = 1
            elseif Value:IsA("Frame") then 
                Value.BackgroundTransparency = 1
            end
        end

        Library:Thread(function()
            Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 22)})
            
            task.wait(0.06)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then
                    Tween:Create(Value, nil, {Transparency = 0}, true)
                elseif Value:IsA("TextLabel") then
                    Tween:Create(Value, nil, {TextTransparency = 0}, true)
                elseif Value:IsA("ImageLabel") then
                    Tween:Create(Value, nil, {ImageTransparency = 0}, true)
                elseif Value:IsA("Frame") then
                    Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
                end
            end

            task.delay(Duration + 0.1, function()
                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                    elseif Value:IsA("ImageLabel") then
                        Tween:Create(Value, nil, {ImageTransparency = 1}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                    end
                end

                task.wait(0.06)

                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.KeybindList = function(self)
        local KeybindList = { }
        self.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 15, 0.5, 0),
                Size = UDim2New(0, 0, 0, 18),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Name = "\0",
                Size = UDim2New(0, 100, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 19),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        function KeybindList:Add(Mode, Name, Key)
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "(" .. Mode .. ") " .. Name .. " - " .. Key,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = NewKey.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        
            function NewKey:Set(Mode, Name, Key)
                NewKey.Instance.Text = "(" .. Mode .. ") " .. Name .. " - " .. Key
            end

            function NewKey:SetStatus(Status)
                if Status == "Active" then 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    NewKey:ChangeItemTheme({TextColor3 = "Accent"})
                else 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Text})
                    NewKey:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            Items["KeybindList"].Instance.Visible = Bool
        end

        KeybindList.Elements = Items
        Library.KeybindListObj = KeybindList

        return KeybindList
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            HexValue = "",
            
            IsOpen = false,

            Color = FromRGB(0, 0, 0),

            Class = "Colorpicker"
        }

        Library.Flags[Data.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 20, 0, 10),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 


            Colorpicker.CalculateCount = function(self, Index, YScale, YOffset)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - 21
            
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, -XPosition, YScale or 0.5, YOffset or 0)
            end

            Colorpicker:CalculateCount(Data.Count)
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            })             

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                AutoButtonColor = false,
                Text = "",
                Name = "\0",
                Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15),
                BorderColor3 = FromRGB(10, 10, 10),
                Visible = false,
                Size = UDim2New(0, 238, 0, 224),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["ColorpickerWindow"]:MakeDraggable()
            Items["ColorpickerWindow"]:MakeResizeable(Vector2New(200, 180), Vector2New(9999, 9999))

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Data.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, -2, 0, -3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Position = UDim2New(0, -6, 0, -6),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 12, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 15),
                Size = UDim2New(1, -26, 1, -40),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Image = Library:GetImage("Hue"),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 15),
                Size = UDim2New(0, 18, 1, -15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, -26, 0, 18),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Alpha"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(0, 0, 0))}
            }) 
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
        end

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local Debounce = false

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15)

                if Library.CurrentColorpicker then
                    Library.CurrentColorpicker:SetOpen(false)
                    Library.CurrentColorpicker = nil 
                end

                if not Library.CurrentColorpicker then 
                    Library.CurrentColorpicker = Colorpicker
                end
            else
                Library.CurrentColorpicker = nil
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 10001 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Data.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Data.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Bool
            end)
        end

        function Colorpicker:Get()
            return Colorpicker.Value
        end

        function Colorpicker:SetVisibility(Bool)
           Data.Parent.Instance.Visible = Bool 
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                Color = FromRGB(Color[1], Color[2], Color[3])
                Alpha = Color[4]
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.989)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})

            local HuePositionY = MathClamp(self.Hue, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})

            self:Update()
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            Items["ColorpickerButton"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.989)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()            
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            local PositionY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, PositionY, 0)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local PositionX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PositionX, 0, 0, 0)})
            self:Update(true)
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
            end
        end)

        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
            end
        end)

        Items["Hue"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
            end
        end)

        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end

                if SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Key = nil,
            Value = "",
            Mode = "",

            Toggled = false,
            IsOpen = false,

            Picking = false,

            Class = "Keybind"
        }

        Library.Flags[Data.Flag] = { }

        local KeyListItem

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(27, 27, 32),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 1, 1),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

            if Library.KeyList then 
                KeyListItem = Library.KeyList:Add(Keybind.Mode, Data.Name, Keybind.Value)
            end
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(10, 10, 10)
            }):AddToTheme({Color = "Border"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["KeyButton"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "MB2",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                PaddingRight = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 3),
                PaddingBottom = UDimNew(0, 2)
            })             

            Items["Window"] = Instances:Create("Frame", {
                Parent = Data.Parent.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 1, 5),
                Size = UDim2New(0, 50, 0, 48),
                BorderSizePixel = 2,
                Visible = false,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Window"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 157, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Toggle"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Hold",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 15),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hold"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Always",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 30),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Always"]:AddToTheme({TextColor3 = "Text"})
             
            Instances:Create("UIStroke", {
                Parent = Items["Always"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        end

        local Modes = {
            ["Toggle"] = Items["Toggle"],
            ["Hold"] = Items["Hold"],
            ["Always"] = Items["Always"]
        }

        local Update = function()
            if KeyListItem then
                KeyListItem:Set(Keybind.Mode, Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled and "Active" or "Inactive")
            end
        end

        function Keybind:Get()
           return Keybind.Toggled, Keybind.Key, Keybind.Mode 
        end

        function Keybind:SetVisibility(Bool)
            Data.Parent.Instance.Visible = Bool
        end

        local Debounce = false

        function Keybind:SetOpen(Bool)
            Keybind.IsOpen = Bool

            if Bool then 
                Debounce = true
                Items["Window"].Instance.Visible = true
                Items["Window"].Instance.ZIndex = 16
                Items["Window"]:Tween(nil, {BackgroundTransparency = 0})

                task.wait(0.1)

                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 0}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 0}, true)
                        Value.ZIndex = 16
                    end
                end
            else 
                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                        Value.ZIndex = 1
                    end
                end

                task.wait(0.1)

                Items["Window"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Window"].Instance.ZIndex = 1
                task.wait(0.1)
                Items["Window"].Instance.Visible = false
            end

            Debounce = false
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
           elseif TableFind({"Toggle", "Hold", "Always"}, Key) then 
                Keybind.Mode = Key
                
                Keybind:SetMode(Key)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then 
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Text"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X, 1, 1)
            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then 
                    Value:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    Value:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    Value:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Value:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            if Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            else
                Keybind.Toggled = false
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})

            local InputBegan 
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Library:IsMouseOverFrame(Items["Window"]) then
                    return
                end

                if Debounce then 
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        if Data.Default then 
            Keybind:Set({
                Key = Data.Default,
                Mode = Data.Mode or "Toggle"
            })
        end

        Library.SetFlags[Data.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Size = Data.Size or Data.size or UDim2New(0, 500, 0, 600),

            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.25,

            Pages = { },
            SubPages = { },
            Elements = { },

            IsOpen = true
        }

        local Items = { } do 
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = Window.Size,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["MainFrame"].Instance.Position = UDim2New(0, Camera.ViewportSize.X / 4, 0, Camera.ViewportSize.Y / 4)

            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))
            
            Items["AccentBorder"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(235, 157, 255)
            })  Items["AccentBorder"]:AddToTheme({Color = "Accent"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 6, 0, 1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 20),
                BorderColor3 = FromRGB(27, 27, 32),
                Size = UDim2New(1, -14, 1, -27),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})
            
            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 7),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 26),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})
        end

        local Debounce = false

        function Window:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["MainFrame"].Instance.Visible = true
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["MainFrame"].Instance.Visible = Bool
            end)
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        Window.Elements = Items

        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            HasSubtabs = Data.Subtabs or Data.subtabs or Data.SubPages or Data.subpages or false,

            Active = false,
            ColumnsData = { },
            SubPages = { },
            Elements = { }
        }

        local Items = { } do 
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Elements["Pages"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Inactive"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.47999998927116394,
                Text = Page.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 3),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["UIGradient"] = Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
            })            

            Items["Page"] = Instances:Create("Frame", {
                Parent = Page.Window.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                Visible = false
            })
            
            if not Page.HasSubtabs then 
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                for Index = 1, Page.Columns do
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = FromRGB(235, 157, 255),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 1,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        BottomImage = Library:GetImage("Scrollbar"),
                        MidImage = Library:GetImage("Scrollbar"),
                        TopImage = Library:GetImage("Scrollbar"),
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})
                    
                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        PaddingTop = UDimNew(0, 6),
                        PaddingBottom = UDimNew(0, 6),
                        PaddingRight = UDimNew(0, 6),
                        PaddingLeft = UDimNew(0, 6)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Padding = UDimNew(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }) 

                    Page.ColumnsData[Index] = NewColumn
                end
            else
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 7, 0, 45),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Size = UDim2New(1, -14, 1, -52),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["SubTabs"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -14, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = Items["SubTabs"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end
        end

        local Debounce = false

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Page"].Instance.Visible = true

                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                Items["Hide"].Instance.Visible = true

                Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            else
                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})
                Items["Hide"].Instance.Visible = false

                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            end

            local Descendants = Items["Page"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Page"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Page.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Page"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Elements = Items
        Page.Items = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Icon = Data.Icon or Data.icon,
            Name = Data.Name or Data.name or "Tab",
            Columns = Data.Columns or Data.columns or 2,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Elements["SubTabs"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -2),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 2),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            if SubPage.Icon then
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.35,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://"..SubPage.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(0, 30, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})
            else
                Items["Icon"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Name = "\0",
                    FontFace = Library.Font,
                    Text = SubPage.Name,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 0.35,
                    TextSize = 10,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Size = UDim2New(1, -6, 1, 0),
                    Position = UDim2New(0, 3, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({TextColor3 = "Text"})
            end

            Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(138, 138, 138))}
            }) 

            Items["Subtab"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Elements["Columns"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["Subtab"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Subtab"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Subtab"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            for Index = 1, SubPage.Columns do
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Subtab"].Instance,
                    ScrollBarImageColor3 = FromRGB(235, 157, 255),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 1,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    PaddingTop = UDimNew(0, 6),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 6)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 

                SubPage.ColumnsData[Index] = NewColumn
            end
        end

        local Debounce = false

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Subtab"].Instance.Visible = true

                if SubPage.Icon then
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                else
                    Items["Icon"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                    Items["Icon"]:ChangeItemTheme({TextColor3 = "Accent"})
                end
                Items["Hide"].Instance.Visible = true

                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, 1)
            else
                if SubPage.Icon then
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.35})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                else
                    Items["Icon"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.35})
                    Items["Icon"]:ChangeItemTheme({TextColor3 = "Text"})
                end
                Items["Hide"].Instance.Visible = false

                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, -2)
            end

            local Descendants = Items["Subtab"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Subtab"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Subtab"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            local PageSubPages = (SubPage.Page and SubPage.Page.SubPages) or SubPage.Window.SubPages

            for Index, Value in PageSubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if SubPage.Page and SubPage.Page.SubPages then
            if #SubPage.Page.SubPages == 0 then
                SubPage:Turn(true)
            else
                SubPage:Turn(false)
            end

            TableInsert(SubPage.Page.SubPages, SubPage)
        elseif #SubPage.Window.SubPages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Elements = Items
        SubPage.Items = Items

        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Pages.MultiSection = function(self, Data)
        local MultiSection = {
            Window = self.Window,
            Page = self,
            
            Sections = Data.Sections or Data.sections or { "Section 1", "Section 2", "Section 3" }, 
            Side = Data.Side or Data.side or 1,

            SectionContents = { },

            Elements = { }
        }

        local Items = { } do
            Items["MultiSection"] = Instances:Create("Frame", {
                Parent = MultiSection.Page.ColumnsData[MultiSection.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["MultiSection"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["MultiSection"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["MultiSection"].Instance,
                PaddingBottom = UDimNew(0, 6)
            }) 
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Items["Sections"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 9),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Sections"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 35),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            }) 
        end

        for Index, Value in MultiSection.Sections do 
            local NewSection = {
                Window = MultiSection.Window,
                Page = MultiSection.Page,
                MultiSection = MultiSection,

                Name = Value,

                Elements = { },

                Active = false,
            }

            local SubItems = { } do 
                SubItems["Inactive"] = Instances:Create("TextButton", {
                    Parent = Items["Sections"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 30, 35)
                })  SubItems["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                SubItems["Text"] = Instances:Create("TextLabel", {
                    Parent = SubItems["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 0.48,
                    Text = NewSection.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})

                SubItems["Hide"] = Instances:Create("Frame", {
                    Parent = SubItems["Inactive"].Instance,
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Name = "\0",
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  SubItems["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

                SubItems["MiscPixel1"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    Size = UDim2New(0, 1, 0, 1),
                    Name = "\0",
                    Position = UDim2New(0, -1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})

                SubItems["MiscPixel2"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    Name = "\0",
                    Position = UDim2New(1, 1, 0, 1),
                    Size = UDim2New(0, 1, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0",
                    Color = FromRGB(27, 27, 32)
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = SubItems["Inactive"].Instance,
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
                }) 

                SubItems["Content"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 
                
                Instances:Create("UIListLayout", {
                    Parent = SubItems["Content"].Instance,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end

            local Debounce = false

            function NewSection:Turn(Bool)
                if Debounce then 
                    return 
                end

                NewSection.Active = Bool

                Debounce = true 

                if Bool then 
                    SubItems["Content"].Instance.Visible = true

                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                end

                local Descendants = SubItems["Content"].Instance:GetDescendants()
                TableInsert(Descendants, SubItems["Content"].Instance)

                local NewTween
                for Index, Value in Descendants do 
                    local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                    if not ValueIndex then 
                        continue
                    end

                    if type(ValueIndex) == "table" then
                        for _, Property in ValueIndex do 
                            NewTween = Library:FadeItem(Value, Property, Bool, MultiSection.Window.FadeSpeed or 0.5)
                        end
                    else
                        NewTween = Library:FadeItem(Value, ValueIndex, Bool, MultiSection.Window.FadeSpeed or 0.5)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    SubItems["Content"].Instance.Visible = Bool
                end)
            end

            SubItems["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in MultiSection.SectionContents do
                    Value:Turn(Value == NewSection)
                end
            end)

            if #MultiSection.SectionContents == 0 then 
                NewSection:Turn(true)
            end

            NewSection.Elements = SubItems

            MultiSection.SectionContents[#MultiSection.SectionContents+1] = setmetatable(NewSection, Library.Sections)
        end

        MultiSection.SectionContents[1]:Turn(true)
        MultiSection.Window.Sections[#MultiSection.Window.Sections+1] = MultiSection
        return TableUnpack(MultiSection.SectionContents)
    end

    Library.Pages.ScrollableSection = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,
            Size = Data.Size or Data.size or 175,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, Section.Size),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Items["Fade"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 2),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["Fade"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIGradient", {
                Parent = Items["Fade"].Instance,
                Rotation = -90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.718, 0.768750011920929), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                ScrollBarThickness = 3,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                Active = true,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Content"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                PaddingTop = UDimNew(0, 0),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 11),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Divider = function(self)
        local Divider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
        }

        local Items = { } do
            Items["Divider"] = Instances:Create("Frame", {
                Parent = Divider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["RealDivider"] = Instances:Create("Frame", {
                Parent = Items["Divider"].Instance,
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 3),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["RealDivider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDivider"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})
        end
        
        function Divider:SetVisibility(Bool)
            Items["Divider"].Instance.Visible = Bool
        end

        return Divider
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,
            Class = "Toggle",

            Count = 0
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Elements["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 11),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Toggle.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                Position = UDim2New(0, 18, 0, -1),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end
        
        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Bool)
            Toggle.Value = Bool or not Toggle.Value

            Library.Flags[Toggle.Flag] = Toggle.Value

            if Toggle.Value then 
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.48})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        function Toggle:SetVisiblity(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Toggle.Count,

                FadeSpeed = self.Window.FadeSpeed
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            Library.Flags[Colorpicker.Flag] = Extension

            return Colorpicker
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)
            Library.Flags[Keybind.Flag] = Extension

            return Keybind, Extension
        end

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set()
        end)

        if Toggle.Default then 
            Toggle:Set(Toggle.Default)
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local Items = { } do 
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Elements["Content"].Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 17),
                Selectable = false,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["TextBorder"] = Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Button:Press()
            Library:SafeCall(Button.Callback)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

            task.wait(0.1)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        function Button:SetVisiblity(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,
            Compact = Data.Compact or Data.compact or false,

            Value = 0,
            Sliding = false,
            Class = "Slider",
        }

        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 27),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealSlider"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealSlider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50/100s",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            if Slider.Compact then 
                Items["Value"]:Clean()
                Items["Value"] = nil

                Items["Slider"].Instance.Size = UDim2New(1,0,0,10)
                Items["Text"].Instance.Parent = Items["RealSlider"].Instance
                Items["Text"].Instance.Position = UDim2New(0,0,0,-2)
                Items["Text"].Instance.TextXAlignment = Enum.TextXAlignment.Center
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealSlider"]:OnHoverLeave(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value
            
            if Slider.Compact then
                Items["Text"].Instance.Text = `{Slider.Name}: {Slider.Value}{Slider.Suffix}`
            else
                Items["Value"].Instance.Text = `{Slider.Value}{Slider.Suffix}`
            end

            Items["Indicator"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        Items["RealSlider"]:Connect("MouseButton1Down", function()
            Slider.Sliding = true

            local MousePos = UserInputService:GetMouseLocation()

            local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(Value)
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
                local MousePos = UserInputService:GetMouseLocation()

                local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
            Class = "Dropdown",
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealDropdown"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealDropdown"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Open"] = Instances:Create("TextButton", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "+",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0, -4, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Open"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Open"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"}) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                Size = UDim2New(1, -25, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 5, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["OptionHolder"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(10, 10, 10),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 5),
                Size = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIListLayout", {
                Parent = Items["OptionHolder"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["OptionHolder"].Instance,
                PaddingBottom = UDimNew(0, 2)
            })

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Dropdown:Set(Option)
            if Dropdown.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option

                for Index, Value in Option do 
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then 
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = OptionData.Name

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then 
                Library:SafeCall(Dropdown.Callback, Option)
            end
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["OptionHolder"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"
                    end
                end

                if Dropdown.Callback then 
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then 
                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        local Debounce = false

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Dropdown.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.ZIndex = 15
                Items["Open"].Instance.Text = "-"
                Items["Open"].Instance.Position = UDim2New(0, -5, 0, -1)
            else
                Items["Open"].Instance.Text = "+"
                Items["Open"].Instance.Position = UDim2New(0, -4, 0, -1)
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 15 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Dropdown.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Dropdown.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Bool
                Items["OptionHolder"].Instance.ZIndex = Bool and 15 or 1
            end)
        end

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["Open"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)            
        end

        return Dropdown
    end

    Library.Sections.Label = function(self, Data)
        if type(Data) == "string" then
            Data = { Name = Data, Alignment = "Left" }
        end

        Data = Data or { }

        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Alignment = Data.Alignment or Data.alignment or "Left",

            Count = 0
        }

        local Items = { } do 
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
            }):AddToTheme({Color = "Text Border"})
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Label.Count,
                FadeSpeed = self.Window.FadeSpeed
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            
            return Colorpicker, Extension
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)

            return Keybind, Extension
        end

        return Label
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Tab = self.Tab,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,

            Value = "",
            Class = "Textbox"
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Background"] = Instances:Create("Frame", {
                Parent = Items["Textbox"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Background"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Background"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Inline"] = Instances:Create("TextBox", {
                Parent = Items["Background"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(178, 178, 178),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inline"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Inline"].Instance,
                PaddingBottom = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Background"]:OnHoverLeave(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            Textbox.Value = Value
            
            Items["Inline"].Instance.Text = Textbox.Value
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})

            Library.Flags[Textbox.Flag] = Textbox.Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        Items["Inline"]:Connect("Focused", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
        end)

        Items["Inline"]:Connect("FocusLost", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})

            Textbox:Set(Items["Inline"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end
    
    Library.Sections.Listbox = function(self, Data)
        Data = Data or {}

        local Listbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Items = Data.Items or Data.items or { },
            Multi = Data.Multi or Data.multi or false,
            Default = Data.Default or Data.default or 1,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Callback = Data.Callback or Data.callback or function() end,
            Size = Data.Size or Data.size or 175,

            Value = { },
            Options = { },
            Class = "Listbox",
        }

        local Items = { } do 
            Items["Listbox"] = Instances:Create("Frame", {
                Parent = Listbox.Section.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, Listbox.Size),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["RealListbox"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Listbox"].Instance,
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 1,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, 0, 1, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(15, 15, 20),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["RealListbox"]:AddToTheme({ScrollBarImageColor3 = "Accent", BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealListbox"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["RealListbox"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["RealListbox"].Instance,
                PaddingBottom = UDimNew(0, 5),
                PaddingTop = UDimNew(0, 2)
            }) 
        end

        function Listbox:Set(Option)
            if Listbox.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Listbox.Value = Option

                Library.Flags[Listbox.Flag] = Listbox.Value

                for Index, Value in Option do 
                    local OptionData = Listbox.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end
            else
                if not Listbox.Options[Option] then 
                    return
                end

                local OptionData = Listbox.Options[Option]

                Listbox.Value = OptionData.Name
                
                Library.Flags[Listbox.Flag] = Listbox.Value

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Listbox.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end
            end

            if Listbox.Callback then 
                Library:SafeCall(Listbox.Callback, Option)
            end
        end

        function Listbox:Get()
            return Listbox.Value
        end

        function Listbox:SetVisibility(Bool)
            Items["Listbox"].Instance.Visible = Bool
        end

        function Listbox:Remove(Option)
            if Listbox.Options[Option] then 
                Listbox.Options[Option].Button:Clean()
                Listbox.Options[Option] = nil
            end
        end

        function Listbox:Refresh(List)
            for Index, Value in Listbox.Options do 
                Listbox:Remove(Value.Name)
            end

            for Index, Value in List do 
                Listbox:Add(Value)
            end
        end

        function Listbox:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["RealListbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Listbox.Multi then
                    local Index = TableFind(Listbox.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Listbox.Value, Index)
                    else
                        TableInsert(Listbox.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Listbox.Value > 0 and TableConcat(Listbox.Value, ", ") or "--"
                else
                    if OptionData.Selected then
                        Listbox.Value = OptionData.Name

                        OptionData:Toggle("Active")

                        for Index, Value in Listbox.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Listbox.Value = nil

                        OptionData:Toggle("Inactive")
                    end
                end

                if Listbox.Callback then 
                    Library:SafeCall(Listbox.Callback, Listbox.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Listbox.Options[Option] = OptionData
            return OptionData
        end

        for Index, Value in Listbox.Items do 
            Listbox:Add(Value)
        end

        if Listbox.Default then 
            Listbox:Set(Listbox.Default)
        end

        Library.SetFlags[Listbox.Flag] = function(Value)
            Listbox:Set(Value)
        end

        return Listbox
    end


    -- ==========================================================================
    -- Scoot-style API compatibility layer
    -- Lets feature scripts written for Scoot's UI run on the Thugsense library.
    -- ==========================================================================

    do
        local BaseButton = Library.Sections.Button

        Library.Sections.Button = function(self, Data)
            if Data == nil then
                local Group = { Section = self }

                function Group:Add(Name, Callback)
                    return BaseButton(self.Section, { Name = Name, Callback = Callback })
                end

                return Group
            end

            return BaseButton(self, Data)
        end

        Library.Sections.Searchbox = function(self, Data)
            return self:Dropdown(Data)
        end
    end

    do
        local BaseWindow = Library.Window

        Library.Window = function(self, Data)
            local NewWindow = BaseWindow(self, Data)
            Library.CurrentWindow = NewWindow

            local BaseSetOpen = NewWindow.SetOpen

            NewWindow.SetOpen = function(Window, Bool, ...)
                local Result = BaseSetOpen(Window, Bool, ...)

                if Library.Apply3D then
                    pcall(Library.Apply3D)
                end

                return Result
            end

            return NewWindow
        end
    end

    Library.RefreshThemesList = function(self, Element)
        local List = { }

        if isfolder(self.Folders.Themes) then
            for _, Value in listfiles(self.Folders.Themes) do
                local FileName = StringGSub(Value, "\\", "/")
                FileName = FileName:match("([^/]+)$")

                if FileName and FileName:sub(-5) == ".json" then
                    TableInsert(List, FileName)
                end
            end
        end

        if Element and Element.Refresh then
            Element:Refresh(List)
        end
    end

    -- ==========================================================================
    -- Settings page (Scoot's CreateSettingsPage, rebuilt for Thugsense widgets)
    -- ==========================================================================

    Library.CreateSettingsPage = function(self, Window, Watermark, KeybindList, ESPPreview)
        local ESPPreviewWanted = ESPPreview ~= nil
        local SettingsPage = Window:Page({ Name = "Settings", SubPages = true })

        local function StripJson(Value)
            return tostring(Value or ""):gsub("%.json$", "")
        end

        local ThemingSubPage = SettingsPage:SubPage({ Name = "Theming", Columns = 2 })
        local ColorsSection = ThemingSubPage:Section({ Name = "Colors", Side = 1 })

        for Index, Value in Library.Theme do
            ColorsSection:Label(Index):Colorpicker({
                Name = Index,
                Flag = "Theme" .. Index,
                Default = Value,
                Callback = function(Color)
                    Library.Theme[Index] = Color
                    Library:ChangeTheme(Index, Color)
                end,
            })
        end

        local ThemesSection = ThemingSubPage:Section({ Name = "Themes", Side = 2 })
        local ThemeName = ""
        local ThemeSelected

        local ThemesSearchbox = ThemesSection:Searchbox({
            Name = "Saved themes",
            Flag = "ThemesList",
            Items = { },
            Multi = false,
            Callback = function(Value)
                ThemeSelected = Value

                if Value and Value ~= "" then
                    ThemeName = StripJson(Value)
                end
            end,
        })

        ThemesSection:Textbox({
            Name = "Theme name",
            Flag = "ThemeName",
            Default = "",
            Placeholder = "enter a name",
            Callback = function(Value)
                ThemeName = Value
            end,
        })

        local ThemeButtons = ThemesSection:Button()

        ThemeButtons:Add("Save", function()
            if ThemeName ~= "" then
                writefile(Library.Folders.Themes .. "/" .. ThemeName .. ".json", Library:GetConfig())
                Library:RefreshThemesList(ThemesSearchbox)
                Library:Notification("Success", "Saved theme " .. ThemeName, 4)
            end
        end)

        ThemeButtons:Add("Load", function()
            if ThemeSelected then
                local Path = Library.Folders.Themes .. "/" .. ThemeSelected

                if not isfile(Path) and isfile(Path .. ".json") then
                    Path = Path .. ".json"
                end

                if isfile(Path) then
                    local Success, Result = Library:LoadConfig(readfile(Path))
                    Library:Notification(Success and "Success" or "Error", Success and ("Loaded theme " .. ThemeSelected) or tostring(Result), 4)
                end
            end
        end)

        ThemeButtons:Add("Delete", function()
            if ThemeSelected then
                local Path = Library.Folders.Themes .. "/" .. ThemeSelected

                if not isfile(Path) and isfile(Path .. ".json") then
                    Path = Path .. ".json"
                end

                if isfile(Path) then
                    delfile(Path)
                end

                Library:RefreshThemesList(ThemesSearchbox)
            end
        end)

        Library:RefreshThemesList(ThemesSearchbox)

        -- Kept as SubPages[2] on purpose: feature scripts add their cloud config
        -- section to SettingsPage.SubPages[2].
        local ConfigsSubPage = SettingsPage:SubPage({ Name = "Configs", Columns = 2 })
        local ConfigName = ""
        local ConfigSelected
        local ConfigsSection = ConfigsSubPage:Section({ Name = "Profiles", Side = 1 })

        local ConfigsSearchbox = ConfigsSection:Searchbox({
            Name = "Configs",
            Flag = "ConfigsList",
            Items = { },
            Multi = false,
            Callback = function(Value)
                ConfigSelected = Value

                if Value and Value ~= "" then
                    ConfigName = StripJson(Value)
                end
            end,
        })

        ConfigsSection:Textbox({
            Name = "Config name",
            Flag = "ConfigName",
            Default = "",
            Placeholder = "enter a name",
            Callback = function(Value)
                ConfigName = Value
            end,
        })

        local ConfigButtons = ConfigsSection:Button()

        ConfigButtons:Add("Create", function()
            if ConfigName ~= "" then
                if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                    writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                    Library:RefreshConfigsList(ConfigsSearchbox)
                    Library:Notification("Success", "Created config " .. ConfigName, 4)
                else
                    Library:Notification("Error", "Config with that name already exists", 4)
                end
            end
        end)

        ConfigButtons:Add("Delete", function()
            if ConfigSelected then
                Library:DeleteConfig(ConfigSelected)
                Library:RefreshConfigsList(ConfigsSearchbox)
            end
        end)

        ConfigButtons:Add("Load", function()
            if ConfigSelected then
                local Path = Library.Folders.Configs .. "/" .. ConfigSelected

                if not isfile(Path) and isfile(Path .. ".json") then
                    Path = Path .. ".json"
                end

                if isfile(Path) then
                    local Success, Result = Library:LoadConfig(readfile(Path))
                    Library:Notification(Success and "Success" or "Error", Success and ("Loaded config " .. ConfigSelected) or tostring(Result), 4)
                end
            end
        end)

        ConfigButtons:Add("Save", function()
            if ConfigSelected then
                local Path = Library.Folders.Configs .. "/" .. ConfigSelected

                if not isfile(Path) and isfile(Path .. ".json") then
                    Path = Path .. ".json"
                end

                if isfile(Path) then
                    writefile(Path, Library:GetConfig())
                end

                Library:Notification("Success", "Saved config " .. ConfigSelected, 4)
            end
        end)

        ConfigButtons:Add("Refresh", function()
            Library:RefreshConfigsList(ConfigsSearchbox)
        end)

        Library:RefreshConfigsList(ConfigsSearchbox)

        local SettingsSubPage = SettingsPage:SubPage({ Name = "Settings", Columns = 2 })
        local PerformanceSection = SettingsSubPage:Section({ Name = "Performance", Side = 1 })

        PerformanceSection:Slider({
            Name = "Fade time",
            Flag = "FadeTime",
            Default = Library.FadeSpeed or 0.25,
            Min = 0,
            Max = 1,
            Decimals = 0.01,
            Callback = function(Value)
                Library.FadeSpeed = Value
                if Library.CurrentWindow then Library.CurrentWindow.FadeSpeed = Value end
            end,
        })

        PerformanceSection:Slider({
            Name = "Tween time",
            Flag = "TweenTime",
            Default = Library.Tween.Time,
            Min = 0,
            Max = 1,
            Decimals = 0.01,
            Callback = function(Value)
                Library.Tween.Time = Value
            end,
        })

        PerformanceSection:Dropdown({
            Name = "Tween style",
            Flag = "TweenStyle",
            Items = { "Linear", "Sine", "Quad", "Cubic", "Quart", "Quint", "Exponential", "Circular", "Back", "Elastic", "Bounce" },
            Default = "Exponential",
            Callback = function(Value)
                Library.Tween.Style = Enum.EasingStyle[Value]
            end,
        })

        PerformanceSection:Dropdown({
            Name = "Tween direction",
            Flag = "TweenDirection",
            Items = { "In", "Out", "InOut" },
            Default = "Out",
            Callback = function(Value)
                Library.Tween.Direction = Enum.EasingDirection[Value]
            end,
        })

        local MenuSection = SettingsSubPage:Section({ Name = "Menu", Side = 2 })

        MenuSection:Toggle({
            Name = "Watermark",
            Flag = "Watermark",
            Default = true,
            Callback = function(Value)
                if Watermark then
                    Watermark:SetVisibility(Value)
                end
            end,
        })

        MenuSection:Toggle({
            Name = "Keybind List",
            Flag = "KeybindList",
            Default = true,
            Callback = function(Value)
                if KeybindList then
                    KeybindList:SetVisibility(Value)
                end
            end,
        })

        if ESPPreview then
            MenuSection:Toggle({
                Name = "ESP Preview",
                Flag = "ESPPreview",
                Default = true,
                Callback = function(Value)
                    ESPPreviewWanted = Value
                    ESPPreview:SetVisibility(Value and Window.IsOpen == true or false)
                end,
            })
        end

        MenuSection:Toggle({
            Name = "3D UI (EXPERIMENTAL)",
            Flag = "ThreeDUI",
            Default = false,
            Callback = function(Value)
                if Library.OnThreeDUI then
                    Library.OnThreeDUI(Value)
                end
            end,
        })

        MenuSection:Label("Menu keybind"):Keybind({
            Name = "Menu keybind",
            Flag = "MenuKeybind",
            Default = Library.MenuKeybind,
            Mode = "Toggle",
            Callback = function()
                Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
            end,
        })

        MenuSection:Button({ Name = "Notification test", Callback = function()
            Library:Notification("Notification test", 4, Library.Theme.Accent, { "rbxassetid://135757045959142", Color3.fromRGB(149, 255, 139) })
        end })

        MenuSection:Button({ Name = "Unload", Callback = function()
            Library:Unload()
        end })

        if ESPPreview then
            local BaseSetOpen = Window.SetOpen

            Window.SetOpen = function(WindowSelf, Bool, ...)
                local Result = BaseSetOpen(WindowSelf, Bool, ...)
                ESPPreview:SetVisibility((Bool and ESPPreviewWanted) and true or false)
                return Result
            end

            ESPPreview:SetVisibility((Window.IsOpen and ESPPreviewWanted) and true or false)
        end

        return SettingsPage
    end

    -- ==========================================================================
    -- Playerlist (Scoot-compatible API, Thugsense styling)
    -- ==========================================================================

    Library.Pages.Playerlist = function(self, Data)
        Data = Data or { }

        local Playerlist = {
            Window = self.Window,
            Page = self,
            Players = { },
            Player = nil,
            CurrentPlayer = nil,
        }

        local PageFrame = self.Elements["Page"].Instance
        local OldLayout = PageFrame:FindFirstChildOfClass("UIListLayout")

        if OldLayout then
            OldLayout:Destroy()
        end

        local Items = { }

        Items["Playerlist"] = Instances:Create("Frame", {
            Parent = PageFrame,
            Name = "\0",
            Position = UDim2New(0, 0, 0, 0),
            Size = UDim2New(1, 0, 0, 460),
            BorderColor3 = FromRGB(10, 10, 10),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(20, 20, 25)
        })  Items["Playerlist"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

        Instances:Create("UIStroke", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = FromRGB(27, 27, 32),
            Thickness = 1
        }):AddToTheme({Color = "Outline"})

        Items["RealPlayerlist"] = Instances:Create("Frame", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            Position = UDim2New(0, 8, 0, 8),
            Size = UDim2New(1, -16, 1, -86),
            BorderColor3 = FromRGB(10, 10, 10),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(15, 15, 20)
        })  Items["RealPlayerlist"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

        Instances:Create("UIStroke", {
            Parent = Items["RealPlayerlist"].Instance,
            Name = "\0",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = FromRGB(27, 27, 32),
            Thickness = 1
        }):AddToTheme({Color = "Outline"})

        Items["PlayerHolder"] = Instances:Create("ScrollingFrame", {
            Parent = Items["RealPlayerlist"].Instance,
            Name = "\0",
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            CanvasSize = UDim2New(0, 0, 0, 0),
            ScrollBarImageColor3 = FromRGB(235, 157, 255),
            ScrollBarThickness = 2,
            Size = UDim2New(1, -16, 1, -8),
            BackgroundTransparency = 1,
            Position = UDim2New(0, 8, 0, 4),
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["PlayerHolder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

        Instances:Create("UIListLayout", {
            Parent = Items["PlayerHolder"].Instance,
            Name = "\0",
            Padding = UDimNew(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Instances:Create("UIPadding", {
            Parent = Items["PlayerHolder"].Instance,
            Name = "\0",
            PaddingTop = UDimNew(0, 2),
            PaddingBottom = UDimNew(0, 2),
            PaddingRight = UDimNew(0, 12),
            PaddingLeft = UDimNew(0, 2)
        })

        Items["Selected"] = Instances:Create("TextLabel", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "No player selected",
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 10, 1, -64),
            Size = UDim2New(1, -20, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Selected"]:AddToTheme({TextColor3 = "Text"})

        Items["Hint"] = Instances:Create("TextLabel", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = FromRGB(150, 150, 155),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "Click a player to select. Click their status to cycle Neutral / Priority / Friendly.",
            TextSize = 9,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2New(0, 10, 1, -48),
            Size = UDim2New(1, -20, 0, 28),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Hint"]:AddToTheme({TextColor3 = "Placeholder Text"})

        local Order = 0

        local function StatusColor(Status)
            if Status == "Priority" then
                return FromRGB(235, 76, 48)
            elseif Status == "Friendly" then
                return FromRGB(134, 235, 56)
            end

            return Library.Theme.Text
        end

        local function TeamText(Player)
            local Team = Player.Team
            return Team and Team.Name or "None"
        end

        local function SelectPlayer(Player, PlayerData)
            Playerlist.Player = Player
            Playerlist.CurrentPlayer = Player
            getgenv().__plSelected = Player
            Items["Selected"].Instance.Text = Player.DisplayName .. " (@" .. Player.Name .. ")"

            if Data.Callback then
                Library:SafeCall(Data.Callback, Player, PlayerData.PlayerStatus.Instance.Text, TeamText(Player))
            end
        end

        local function CreateRow(Player)
            Order = Order + 1

            local PlayerData = {
                Player = Player,
                Order = Order,
            }

            PlayerData.Row = Instances:Create("TextButton", {
                Parent = Items["PlayerHolder"].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 32),
                BackgroundColor3 = FromRGB(20, 20, 25),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = "",
                LayoutOrder = Order
            })

            PlayerData.Avatar = Instances:Create("ImageLabel", {
                Parent = PlayerData.Row.Instance,
                Name = "\0",
                Position = UDim2New(0, 2, 0, 4),
                Size = UDim2New(0, 24, 0, 24),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            PlayerData.NameLabel = Instances:Create("TextLabel", {
                Parent = PlayerData.Row.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Player.DisplayName .. " (@" .. Player.Name .. ")",
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 32, 0, 1),
                Size = UDim2New(1, -110, 1, -2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  PlayerData.NameLabel:AddToTheme({TextColor3 = "Text"})

            PlayerData.PlayerTeam = Instances:Create("TextLabel", {
                Parent = PlayerData.Row.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(150, 150, 155),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = TeamText(Player),
                TextSize = 8,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 32, 1, -11),
                Size = UDim2New(1, -110, 0, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  PlayerData.PlayerTeam:AddToTheme({TextColor3 = "Placeholder Text"})

            PlayerData.PlayerStatus = Instances:Create("TextButton", {
                Parent = PlayerData.Row.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "Neutral",
                TextSize = 9,
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, -2, 0.5, 0),
                Size = UDim2New(0, 68, 0, 20),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  PlayerData.PlayerStatus:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border", TextColor3 = "Text"})

            PlayerData.PlayerStatus:Connect("MouseButton1Down", function()
                local Current = PlayerData.PlayerStatus.Instance.Text
                local NextStatus = "Neutral"

                if Current == "Neutral" then
                    NextStatus = "Priority"
                elseif Current == "Priority" then
                    NextStatus = "Friendly"
                end

                PlayerData.PlayerStatus.Instance.Text = NextStatus
                PlayerData.PlayerStatus.Instance.TextColor3 = StatusColor(NextStatus)

                SelectPlayer(Player, PlayerData)
            end)

            PlayerData.Row:Connect("MouseButton1Down", function()
                SelectPlayer(Player, PlayerData)
            end)

            PlayerData.TeamConnection = Player:GetPropertyChangedSignal("Team"):Connect(function()
                PlayerData.PlayerTeam.Instance.Text = TeamText(Player)
            end)

            task.spawn(function()
                local Success, Thumbnail = pcall(function()
                    return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)

                if Success and Thumbnail and PlayerData.Avatar.Instance and PlayerData.Avatar.Instance.Parent then
                    PlayerData.Avatar.Instance.Image = Thumbnail
                end
            end)

            Playerlist.Players[Player.Name] = PlayerData
            return PlayerData
        end

        function Playerlist:Add(Player)
            if Player and not Playerlist.Players[Player.Name] then
                return CreateRow(Player)
            end
        end

        function Playerlist:Remove(Name)
            local PlayerData = Playerlist.Players[Name]

            if PlayerData then
                pcall(function()
                    PlayerData.TeamConnection:Disconnect()
                end)
                PlayerData.Row:Clean()
                Playerlist.Players[Name] = nil

                if Playerlist.Player and Playerlist.Player.Name == Name then
                    Playerlist.Player = nil
                    Playerlist.CurrentPlayer = nil
                end
            end
        end

        for _, Player in Players:GetPlayers() do
            CreateRow(Player)
        end

        Library:Connect(Players.PlayerAdded, function(Player)
            CreateRow(Player)
        end)

        Library:Connect(Players.PlayerRemoving, function(Player)
            Playerlist:Remove(Player.Name)
        end)

        return Playerlist
    end


    -- ===== Ported Scoot components: ESP Preview =====
    Library.ESPPreview = function(self, Data)
        Data = Data or { }

        local ESPPreview = {
            Title = Data.Title or Data.Name or "ESP Preview",
            IsOpen = true,

            Player = Data.Player or LocalPlayer,
            UserId = tonumber(Data.UserId or Data.UserID or Data.userid) or nil,

            SpinAngle = math.rad(-25),
            SpinSpeed = Data.SpinSpeed or math.rad(18),
            AutoSpin = Data.AutoSpin ~= false,
            Distance = 10,

            Model = nil,

            ESP = Data.ESP ~= false,
            Settings = Data.Settings,

            Label = Data.Label or "user",
            Tool = Data.Tool or "Revolver",
            DistanceText = Data.DistanceText or "45 studs",

            Health = 1,
            IdleTrack = nil,
            Root = nil,
            RootOrigin = nil,

            -- Which side of the box each element sits on. Draggable in the preview and readable
            -- from outside (ESPPreview.Sides / OnSideChanged) so the preview drives the real ESP.
            Sides = Data.Sides or { Name = "left", Tool = "left", Health = "left" },
            OnSideChanged = Data.OnSideChanged,
        }

        local PreviewPlayer = ESPPreview.Player

        local Items = { } do
            Items["Panel"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Position = Data.Position or UDim2New(0, 24, 0, 24),
                BorderColor3 = FromRGB(12, 12, 12),
                Size = Data.Size or UDim2New(0, 220, 0, 300),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 17, 15)
            })  Items["Panel"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Panel"]:Border("Outline")

            Items["Header"] = Instances:Create("Frame", {
                Parent = Items["Panel"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, 26),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Header"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 235, 235),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = ESPPreview.Title,
                AnchorPoint = Vector2New(0, 0.5),
                Size = UDim2New(1, -16, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 8, 0.5, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                TextSize = 9,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Items["Title"]:TextBorder()

            Items["Liner"] = Instances:Create("Frame", {
                Parent = Items["Panel"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 26),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(202, 243, 255)
            })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["Viewport"] = Instances:Create("ViewportFrame", {
                Parent = Items["Panel"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 35),
                BorderColor3 = FromRGB(12, 12, 12),
                Size = UDim2New(1, -16, 1, -63),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 24, 21),
                Ambient = FromRGB(150, 150, 150),
                LightColor = FromRGB(255, 255, 255),
                LightDirection = Vector3.new(-1, -1, -1)
            })  Items["Viewport"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

            Items["Viewport"]:Border("Outline")

            Items["Hint"] = Instances:Create("TextLabel", {
                Parent = Items["Panel"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(185, 185, 185),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Drag to rotate - double-click to reset",
                AnchorPoint = Vector2New(0.5, 1),
                Size = UDim2New(1, -16, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 1, -6),
                BorderSizePixel = 0,
                TextSize = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hint"]:AddToTheme({TextColor3 = "Placeholder Text"})

            Items["Hint"]:TextBorder()

            Items["WorldModel"] = Instances:Create("WorldModel", {
                Parent = Items["Viewport"].Instance,
                Name = "\0"
            })

            Items["Camera"] = Instances:Create("Camera", {
                Parent = Items["Viewport"].Instance,
                Name = "\0",
                FieldOfView = 70
            })

            Items["Viewport"].Instance.CurrentCamera = Items["Camera"].Instance

            Items["Overlay"] = Instances:Create("Frame", {
                Parent = Items["Panel"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 35),
                Size = UDim2New(1, -16, 1, -63),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 5,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            local function CreateLine(Rotation)
                local Frame = Instances:Create("Frame", {
                    Parent = Items["Overlay"].Instance,
                    Name = "\0",
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 0),
                    Position = UDim2New(0, 0, 0, 0),
                    ZIndex = 6
                })

                local Gradient = Instances:Create("UIGradient", {
                    Parent = Frame.Instance,
                    Name = "\0",
                    Rotation = Rotation,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(0.5, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(255, 255, 255))}
                })

                return Frame, Gradient
            end

            Items["BoxLeft"], Items["BoxLeftGradient"] = CreateLine(90)
            Items["BoxRight"], Items["BoxRightGradient"] = CreateLine(90)
            Items["BoxTop"], Items["BoxTopGradient"] = CreateLine(0)
            Items["BoxBottom"], Items["BoxBottomGradient"] = CreateLine(0)

            Items["HealthFill"] = Instances:Create("Frame", {
                Parent = Items["Overlay"].Instance,
                Name = "\0",
                BackgroundColor3 = FromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Size = UDim2New(0, 0, 0, 0),
                Position = UDim2New(0, 0, 0, 0),
                ZIndex = 7
            })

            Items["HealthFillGradient"] = Instances:Create("UIGradient", {
                Parent = Items["HealthFill"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.5, FromRGB(255, 255, 0)), RGBSequenceKeypoint(1, FromRGB(0, 255, 0))}
            })

            Items["ESPName"] = Instances:Create("TextLabel", {
                Parent = Items["Overlay"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = ESPPreview.Label,
                AnchorPoint = Vector2New(0.5, 1),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 11,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ESPNameStroke"] = Items["ESPName"]:TextBorder()

            Items["ESPTool"] = Instances:Create("TextLabel", {
                Parent = Items["Overlay"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = ESPPreview.Tool,
                AnchorPoint = Vector2New(0.5, 0),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 11,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ESPToolStroke"] = Items["ESPTool"]:TextBorder()

            Items["ESPDistance"] = Instances:Create("TextLabel", {
                Parent = Items["Overlay"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(255, 255, 255),
                Text = ESPPreview.DistanceText,
                AnchorPoint = Vector2New(0.5, 0),
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 11,
                ZIndex = 8,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["ESPDistanceStroke"] = Items["ESPDistance"]:TextBorder()
            Items["ESPDistance"].Instance.Visible = false

            -- Invisible grab handles (so thin things like the healthbar are still easy to grab)
            for _, Key in { "Name", "Tool", "Health" } do
                Items["Grab" .. Key] = Instances:Create("Frame", {
                    Parent = Items["Overlay"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2New(0, 0, 0, 0),
                    Position = UDim2New(0, 0, 0, 0),
                    ZIndex = 20,
                    Active = true,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            -- Outline drawn around whatever element you're grabbing.
            Items["GrabIndicator"] = Instances:Create("Frame", {
                Parent = Items["Overlay"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BackgroundColor3 = FromRGB(255, 255, 255),
                BorderColor3 = FromRGB(202, 243, 255),
                BorderSizePixel = 1,
                Size = UDim2New(0, 0, 0, 0),
                Position = UDim2New(0, 0, 0, 0),
                Visible = false,
                ZIndex = 40
            })

            Instances:Create("UIStroke", {
                Parent = Items["GrabIndicator"].Instance,
                Name = "\0",
                Color = FromRGB(202, 243, 255),
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
        end

        local Camera = Items["Camera"].Instance
        local Viewport = Items["Viewport"].Instance
        local WorldModel = Items["WorldModel"].Instance

        local Mirrored = { }
        local MirrorConnection
        local TargetCharacter
        local DraggingKey = nil

        local function UpdateCamera()
            Camera.CFrame = CFrame.Angles(0, ESPPreview.SpinAngle, 0) * CFrame.new(0, 0, ESPPreview.Distance)
        end

        local function StopMirror()
            if MirrorConnection then
                if MirrorConnection.Connection then
                    MirrorConnection.Connection:Disconnect()
                end

                MirrorConnection = nil
            end

            for _, Track in Mirrored do
                pcall(function()
                    Track:Stop(0)
                end)
            end

            table.clear(Mirrored)
        end

        local function CollectAnimationIds(Character)
            local Ids = { }
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

            if Animator then
                local Success, Tracks = pcall(function()
                    return Animator:GetPlayingAnimationTracks()
                end)

                if Success and Tracks then
                    for _, Track in Tracks do
                        local Animation = Track.Animation

                        if Animation and Animation.AnimationId ~= "" then
                            Ids[Animation.AnimationId] = true
                        end
                    end
                end
            end

            if next(Ids) == nil then
                for _, Descendant in Character:GetDescendants() do
                    if Descendant:IsA("Animation") and Descendant.AnimationId ~= "" then
                        local ParentName = Descendant.Parent and StringLower(Descendant.Parent.Name) or ""

                        if StringFind(StringLower(Descendant.Name), "idle") or StringFind(ParentName, "idle") then
                            Ids[Descendant.AnimationId] = true
                            break
                        end
                    end
                end
            end

            return Ids
        end

        local function PrepareModel(Model, AnchorAll)
            if not Model then
                return nil
            end

            Model.Name = "PreviewModel"

            local ToRemove = { }

            for _, Descendant in Model:GetDescendants() do
                if Descendant:IsA("BaseScript") or Descendant:IsA("Tool") then
                    TableInsert(ToRemove, Descendant)
                elseif Descendant:IsA("BasePart") then
                    Descendant.Anchored = false
                    Descendant.CanCollide = false
                    Descendant.CanQuery = false
                    Descendant.CanTouch = false
                    Descendant.Massless = true

                    -- The local character often has parts hidden by the camera scripts
                    -- (head in first person) or by the game (arms while holding a weapon)
                    -- via LocalTransparencyModifier. Reset it so the preview is fully visible.
                    Descendant.LocalTransparencyModifier = 0

                    if Descendant.Transparency >= 1 then
                        Descendant.Transparency = 0
                    end
                end
            end

            for _, Descendant in ToRemove do
                Descendant:Destroy()
            end

            local Humanoid = Model:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid.WalkSpeed = 0
                Humanoid.JumpPower = 0
                Humanoid.PlatformStand = true
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                Humanoid.BreakJointsOnDeath = false
                Humanoid.RequiresNeck = false
            end

            local Position = Model:GetPivot().Position
            Model:PivotTo(CFrame.new(Position) * CFrame.Angles(0, math.pi, 0))

            local BoundingBox = Model:GetBoundingBox()
            Model:PivotTo(CFrame.new(-BoundingBox.Position) * Model:GetPivot())

            local Root = Model.PrimaryPart or Model:FindFirstChild("HumanoidRootPart") or Model:FindFirstChildWhichIsA("BasePart")

            if AnchorAll then
                -- Fully freeze the model in its standing pose.
                for _, Descendant in Model:GetDescendants() do
                    if Descendant:IsA("BasePart") then
                        Descendant.Anchored = true
                    end
                end
            elseif Root then
                Root.Anchored = true
            end

            if Root then
                ESPPreview.Root = Root
                ESPPreview.RootOrigin = Root.CFrame
            end

            return Model
        end

        local function BuildPreviewModel(Character)
            local OriginalArchivable = Character.Archivable
            Character.Archivable = true
            local Model = Character:Clone()
            Character.Archivable = OriginalArchivable

            return PrepareModel(Model, false)
        end

        local function BuildAvatarModel(UserId)
            local Model

            local Success = pcall(function()
                Model = Players:CreateHumanoidModelFromUserId(UserId)
            end)

            if not Success or not Model then
                Success = pcall(function()
                    Model = Players:GetCharacterAppearanceAsync(UserId)
                end)
            end

            if not Success or not Model then
                return nil
            end

            -- Accessory handles only snap onto the body once the model is parented
            -- into the DataModel (welds resolve). Off-parent they sit at bogus offsets
            -- and blow up the bounding box, which zooms the camera out to a sliver.
            -- Parenting under the camera resolves them without the avatar flashing in world.
            Model.Parent = Workspace.CurrentCamera or Camera
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()

            -- Safety net: if accessory welds still haven't resolved (bounding box
            -- absurdly large), drop the accessories so the body always fits the view.
            local _, BoundSize = Model:GetBoundingBox()

            if BoundSize.Magnitude > 30 then
                for _, Child in ipairs(Model:GetChildren()) do
                    if Child:IsA("Accessory") then
                        Child:Destroy()
                    end
                end
            end

            return PrepareModel(Model, true)
        end

        local function PlayIdle(Model)
            local Humanoid = Model:FindFirstChildOfClass("Humanoid")

            if not Humanoid then
                return
            end

            Humanoid.AutoRotate = false

            local Animator = Humanoid:FindFirstChildOfClass("Animator")

            if not Animator then
                Animator = Instances:Create("Animator", { Parent = Humanoid, Name = "\0" }).Instance
            end

            local IdleId = Humanoid.RigType == Enum.HumanoidRigType.R6 and "rbxassetid://180435571" or "rbxassetid://507766666"

            local Animation = Instance.new("Animation")
            Animation.AnimationId = IdleId

            local Success, Track = pcall(function()
                return Animator:LoadAnimation(Animation)
            end)

            if not Success or not Track then
                return
            end

            Track.Looped = true
            Track.Priority = Enum.AnimationPriority.Idle

            pcall(function()
                Track:Play(0)
            end)

            ESPPreview.IdleTrack = Track

            -- Freeze the avatar on a natural pose so it stands perfectly still
            -- (the idle animation has root motion that would otherwise slide it around).
            task.spawn(function()
                task.wait(0.15)

                if ESPPreview.IdleTrack ~= Track then
                    return
                end

                pcall(function()
                    Track:AdjustSpeed(0)
                    Track.TimePosition = 0.15
                end)
            end)
        end

        local function StartMirror(Character, Model, FallbackIds)
            StopMirror()

            local SourceHumanoid = Character:FindFirstChildOfClass("Humanoid")
            local SourceAnimator = SourceHumanoid and SourceHumanoid:FindFirstChildOfClass("Animator")
            local DestinationHumanoid = Model:FindFirstChildOfClass("Humanoid")
            local DestinationAnimator = DestinationHumanoid and DestinationHumanoid:FindFirstChildOfClass("Animator")

            if DestinationHumanoid and not DestinationAnimator then
                DestinationAnimator = Instances:Create("Animator", { Parent = DestinationHumanoid, Name = "\0" }).Instance
            end

            if not (SourceAnimator and DestinationAnimator) then
                return
            end

            local function PlayTrack(Id, SourceTrack)
                local Animation = Instance.new("Animation")
                Animation.AnimationId = Id

                local Success, Track = pcall(function()
                    return DestinationAnimator:LoadAnimation(Animation)
                end)

                if not Success or not Track then
                    return nil
                end

                Track.Looped = SourceTrack and SourceTrack.Looped or true
                Track.Priority = SourceTrack and SourceTrack.Priority or Enum.AnimationPriority.Idle

                if SourceTrack then
                    pcall(function()
                        Track:AdjustSpeed(SourceTrack.Speed)
                        Track.TimePosition = SourceTrack.TimePosition
                    end)
                end

                pcall(function()
                    Track:Play(0)
                end)

                Mirrored[Id] = Track
                return Track
            end

            local UsedFallback = false

            MirrorConnection = Library:Connect(RunService.Heartbeat, function()
                local Success, Tracks = pcall(function()
                    return SourceAnimator:GetPlayingAnimationTracks()
                end)
                if not Success or not Tracks then
                    return
                end

                local Active = { }

                for _, Track in Tracks do
                    local Animation = Track.Animation

                    if Animation and Animation.AnimationId ~= "" then
                        Active[Animation.AnimationId] = Track
                    end
                end

                if next(Active) == nil then
                    if not UsedFallback and next(FallbackIds) ~= nil then
                        UsedFallback = true

                        for Id in FallbackIds do
                            if not Mirrored[Id] then
                                PlayTrack(Id, nil)
                            end
                        end
                    end

                    return
                end

                UsedFallback = true

                for Id, SourceTrack in Active do
                    local DestinationTrack = Mirrored[Id]

                    if not DestinationTrack then
                        DestinationTrack = PlayTrack(Id, SourceTrack)
                    end

                    if DestinationTrack then
                        pcall(function()
                            DestinationTrack.Priority = SourceTrack.Priority
                            DestinationTrack:AdjustSpeed(SourceTrack.Speed)
                        end)
                    end
                end

                for Id, DestinationTrack in Mirrored do
                    if not Active[Id] then
                        pcall(function()
                            DestinationTrack:Stop(0.1)
                        end)

                        Mirrored[Id] = nil
                    end
                end
            end)
        end

        local function FitCamera(Model)
            if not Model then
                return
            end

            local AbsoluteSize = Viewport.AbsoluteSize

            if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                AbsoluteSize = Vector2New(204, 252)
            end

            local _, Size = Model:GetBoundingBox()
            local Aspect = AbsoluteSize.X / AbsoluteSize.Y
            local FieldOfView = math.rad(Camera.FieldOfView)

            local DistanceForHeight = (Size.Y * 0.5) / math.tan(FieldOfView * 0.5)
            local FieldOfViewX = 2 * math.atan(math.tan(FieldOfView * 0.5) * Aspect)
            local DistanceForWidth = (math.max(Size.X, Size.Z) * 0.5) / math.tan(FieldOfViewX * 0.5)

            ESPPreview.Distance = math.max(DistanceForHeight, DistanceForWidth) * 1.7
            UpdateCamera()
        end

        local UpdateOverlay

        local function LoadCharacter(Character)
            StopMirror()

            WorldModel:ClearAllChildren()
            ESPPreview.Model = nil
            ESPPreview.IdleTrack = nil
            ESPPreview.Root = nil
            ESPPreview.RootOrigin = nil

            if ESPPreview.UserId then
                local AvatarModel = BuildAvatarModel(ESPPreview.UserId)

                if AvatarModel then
                    AvatarModel.Parent = WorldModel

                    -- Accessory welds only snap onto the body once the model sits
                    -- unanchored inside the world model for a frame. We anchored in
                    -- PrepareModel before that, which froze handles at stale offsets,
                    -- so unanchor, let them settle, then recenter and freeze again.
                    for _, Descendant in ipairs(AvatarModel:GetDescendants()) do
                        if Descendant:IsA("BasePart") then
                            Descendant.Anchored = false
                        end
                    end

                    RunService.Heartbeat:Wait()
                    RunService.Heartbeat:Wait()

                    local BoundingBox = AvatarModel:GetBoundingBox()
                    AvatarModel:PivotTo(CFrame.new(-BoundingBox.Position) * AvatarModel:GetPivot())

                    for _, Descendant in ipairs(AvatarModel:GetDescendants()) do
                        if Descendant:IsA("BasePart") then
                            Descendant.Anchored = true
                        end
                    end

                    local Root = AvatarModel.PrimaryPart or AvatarModel:FindFirstChild("HumanoidRootPart")

                    if Root then
                        ESPPreview.Root = Root
                        ESPPreview.RootOrigin = Root.CFrame
                    end

                    ESPPreview.Model = AvatarModel

                    FitCamera(AvatarModel)
                    UpdateCamera()
                    UpdateOverlay()
                end

                return
            end

            if not Character then
                return
            end

            local AnimationIds = CollectAnimationIds(Character)

            local Success, Model = pcall(BuildPreviewModel, Character)

            if not Success or not Model then
                return
            end

            Model.Parent = WorldModel
            ESPPreview.Model = Model

            StartMirror(Character, Model, AnimationIds)

            FitCamera(Model)
            UpdateCamera()
            UpdateOverlay()
        end

        local function Project(WorldPosition)
            local Relative = Camera.CFrame:PointToObjectSpace(WorldPosition)

            if Relative.Z >= 0 then 
                return nil
            end

            local AbsoluteSize = Viewport.AbsoluteSize
            local Aspect = AbsoluteSize.X / math.max(AbsoluteSize.Y, 1)
            local TanY = math.tan(math.rad(Camera.FieldOfView) * 0.5)
            local TanX = TanY * Aspect
            local Depth = -Relative.Z

            local ScreenX = (Relative.X / (Depth * TanX)) * (AbsoluteSize.X * 0.5) + AbsoluteSize.X * 0.5
            local ScreenY = (-Relative.Y / (Depth * TanY)) * (AbsoluteSize.Y * 0.5) + AbsoluteSize.Y * 0.5

            return Vector2New(ScreenX, ScreenY)
        end

        local function GetSettings()
            local Settings = ESPPreview.Settings

            if type(Settings) == "function" then
                local Success, Result = pcall(Settings)
                Settings = Success and Result or nil
            end

            return Settings or { }
        end

                function UpdateOverlay()
            local Model = ESPPreview.Model
            local Overlay = Items["Overlay"].Instance

            local AllItems = { "BoxLeft", "BoxRight", "BoxTop", "BoxBottom", "HealthFill", "ESPName", "ESPTool", "ESPDistance" }

            local function HideAll()
                for _, Key in AllItems do
                    Items[Key].Instance.Visible = false
                end
            end

            if not Model or not Overlay.Visible then
                return
            end

            local Settings = GetSettings()
            local Enabled = Settings.Enabled

            if Enabled == nil then
                Enabled = ESPPreview.ESP
            end

            if not Enabled then
                HideAll()
                return
            end

            local BoxCFrame, BoxSize = Model:GetBoundingBox()
            local Half = BoxSize * 0.5

            local MinX, MinY = math.huge, math.huge
            local MaxX, MaxY = -math.huge, -math.huge

            for _, X in { -1, 1 } do
                for _, Y in { -1, 1 } do
                    for _, Z in { -1, 1 } do
                        local Screen = Project(BoxCFrame * Vector3.new(Half.X * X, Half.Y * Y, Half.Z * Z))

                        if Screen then
                            MinX = math.min(MinX, Screen.X)
                            MinY = math.min(MinY, Screen.Y)
                            MaxX = math.max(MaxX, Screen.X)
                            MaxY = math.max(MaxY, Screen.Y)
                        end
                    end
                end
            end

            if MinX == math.huge then
                HideAll()
                return
            end

            local OverlaySize = Overlay.AbsoluteSize
            local BoxX = math.clamp(MinX - 4, 0, OverlaySize.X)
            local BoxY = math.clamp(MinY - 4, 0, OverlaySize.Y)
            local BoxW = math.clamp(MaxX - MinX + 8, 0, OverlaySize.X - BoxX)
            local BoxH = math.clamp(MaxY - MinY + 8, 0, OverlaySize.Y - BoxY)

            local White = FromRGB(255, 255, 255)

            -- Box (gradient outline)
            local ShowBox = Settings.Boxes
            if ShowBox == nil then ShowBox = true end

            for _, Key in { "BoxLeft", "BoxRight", "BoxTop", "BoxBottom" } do
                Items[Key].Instance.Visible = ShowBox
            end

            if ShowBox then
                Items["BoxLeft"].Instance.Position = UDim2New(0, BoxX, 0, BoxY)
                Items["BoxLeft"].Instance.Size = UDim2New(0, 1, 0, BoxH)
                Items["BoxRight"].Instance.Position = UDim2New(0, BoxX + BoxW - 1, 0, BoxY)
                Items["BoxRight"].Instance.Size = UDim2New(0, 1, 0, BoxH)
                Items["BoxTop"].Instance.Position = UDim2New(0, BoxX, 0, BoxY)
                Items["BoxTop"].Instance.Size = UDim2New(0, BoxW, 0, 1)
                Items["BoxBottom"].Instance.Position = UDim2New(0, BoxX, 0, BoxY + BoxH - 1)
                Items["BoxBottom"].Instance.Size = UDim2New(0, BoxW, 0, 1)

                local Outline = Settings.Outline or { }

                local function OutlineColor(Key)
                    return Outline[Key] or White
                end

                Items["BoxLeftGradient"].Instance.Color = RGBSequence{
                    RGBSequenceKeypoint(0, OutlineColor("Color1")),
                    RGBSequenceKeypoint(0.5, OutlineColor("Color5")),
                    RGBSequenceKeypoint(1, OutlineColor("Color3"))
                }
                Items["BoxRightGradient"].Instance.Color = RGBSequence{
                    RGBSequenceKeypoint(0, OutlineColor("Color2")),
                    RGBSequenceKeypoint(0.5, OutlineColor("Color6")),
                    RGBSequenceKeypoint(1, OutlineColor("Color4"))
                }
                Items["BoxTopGradient"].Instance.Color = RGBSequence{
                    RGBSequenceKeypoint(0, OutlineColor("Color1")),
                    RGBSequenceKeypoint(0.5, OutlineColor("Color2")),
                    RGBSequenceKeypoint(1, OutlineColor("Color1"))
                }
                Items["BoxBottomGradient"].Instance.Color = RGBSequence{
                    RGBSequenceKeypoint(0, OutlineColor("Color3")),
                    RGBSequenceKeypoint(0.5, OutlineColor("Color4")),
                    RGBSequenceKeypoint(1, OutlineColor("Color3"))
                }
            end

            local Sides = ESPPreview.Sides or { }
            local Stack = { left = 0, right = 0 }

            -- Place a label on a box side. Left/right align to the UPPER part and stack downwards.
            local function PlaceText(Inst, Side, Gap)
                Gap = Gap or 2
                if Side == "top" then
                    Inst.AnchorPoint = Vector2New(0.5, 1)
                    Inst.Position = UDim2New(0, BoxX + BoxW * 0.5, 0, BoxY - Gap)
                elseif Side == "bottom" then
                    Inst.AnchorPoint = Vector2New(0.5, 0)
                    Inst.Position = UDim2New(0, BoxX + BoxW * 0.5, 0, BoxY + BoxH + Gap)
                elseif Side == "right" then
                    Inst.AnchorPoint = Vector2New(0, 0)
                    Inst.Position = UDim2New(0, BoxX + BoxW + Gap + 4, 0, BoxY + Stack.right)
                    Stack.right = Stack.right + 18
                else
                    Inst.AnchorPoint = Vector2New(1, 0)
                    Inst.Position = UDim2New(0, BoxX - Gap - 4, 0, BoxY + Stack.left)
                    Stack.left = Stack.left + 18
                end
            end

            -- Healthbar (side-aware, gradient from the ESP health colors, animated 0 -> 100 -> 0)
            local ShowHealth = Settings.Healthbar
            if ShowHealth == nil then ShowHealth = true end

            Items["HealthFill"].Instance.Visible = ShowHealth

            if ShowHealth then
                local Thickness = Settings.HealthThickness or 1

                local Period = 3
                local Phase = (os.clock() % Period) / Period
                local Health = Phase <= 0.5 and Phase * 2 or (2 - Phase * 2)
                ESPPreview.Health = Health

                local Fill = math.clamp(Health, 0, 1)
                local Side = Sides.Health or "left"
                local Inst = Items["HealthFill"].Instance

                if DraggingKey ~= "Health" then
                    if Side == "top" or Side == "bottom" then
                        Inst.AnchorPoint = Vector2New(0, Side == "top" and 1 or 0)
                        Inst.Position = UDim2New(0, BoxX, 0, Side == "top" and (BoxY - 4) or (BoxY + BoxH + 4))
                        Inst.Size = UDim2New(0, BoxW * Fill, 0, Thickness)
                        Items["HealthFillGradient"].Instance.Rotation = 0
                    else
                        Inst.AnchorPoint = Vector2New(Side == "left" and 1 or 0, 1)
                        Inst.Position = UDim2New(0, Side == "left" and (BoxX - 4) or (BoxX + BoxW + 4), 0, BoxY + BoxH)
                        Inst.Size = UDim2New(0, Thickness, 0, BoxH * Fill)
                        Items["HealthFillGradient"].Instance.Rotation = 90
                    end
                end

                local HealthColors = Settings.HealthColors or { }

                Items["HealthFillGradient"].Instance.Color = RGBSequence{
                    RGBSequenceKeypoint(0, HealthColors.Color1 or FromRGB(255, 0, 0)),
                    RGBSequenceKeypoint(0.5, HealthColors.Color2 or FromRGB(255, 255, 0)),
                    RGBSequenceKeypoint(1, HealthColors.Color3 or FromRGB(0, 255, 0))
                }
            end

            -- Names
            local ShowNames = Settings.Names
            if ShowNames == nil then ShowNames = true end

            Items["ESPName"].Instance.Visible = ShowNames

            if ShowNames then
                Items["ESPName"].Instance.Text = Settings.Name or ESPPreview.Label
                Items["ESPName"].Instance.TextSize = Settings.NameSize or 11
                if DraggingKey ~= "Name" then
                    PlaceText(Items["ESPName"].Instance, Sides.Name or "left", 2)
                end
            end

            -- Tools (distance label removed)
            local ShowTools = Settings.Tools
            if ShowTools == nil then ShowTools = true end

            Items["ESPTool"].Instance.Visible = ShowTools

            if ShowTools then
                Items["ESPTool"].Instance.Text = Settings.Tool or ESPPreview.Tool
                Items["ESPTool"].Instance.TextSize = Settings.ToolSize or 11
                if DraggingKey ~= "Tool" then
                    PlaceText(Items["ESPTool"].Instance, Sides.Tool or "left", 3)
                end
            end

            -- Move the invisible grab handles over each element (padded so the thin healthbar is
            -- still easy to grab).
            local function MatchHandle(Handle, Element, PadX, PadY, MinW)
                local Rel = Element.AbsolutePosition - Overlay.AbsolutePosition
                local Size = Element.AbsoluteSize
                Handle.Position = UDim2New(0, Rel.X - PadX, 0, Rel.Y - PadY)
                Handle.Size = UDim2New(0, math.max(Size.X, MinW or 0) + PadX * 2, 0, Size.Y + PadY * 2)
            end

            MatchHandle(Items["GrabName"].Instance, Items["ESPName"].Instance, 2, 1, 0)
            MatchHandle(Items["GrabTool"].Instance, Items["ESPTool"].Instance, 2, 1, 0)
            MatchHandle(Items["GrabHealth"].Instance, Items["HealthFill"].Instance, 5, 2, 8)

            -- Outline whatever element is currently being dragged.
            local Indicator = Items["GrabIndicator"].Instance
            local DraggedHandle = DraggingKey and Items["Grab" .. DraggingKey]
            if DraggedHandle then
                Indicator.Position = DraggedHandle.Instance.Position
                Indicator.Size = DraggedHandle.Instance.Size
                Indicator.Visible = true
            else
                Indicator.Visible = false
            end
        end

        function ESPPreview:SetTitle(Text)
            ESPPreview.Title = Text
            Items["Title"].Instance.Text = Text
        end

        function ESPPreview:SetVisibility(Bool)
            ESPPreview.IsOpen = Bool
            Items["Panel"].Instance.Visible = Bool
        end

        function ESPPreview:SetESP(Bool)
            ESPPreview.ESP = Bool
            Items["Overlay"].Instance.Visible = Bool
        end

        function ESPPreview:GetVisibility()
            return ESPPreview.IsOpen
        end

        function ESPPreview:Refresh()
            if ESPPreview.UserId then
                LoadCharacter(nil)
            elseif TargetCharacter then
                LoadCharacter(TargetCharacter)
            end
        end

        function ESPPreview:Destroy()
            StopMirror()
            Items["Panel"]:Clean()
            ESPPreview.Model = nil
        end

        if ESPPreview.UserId then
            Library:Thread(function()
                if not Items["Panel"].Instance or not Items["Panel"].Instance.Parent then
                    return
                end

                LoadCharacter(nil)
            end)
        else
            Library:Thread(function()
                while true do
                    local Character = PreviewPlayer.Character or PreviewPlayer.CharacterAdded:Wait()
                    Character:WaitForChild("Humanoid", 10)

                    if not Items["Panel"].Instance or not Items["Panel"].Instance.Parent then
                        break
                    end

                    TargetCharacter = Character
                    LoadCharacter(Character)
                    PreviewPlayer.CharacterAdded:Wait()
                end
            end)
        end

        Library:Connect(Viewport:GetPropertyChangedSignal("AbsoluteSize"), function()
            FitCamera(ESPPreview.Model)
        end)

        Library:Connect(RunService.RenderStepped, function(DeltaTime)
            if not ESPPreview.Model then
                return
            end

            if ESPPreview.AutoSpin then
                ESPPreview.SpinAngle += ESPPreview.SpinSpeed * DeltaTime
                UpdateCamera()
            end

            if ESPPreview.Root and ESPPreview.RootOrigin then
                ESPPreview.Root.CFrame = ESPPreview.RootOrigin
            end

            UpdateOverlay()
        end)

        local Dragging = false
        local DragStart
        local DragOrigin

        Items["Header"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                DragOrigin = Items["Panel"].Instance.Position
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not Dragging or not DragStart then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                local Delta = Input.Position - DragStart

                Items["Panel"].Instance.Position = UDim2New(
                    DragOrigin.X.Scale, DragOrigin.X.Offset + Delta.X,
                    DragOrigin.Y.Scale, DragOrigin.Y.Offset + Delta.Y
                )
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)

        local Rotating = false
        local LastMouseX
        local LastClick = 0

        Items["Viewport"]:Connect("InputBegan", function(Input)
            if DraggingKey then
                return
            end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local Now = os.clock()

                if Now - LastClick < 0.35 then
                    ESPPreview.SpinAngle = math.rad(-25)
                    ESPPreview.AutoSpin = true
                    UpdateCamera()
                    LastClick = 0
                    return
                end

                LastClick = Now
                Rotating = true
                ESPPreview.AutoSpin = false
                LastMouseX = Input.Position.X
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                ESPPreview.AutoSpin = true
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not Rotating or not LastMouseX then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                local DeltaX = Input.Position.X - LastMouseX
                LastMouseX = Input.Position.X

                ESPPreview.SpinAngle += DeltaX * math.rad(0.5)
                UpdateCamera()
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Rotating = false
                LastMouseX = nil
            end
        end)

        -- Grab-and-drop the overlay elements (name / tool / healthbar) via their invisible handles,
        -- then snap them to a box side.
        local DragTargets = {
            Name = Items["ESPName"].Instance,
            Tool = Items["ESPTool"].Instance,
            Health = Items["HealthFill"].Instance,
        }
        local DragHandles = {
            Name = Items["GrabName"].Instance,
            Tool = Items["GrabTool"].Instance,
            Health = Items["GrabHealth"].Instance,
        }

        local function OverlayLocal(Position)
            local Absolute = Items["Overlay"].Instance.AbsolutePosition
            return Position.X - Absolute.X, Position.Y - Absolute.Y
        end

        local function SnapSide(LocalX, LocalY)
            local Size = Items["Overlay"].Instance.AbsoluteSize
            local DX, DY = LocalX - Size.X * 0.5, LocalY - Size.Y * 0.5
            if math.abs(DX) >= math.abs(DY) then
                return DX < 0 and "left" or "right"
            end
            return DY < 0 and "top" or "bottom"
        end

        for Key, Handle in DragHandles do
            Handle.Active = true
            Handle.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    DraggingKey = Key
                    ESPPreview.AutoSpin = false
                end
            end)
        end

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not DraggingKey then
                return
            end
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                local X, Y = OverlayLocal(Input.Position)
                local Target = DragTargets[DraggingKey]
                if Target then
                    Target.AnchorPoint = Vector2New(0, 0)
                    Target.Position = UDim2New(0, X, 0, Y)
                end
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if not DraggingKey then
                return
            end
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                local X, Y = OverlayLocal(Input.Position)
                local Side = SnapSide(X, Y)
                ESPPreview.Sides = ESPPreview.Sides or { }
                ESPPreview.Sides[DraggingKey] = Side
                if type(ESPPreview.OnSideChanged) == "function" then
                    pcall(ESPPreview.OnSideChanged, DraggingKey, Side)
                end
                DraggingKey = nil
                UpdateOverlay()
            end
        end)

        ESPPreview.Elements = Items
        Library.ESPPreviewObj = ESPPreview

        return ESPPreview
    end

    -- ===== Ported Scoot components: Spotify =====
    Library.Spotify = function(self, Data)
        Data = Data or { }

        local Spotify = {
            Title = Data.Title or "Spotify",
            Visible = false,
            Bridge = Data.Bridge or "http://127.0.0.1:8889",
            Poll = Data.Poll or 2,
            Icons = Data.Icons or getgenv().SpotifyIcons or { },
            Cfg = { lyrics = true, art = true, progress = true, controls = true, skyLyrics = true, skyWords = false },
        }

        local HS = HttpService
        local httpReq = (syn and syn.request) or (http and http.request) or http_request or request
        local FOLDER = "SpotifyInternal"
        local LYRICS_LINES = 5

        local function rawGet(url)
            if httpReq then
                local ok, res = pcall(httpReq, { Url = url, Method = "GET" })
                if ok and res and res.Body then return res.Body end
            end
            local ok, body = pcall(function() return game:HttpGet(url, true) end)
            if ok then return body end
            return nil
        end

        local function jdecode(s)
            local ok, v = pcall(function() return HS:JSONDecode(s) end)
            if ok then return v end
        end

        local function ensureFolder()
            if type(makefolder) == "function" and not isfolder(FOLDER) then pcall(makefolder, FOLDER) end
        end

        local function loadArt(url)
            if not url or url == "" then return nil end
            if type(getcustomasset) ~= "function" or type(writefile) ~= "function" or type(isfile) ~= "function" then return nil end
            ensureFolder()
            local name = (url:gsub("[^%w]", ""):sub(-48)) .. ((url:match("%.(%w+)$") or "png"):lower():gsub("jpeg", "jpg"))
            local path = FOLDER .. "/" .. name
            if not isfile(path) then
                local b = rawGet(url)
                if not b or #b == 0 then return nil end
                if not pcall(writefile, path, b) then return nil end
            end
            local ok, asset = pcall(getcustomasset, path)
            return ok and asset or nil
        end

        -- bundled transport icons (white silhouettes, base64 PNG) --------------
        local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local ICON_DATA = {
    play = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAADlklEQVR42u2bO2gUURSGv9mZYEARFFERQbQQu1j4aALis7BJIWKjYKGFhTbBN6KdLxS0VFR8VClEBMUowaCiQRM1pEtjoYIoWCiImnlYzBk8LCl2Z2dm752dC9vc2d2Ze85//3PPf844URTRyaNGh4/KAJUBKgNUBkgzXPmta7sBnIzCYA0IOwEBjnyOA0PATpkPAU+ulRYBiZd7gPdqfgg4CLxT2yMoIwIS7y4QQ0zJQjcCr4BTQLfMubagIQ0JhooAE2/PAE6KITbJXGQDSaYxQDBNRIgAH1gJPAGuAAvluzWTw21aBEy3PTy5FgF7gTFgt8wZS5JZGUD/nyNoWATcAB4AK2TOuG2RxgCNhA1PvhcAW4E3wGGgyzSSzHNvOookZwFngJfAOpNIsghy0iS5ChgGLgNzTSDJom5cT5L7gVFgex1Jlj4b1CS5FBiQzzKZc4p+pnZBL0FDICgYFVQUnlfUUsI5q3snJDlHeOEZsLbIkGnCCc1VIbMXeA6cBWYXETJNOaLqkNkFHJKzQ58KmV4nSGI6ZC4H7gG3gcUyl3nINDFJ0SEzFNFlTPKLzPMKk0XRxNsBMF8yzEERZDIjSRtUYU2SW4AR0R4yEV9skcU1SXYTq08jwOZW8wrb6gKaJHuAx8BVYJ7KK0pfGKknyT1ykuzjv1zXEZWhhCR9YImEzDXNGqEMpTFHqVQzmz2u22yASEWBKaAfeKpCZ6kNEKjI8FCgf7EODQ2npTaNUEWDT8BR4E4rFSnPMrgnz3sNOAZ8VSgO0goTNsDdlWcdJ1aXB7OqQ3qGez2URf4iVpXPA79lLsyiCOsZ7nWXuNTWD0zkUX2uGUhyide/AfskAZpQKXCQtThpIsndBE4AH1VThk9O6qxJJDcBHJHYnjyf32A5zjoDaJL7C5wDTgvhJSTnU4A+3w5ZXJPcsJDc23a02NTaSHLfgQPAell8LiSXBwLS7kdf3W9A9vqHvEnOBASEStefBLYBO2TxnuICa6rDThNISbT8SLK11cBd1Wnq0+aR1xbQoe21kNwLE/sIs26R0SLFD9nnvbL4tpBckeeAhORc4D5x9+ik8roP5WyX1+Wqz8AuYoV20lSvt4oAVy1at7ZcJ26i/qIM62P4SGOAn3VV2nHZ649sbJZu9n2BpChxAdgA3AIuAX8UMqJOfGHCKq9nQYI1tXDH1sW3igDHNrhnHQaj6rW5ygCVASoD2D7+AY4KAKdHF3uWAAAAAElFTkSuQmCC",
    pause = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAABdElEQVR42u2azUrFMBBGT2xFcCP+4EbQV3Mr4lZ8BPEx3OlTudTVFVHc3DouzMVQalptlMR8A+G2vfmS9nSSTNtxZkbNtkblJgACIAACIAACIAACIAC1Wpu4PQc0I3U6wH5J//0Trv1hqE145w3YAy6AXb/v/P+r7QfgEngMNKF+BzgH9gf0DXAHXAGvwfF5ZmYpSut/T2zcznqacPt0gv54QP/jknoO2ACWvvTbXh3biug3J+i3c54Eu6DN9ov+uoj+bYJ+mfMy6GbWcYn6KDYOMAVCfwxJobAA5OXCpiFQ+RDQKiAAAqA5oGgAJg8QgLoBuNKGiTxAAMpbBfQw9J8BOM0Bhb8UdRoCei0uD1AcoEmwYgA28wKs9BSZhs/P2wx83h6DPkXf5Azg2bfZRvp6iugXE/QvOQLovGvfAofAwcBdXOcjReY60PT1N8BRoHe9c733dRjJM1CSlNLk5AGKBAVAAARAAARAAARAAARAACL2Dsx2IFSDp07MAAAAAElFTkSuQmCC",
    next = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFI0lEQVR42u2bSagcVRSGv3urMWQQCQkqDlEX8UHEjSISJ+Iq4vBQCCpokCASMCpxwIW40oW4EAeMunLnhCNqNL6IiS4FceFLXtSVS/VpoglCsKuOiz4Xr2V1V9WtW9WPfn2hqB6qT53z1z3/Ge5tIyIs52FZ5mMKwBSAKQBTAKpcY1q8v1mqADjFMkCAJOJ9jd67DdnRAHAJwgXACiCNqKio8ecAa1S2XSoAuGm5ATgAHAK+Bbaqor2GT96o0a8BR1T+XQpI0rlLiEj+SPT8jgxGque+iOzwrjEFvy07enp+TGVm8u94Qr8zImIDZAcd+Q+Md/5ejU717JR9XK+xASA4cN9XmX978kVEXvVASroAwI6Yqr7Pu3MKPAm8on4sgb5rvOlu9XUf2AF8DJwWmXNqk6B4JJhXug/sBD4AVnu+W2dkBZ/1VPZW4Avg3AicExWAvKKzwH7gzABFy2RfAnwFXKzve10BICVPKa/oZuBLYKamomWyU+B8jUJb2gRhlP+mJb91IFyoIFxRQ9GyJkSi918H7ANu82SbrgDIKvzePa0z1B1urqhoVgGIRK9bAbwJPKSyTUwQbIOnlFd0FfAecG8FRbMa+rms8RngWS99tm0BYALlOOLcAzxdomidezgg+8Bu4G1gZWD0aWUGFCn6KPCGTt8iRW2AbMc524A54PQYYdJGIKxhit6uBLa+QNHQTqyTfZWGyZmmESLmDChSdItGiI05RdMIsmdU9pVNQGizBHWKbgIOApcDJz2+aCrbRZ854JbQMNl2De4UPQv4XBXNIt3Xjz7vetGnVpepiyaEU3SNKroNOBExjPvR5ykFvHKYNAUrQ0YFfA1cFrEqyzyFjwFr9bWJ2GFKtNFyt7pbUsY3XbahrGfw2gY5x6jyug/cAXw6JPqMvS1uSirNWMR7rRLvxrIIMY5GZNRcfgQIFykIm/V9spwWRvzosx+4cVjneZJXhhwBrgbeYtDl/l8InvSlMUeMq4BLi4h30gHIPHeYL0rxJxmA1Ft+uwf40Xv/H7KYxOFC32/AnVqV2qJGzDgAkMhJ0DDj54FbgQUvNI49DEqLeYB4md9HwNVqfDLM+K4ByNTwk8CvEXoORT3GhEHfcFbrjSVTC7gy9Q/gOgYrP3Wao1XIToD7GHSPrR7pUiiHnU/+oB2ig5qcxJKdKNndoCVxz6sOK6WMZTtEYvjkHLAd+EVB/yuCCzhgDynZHR5Fdl3PANcS7wEvA9er8afod1kkYPcq2QUZXxUAE+iTFniYQasqq+qTNcjuOeAm4GgZ09d1gSZx2k3LYwy2vXzotcSaLmSknqz71d+tt5eBWACEPnln/BH1ye9Cp2XFzK7n9f8YJwC+T36mCi6WGG+6JrsQDrA1ye4lJbvFCj5pKgLrjP8EuCa28U2jQOr54IPALq8dnVa8b9nqcQ94QTs6vzchuxAXsBWm5VGN73s9n8wibMxwZPcA8GIMsqsKgPFIxZYYv6A+OR8wLU0FstvOoL0dhexCZoCMILt9quBioE+apmVsFxyQeMj7ZLdH8+7FBj5pcrL7BWVs68YP2yXmkpXDuc2MFnhEKy4CMzv35L9R2YnK6QHP58rY1o0ftlfYbYE9T0QOiMgJEVkQkdmG+4TdFlwjIqeKyOsiclxEfhKRnd69O9snLCKFi6P5sQH4uepiY81xNvAncDy30tvZGAWAyZFhTONdWyxrQXY0AIrW4NtaMR7bvzfN9J+jTP81NgVgCsAUgOU7/gFvucuMx/bAawAAAABJRU5ErkJggg==",
    prev = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFDUlEQVR42u2bS4gdVRCGv9O3MZgYHygqojEuomBwY0CJjzCuFGOiAUHBhbiQQIyIMbgQV27EhUbF18YHgsHXGI1ExyhG1yIKJpmoqwhufEUxCGJ3l4upo8Vl7u3Tfc/pO+TeA033zKWrq/6u89epOtVORJjkkTHhYwrAFIApAFMAxjlcQh2CZI8TgB4gQKV6uESyGSY7G6PnlcApwPmqqEQ0vgSWARfp/2SpAOBUwQq4EzgEHAFeUzDciJ6Qq/HXA1+p/APAqoFTQkS6OjIRcXr9iPw/Kj0/pL/lLWQ7Eenp9V0iUqjMUs9v62+9/nu7Mr5njHtJlSpUwX/0es8gJQOMz/T6YQOql1+IyLcGfGfvzzsiuxI4DXhD3bNQd/Xzs9fS9TNDdC8AW/VZmZlq/vluMS5IDUCuxl4AvAtc3me8HVVLYFcAu4HNQ2TLICLMOzD+MmAvsHqIgjSMAl72ucA7wPoA2dJlFPAKzigLr9a3NQzwqqHsS4DPA4zvly0pAXBGwduAOeBMNb5Xc680MP4qNf7iAOPR5ydfB/gYXgA7gNd1MVLVGC8BHmCBvQX4GDgnwKtqvSsWAJlZeu4CHjeru9BnVAHAbtM5vzwA2CDvyiOGuZOBV4FbVdmmoc0NCXMCPAY8aIDKWnqpxATAu+XZwCxwTeCcDPFGu6Z/Bbi9JbDJPMCy8Xt6LkaQKYvIPgt4S6NJG9mSKh32Cl6tbDyq8Zapvew1Knsmguxo2aBl4y3A/oZsXKdkBvwNXAl8BlwawfhoHuDTSc/Gsy3YOGRdvwX4BDgvErBRAPBhrgQeBZ41y8tYofS4RpBZrQ3EAnb4Ww3YGbJs/CJwh8m4YpSxROUcA07X6yoSsH4F+gVwRZswaNn4TeC6BHPSg3hGHxd0MvIA49cAe4C1iQlJ6gqYXXJAT41dr2yc2ngi1AOjAeArtjdp0tEJG49r5ANC0SotXy0PTGU5UXaGvAuuU+OLE9n4xQDwRHTQuH01SQD4+Ps9cLf5u5ykzVFv9MvARuBXExUmZne4UvefA67VKZEnBkEi7g9GyQU8Ac4rCO+bvTdJuA6QpdQf4EPg7yxsPOwyUaGKvAL8WVNh1yXxZoEJRabHDmC7Wa/HIEdv7KfADcAfJu1eMh0ivjCZayqcghxX6LJ7BviuA85pXBARkw/MARtY2H8fVVE/Bf5Sfb5WztlvZEukjDNKTdCDcFgV3ReJHCs9TgJ+Am4EnlfZkooX2ubdPkIcAzYBT0Ykx9LkJNuABwwHlbHefIydIVsVuj8yOVYmLX8CuFkjUVvOcYOqw1kERVORo5h8ZK9yzpGWnJO0SywWOboazvlGOeejFuTYSZucJccNwAcNFXUBnPOLkuNzDckx66pNziv6m1aUnjZFl6rG8CyQcwS4R3nHjco5KaqvlhzvA+4NJMesATnmGnk2aSSq45ys60ZJS47PqDfUkaNrwTn7dLrN13BONug5WeL01iv6YUBa7VpyzkEFYW4I54y1VdYr2p9WF8ZTypYlcUuOGzUUW3KUuqJuVzswRV9a/ZQq6hsae8CXLT2hNHZsB3aalaPvTT7c10U+ll5h3y/s21q3ishREflTRHaLyEptY3UtZdt+4c0iMi8ix0XkgIhc2NdS+9/hxvDZnDNFj5XAqcCPxG/NXcZC78IPo+4Ok7iH2G6/SwLZbhgRujF/OOkSlsCCZLvpl6NMvxqbAjAFYArA5I5/AYkiw0ux2ZI+AAAAAElFTkSuQmCC",
}

        local function b64decode(data)
            local out, buffer, bits = { }, 0, 0
            for i = 1, #data do
                local v = string.find(B64, data:sub(i, i), 1, true)
                if v then
                    buffer = buffer * 64 + (v - 1)
                    bits = bits + 6
                    if bits >= 8 then
                        bits = bits - 8
                        out[#out + 1] = string.char(math.floor(buffer / 2 ^ bits) % 256)
                        buffer = buffer % (2 ^ bits)
                    end
                end
            end
            return table.concat(out)
        end

        local function ensureIcons()
            local out = { }
            if type(writefile) ~= "function" or type(getcustomasset) ~= "function" or type(isfile) ~= "function" then
                return out
            end
            ensureFolder()
            for name, b64 in pairs(ICON_DATA) do
                local path = FOLDER .. "/icon_" .. name .. ".png"
                if not isfile(path) then pcall(writefile, path, b64decode(b64)) end
                local ok, asset = pcall(getcustomasset, path)
                if ok and asset then out[name] = asset end
            end
            return out
        end

        local ICONS = ensureIcons()
        for k, v in pairs(Spotify.Icons) do ICONS[k] = v end

        local function parseLRC(lrc)
            local out = {}
            for line in lrc:gmatch("[^\r\n]+") do
                local times = {}
                for mm, ss in line:gmatch("%[(%d+):(%d+%.?%d*)%]") do
                    times[#times + 1] = tonumber(mm) * 60 + tonumber(ss)
                end
                local text = (line:gsub("%[%d+:%d+%.?%d*%]", ""):gsub("^%s+", ""):gsub("%s+$", ""))
                for _, tm in ipairs(times) do out[#out + 1] = { time = tm, text = text } end
            end
            table.sort(out, function(a, b) return a.time < b.time end)
            return out
        end

        local function splitLines(s)
            local out = {}
            for line in s:gmatch("[^\r\n]+") do out[#out + 1] = { time = 0, text = line } end
            return out
        end

        local function fetchLyrics(title, artist, dur)
            if not title or title == "" then return nil end
            local d = jdecode(rawGet("https://lrclib.net/api/get?artist_name=" .. HS:UrlEncode(artist or "")
                .. "&track_name=" .. HS:UrlEncode(title) .. "&duration=" .. tostring(math.floor(dur or 0))) or "")
            if d and (d.syncedLyrics or d.plainLyrics) then return d end
            local list = jdecode(rawGet("https://lrclib.net/api/search?artist_name=" .. HS:UrlEncode(artist or "")
                .. "&track_name=" .. HS:UrlEncode(title)) or "")
            if type(list) == "table" and #list > 0 then
                local best
                for _, it in ipairs(list) do
                    if it.syncedLyrics and (not best or math.abs((it.duration or 0) - (dur or 0)) < math.abs((best.duration or 0) - (dur or 0))) then
                        best = it
                    end
                end
                return best or list[1]
            end
            return nil
        end

        local Font = (Library.Fonts and Library.Fonts["Prompt"]) or Library.Font
        local Items = { }

        -- own 2D overlay, independent of the menu / 3D UI ---------------------
        local guiParent = (type(gethui) == "function" and (pcall(gethui) and gethui()))
            or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui"))
            or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        Items["Screen"] = Instances:Create("ScreenGui", {
            Parent = guiParent, Name = "SpotifyOverlay", ResetOnSpawn = false,
            IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 999,
        })

        -- panel + header ------------------------------------------------------
        Items["Panel"] = Instances:Create("Frame", {
            Parent = Items["Screen"].Instance, Name = "\0",
            Position = Data.Position or UDim2New(0, 24, 0, 24), Size = UDim2New(0, 282, 0, 262),
            BorderColor3 = FromRGB(12, 12, 12), BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(14, 17, 15), Visible = false,
        })  Items["Panel"]:AddToTheme({ BackgroundColor3 = "Background", BorderColor3 = "Border" })
        Items["Panel"]:Border("Outline")
        Items["Panel"]:MakeDraggable()

        Items["Header"] = Instances:Create("Frame", {
            Parent = Items["Panel"].Instance, Name = "\0",
            Size = UDim2New(1, 0, 0, 26), BackgroundTransparency = 1, BorderSizePixel = 0,
        })

        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["Header"].Instance, Name = "\0", FontFace = Font,
            TextColor3 = FromRGB(235, 235, 235), Text = Spotify.Title, TextSize = 9,
            AnchorPoint = Vector2New(0, 0.5), Position = UDim2New(0, 8, 0.5, 0),
            Size = UDim2New(1, -16, 0, 15), BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
        })  Items["Title"]:AddToTheme({ TextColor3 = "Text" })
        Items["Title"]:TextBorder()

        Items["Liner"] = Instances:Create("Frame", {
            Parent = Items["Panel"].Instance, Name = "\0",
            Position = UDim2New(0, 0, 0, 26), Size = UDim2New(1, 0, 0, 1),
            BorderSizePixel = 0, BackgroundColor3 = FromRGB(202, 243, 255),
        })  Items["Liner"]:AddToTheme({ BackgroundColor3 = "Accent" })

        -- art + meta ----------------------------------------------------------
        Items["Art"] = Instances:Create("ImageLabel", {
            Parent = Items["Panel"].Instance, Name = "\0",
            Position = UDim2New(0, 8, 0, 35), Size = UDim2New(0, 86, 0, 86),
            BackgroundColor3 = FromRGB(20, 24, 21), BorderSizePixel = 0, Image = "",
            ScaleType = Enum.ScaleType.Crop, Visible = false,
        })  Items["Art"]:AddToTheme({ BackgroundColor3 = "Inline" })
        Items["Art"]:Border("Outline")

        Items["Track"] = Instances:Create("TextLabel", {
            Parent = Items["Panel"].Instance, Name = "\0", FontFace = Font,
            TextColor3 = FromRGB(235, 235, 235), Text = "Connecting...", TextSize = 11,
            Position = UDim2New(0, 104, 0, 36), Size = UDim2New(0, 170, 0, 17),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0,
        })  Items["Track"]:AddToTheme({ TextColor3 = "Text" })
        Items["Track"]:TextBorder()

        Items["Artist"] = Instances:Create("TextLabel", {
            Parent = Items["Panel"].Instance, Name = "\0", FontFace = Font,
            TextColor3 = FromRGB(235, 235, 235), TextTransparency = 0.45,
            Text = "start the launcher", TextSize = 9,
            Position = UDim2New(0, 104, 0, 54), Size = UDim2New(0, 170, 0, 14),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0,
        })  Items["Artist"]:AddToTheme({ TextColor3 = "Text" })
        Items["Artist"]:TextBorder()

        Items["BarBg"] = Instances:Create("Frame", {
            Parent = Items["Panel"].Instance, Name = "\0",
            Position = UDim2New(0, 104, 0, 74), Size = UDim2New(0, 170, 0, 3),
            BackgroundColor3 = FromRGB(42, 49, 45), BorderSizePixel = 0, Visible = false,
        })  Items["BarBg"]:AddToTheme({ BackgroundColor3 = "Outline" })

        Items["BarFill"] = Instances:Create("Frame", {
            Parent = Items["BarBg"].Instance, Name = "\0", Size = UDim2New(0, 0, 1, 0),
            BorderSizePixel = 0, BackgroundColor3 = FromRGB(202, 243, 255),
        })  Items["BarFill"]:AddToTheme({ BackgroundColor3 = "Accent" })

        for _, key in ipairs({ "Elapsed", "Remaining" }) do
            Items[key] = Instances:Create("TextLabel", {
                Parent = Items["Panel"].Instance, Name = "\0", FontFace = Font,
                TextColor3 = FromRGB(185, 185, 185), TextSize = 8, Text = "0:00",
                Position = UDim2New(0, 104, 0, 79), Size = UDim2New(0, 85, 0, 12),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0, Visible = false,
            })  Items[key]:AddToTheme({ TextColor3 = "Placeholder Text" })
            Items[key]:TextBorder()
        end

        -- transport -----------------------------------------------------------
        local function transport(iconKey, glyph, x)
            local container = Instances:Create("Frame", {
                Parent = Items["Panel"].Instance, Name = "\0",
                Position = UDim2New(0, x, 0, 96), Size = UDim2New(0, 42, 0, 20),
                BorderSizePixel = 0, BackgroundColor3 = FromRGB(30, 36, 31), Visible = false,
            })  container:AddToTheme({ BackgroundColor3 = "Element" })
            container:Border("Outline")

            local btn = Instances:Create("TextButton", {
                Parent = container.Instance, Name = "\0", FontFace = Font,
                Size = UDim2New(1, 0, 1, 0), BackgroundTransparency = 1, Text = glyph,
                TextColor3 = FromRGB(235, 235, 235), TextSize = 9, AutoButtonColor = false,
            })  btn:AddToTheme({ TextColor3 = "Text" })

            local icon
            if ICONS[iconKey] then
                btn.Instance.Text = ""
                icon = Instances:Create("ImageLabel", {
                    Parent = container.Instance, Name = "\0",
                    Size = UDim2New(0, 13, 0, 13), Position = UDim2New(0.5, -7, 0.5, -7),
                    BackgroundTransparency = 1, Image = ICONS[iconKey], ImageColor3 = FromRGB(235, 235, 235),
                })  icon:AddToTheme({ ImageColor3 = "Text" })
            end

            container:OnHover(function()
                container:ChangeItemTheme({ BackgroundColor3 = "Hovered Element" })
                container:Tween(nil, { BackgroundColor3 = Library.Theme["Hovered Element"] })
            end)
            container:OnHoverLeave(function()
                container:ChangeItemTheme({ BackgroundColor3 = "Element" })
                container:Tween(nil, { BackgroundColor3 = Library.Theme.Element })
            end)
            return container, btn, icon
        end

        Items["CtrlPrev"], Items["BtnPrev"], Items["PrevIcon"] = transport("prev", "|<", 40)
        Items["CtrlPlay"], Items["BtnPlay"], Items["PlayIcon"] = transport("play", ">", 88)
        Items["CtrlNext"], Items["BtnNext"], Items["NextIcon"] = transport("next", ">|", 136)

        Items["Divider"] = Instances:Create("Frame", {
            Parent = Items["Panel"].Instance, Name = "\0",
            Position = UDim2New(0, 8, 0, 130), Size = UDim2New(1, -16, 0, 1),
            BorderSizePixel = 0, BackgroundColor3 = FromRGB(42, 49, 45), Visible = false,
        })  Items["Divider"]:AddToTheme({ BackgroundColor3 = "Outline" })

        Items["Lyrics"] = { }
        for i = 1, LYRICS_LINES do
            Items["Lyrics"][i] = Instances:Create("TextLabel", {
                Parent = Items["Panel"].Instance, Name = "\0", FontFace = Font,
                TextColor3 = FromRGB(235, 235, 235), TextTransparency = 0.45, Text = "", TextSize = 9,
                Position = UDim2New(0, 10, 0, 140 + (i - 1) * 22), Size = UDim2New(1, -20, 0, 22),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Center,
                TextTruncate = Enum.TextTruncate.AtEnd, BorderSizePixel = 0, Visible = false,
            })              Items["Lyrics"][i]:AddToTheme({ TextColor3 = "Text" })
            Items["Lyrics"][i]:TextBorder()
        end

        -- sky lyrics: the words are written far out in the sky, not attached to
        -- the player. A local anchor part is parked high in front of the camera
        -- and the billboard floats there, gently bobbing.
        local SKY_LINES = 3
        local SkyLabels = { }
        local skyRows = { }
        local skyAlpha = { }
        local skyOffset = { }
        local skyFontName = nil
        local skyKey = nil
        local skyPos = nil
        local SkyWordLabels = { }
        local skyWordLine = nil
        local skyWordCount = 0
        local skyWordSize = 36
        local skySizerText = nil

        Items["SkyBoard"] = Instances:Create("Part", {
            Parent = Workspace,
            Name = "SpotifySkyBoard",
            Anchored = true, CanCollide = false, CanTouch = false, CanQuery = false,
            CastShadow = false, Transparency = 1,
            Size = Vector3.new(1800, 450, 1),
            CFrame = CFrame.new(0, -5000, 0),
        })

        Items["Sky"] = Instances:Create("SurfaceGui", {
            Parent = Items["SkyBoard"].Instance,
            Name = "SpotifySkyLyrics",
            Face = Enum.NormalId.Front,
            SizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
            CanvasSize = Vector2.new(2048, 512),
            AlwaysOnTop = false,
            LightInfluence = 0,
            Enabled = false,
        })

        for i = 1, SKY_LINES do
            local isMiddle = (i == math.floor(SKY_LINES / 2) + 1)
            local rowTop = ({ 0, 0.30, 0.74 })[i]
            local rowHeight = isMiddle and 0.40 or 0.24
            skyRows[i] = rowTop
            skyAlpha[i] = 1
            skyOffset[i] = 0
            SkyLabels[i] = Instances:Create("TextLabel", {
                Parent = Items["Sky"].Instance, Name = "\0",
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Position = UDim2New(0, 0, rowTop, 0),
                Size = UDim2New(1, 0, rowHeight, 0),
                FontFace = Library.Font, Text = "",
                TextScaled = true,
                TextColor3 = FromRGB(235, 235, 235),
                TextTransparency = 0.55,
                TextStrokeColor3 = FromRGB(0, 0, 0),
                TextStrokeTransparency = isMiddle and 0.25 or 0.55,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
            })  SkyLabels[i]:AddToTheme({ TextColor3 = "Text", TextStrokeColor3 = "Text Stroke" })
        end

        -- Invisible full-line label: used only to measure the line so the
        -- word-by-word labels all share one stable text size (no rescaling).
        Items["SkySizer"] = Instances:Create("TextLabel", {
            Parent = Items["Sky"].Instance, Name = "\0",
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2New(0, 0, 0.30, 0), Size = UDim2New(1, 0, 0.40, 0),
            FontFace = Library.Font, Text = "", TextScaled = true,
            TextTransparency = 1, TextStrokeTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
        })

        Items["SkyWords"] = Instances:Create("Frame", {
            Parent = Items["Sky"].Instance, Name = "\0",
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2New(0, 0, 0.30, 0), Size = UDim2New(1, 0, 0.40, 0),
            Visible = false,
        })

        Instances:Create("UIListLayout", {
            Parent = Items["SkyWords"].Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDimNew(0, 8),
        })

        local function clearSkyWords()
            for i = #SkyWordLabels, 1, -1 do
                local lbl = SkyWordLabels[i]
                if lbl then lbl:Clean() end
                SkyWordLabels[i] = nil
            end
            skyWordCount = 0
        end

        local function styleSkyWord(lbl, current, animate)
            if not lbl or not lbl.Instance then return end
            local inst = lbl.Instance
            local color = current and Library.Theme.Accent or Library.Theme.Text
            local transparency = current and 0 or 0.16
            local stroke = current and 0.45 or 0.7

            if animate then
                TweenService:Create(inst, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = color,
                    TextTransparency = transparency,
                    TextStrokeTransparency = stroke,
                }):Play()
            else
                inst.TextColor3 = color
                inst.TextTransparency = transparency
                inst.TextStrokeTransparency = stroke
            end
        end

        local function newSkyWord(index, word, size, current)
            local lbl = Instances:Create("TextLabel", {
                Parent = Items["SkyWords"].Instance, Name = "\0",
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2New(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextScaled = false, TextSize = size,
                FontFace = Library.Font,
                Text = word,
                TextColor3 = current and Library.Theme.Accent or Library.Theme.Text,
                TextTransparency = 1,
                TextStrokeColor3 = FromRGB(0, 0, 0),
                TextStrokeTransparency = current and 0.45 or 0.7,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                LayoutOrder = index,
            })
            SkyWordLabels[index] = lbl
            return lbl
        end

        -- layout --------------------------------------------------------------
        local function layout()
            local cfg = Spotify.Cfg
            local W = 282
            local y = 35

            Items["Art"].Instance.Visible = cfg.art and Spotify.Visible
            local metaX = cfg.art and 104 or 8
            local metaW = W - metaX - 8

            Items["Track"].Instance.Position = UDim2New(0, metaX, 0, y + 1)
            Items["Track"].Instance.Size = UDim2New(0, metaW, 0, 17)
            Items["Artist"].Instance.Position = UDim2New(0, metaX, 0, y + 19)
            Items["Artist"].Instance.Size = UDim2New(0, metaW, 0, 14)

            Items["BarBg"].Instance.Visible = cfg.progress and Spotify.Visible
            Items["Elapsed"].Instance.Visible = cfg.progress and Spotify.Visible
            Items["Remaining"].Instance.Visible = cfg.progress and Spotify.Visible

            if cfg.progress then
                local by = y + 40
                Items["BarBg"].Instance.Position = UDim2New(0, metaX, 0, by)
                Items["BarBg"].Instance.Size = UDim2New(0, metaW, 0, 3)
                Items["Elapsed"].Instance.Position = UDim2New(0, metaX, 0, by + 5)
                Items["Remaining"].Instance.Position = UDim2New(0, metaX + metaW, 0, by + 5)
                Items["Remaining"].Instance.AnchorPoint = Vector2New(1, 0)
                Items["Remaining"].Instance.TextXAlignment = Enum.TextXAlignment.Right
            end

            local topH = cfg.art and 86 or (17 + 2 + 14 + (cfg.progress and (4 + 3 + 5 + 12) or 0))
            y = y + topH

            local ctrlVisible = cfg.controls and Spotify.Visible
            for _, k in ipairs({ "CtrlPrev", "CtrlPlay", "CtrlNext" }) do
                Items[k].Instance.Visible = ctrlVisible
            end
            Items["BtnPrev"].Instance.Visible = ctrlVisible
            Items["BtnPlay"].Instance.Visible = ctrlVisible
            Items["BtnNext"].Instance.Visible = ctrlVisible
            if cfg.controls then
                y = y + 10
                local total = 42 * 3 + 12
                local bx = 8 + math.floor((W - 16 - total) / 2)
                Items["CtrlPrev"].Instance.Position = UDim2New(0, bx, 0, y)
                Items["CtrlPlay"].Instance.Position = UDim2New(0, bx + 48, 0, y)
                Items["CtrlNext"].Instance.Position = UDim2New(0, bx + 96, 0, y)
                y = y + 20
            end

            Items["Divider"].Instance.Visible = cfg.lyrics and Spotify.Visible
            if cfg.lyrics then
                y = y + 8
                Items["Divider"].Instance.Position = UDim2New(0, 8, 0, y)
                y = y + 8
                for i = 1, LYRICS_LINES do
                    Items["Lyrics"][i].Instance.Visible = Spotify.Visible
                    Items["Lyrics"][i].Instance.Position = UDim2New(0, 10, 0, y + (i - 1) * 22)
                end
                y = y + LYRICS_LINES * 22
            else
                for i = 1, LYRICS_LINES do Items["Lyrics"][i].Instance.Visible = false end
            end

            Items["Panel"].Instance.Size = UDim2New(0, W, 0, y + 8)
        end

        Spotify.Layout = layout

        function Spotify:Apply(cfg)
            if cfg then
                for k, v in pairs(cfg) do Spotify.Cfg[k] = v end
            end
            layout()
            if Items["Sky"] then
                Items["Sky"].Instance.Enabled = Spotify.Visible and Spotify.Cfg.skyLyrics or false
            end
        end

        -- state + render ------------------------------------------------------
        local state = { title = "", artist = "", pos = 0, dur = 1, playing = false, art = nil, at = 0, key = nil, lyrics = {}, synced = false, lyricStatus = nil }

        local function fmt(t)
            t = math.max(t or 0, 0)
            return string.format("%d:%02d", math.floor(t / 60), math.floor(t % 60))
        end

        local function currentIndex(t)
            local idx = 0
            for i, l in ipairs(state.lyrics) do
                if l.time <= t + 0.15 then idx = i else break end
            end
            return idx
        end

        local function requestLyrics(d)
            local data = fetchLyrics(d.title, d.artist, d.dur)
            if data and data.syncedLyrics then
                state.lyrics, state.synced, state.lyricStatus = parseLRC(data.syncedLyrics), true, nil
            elseif data and data.plainLyrics then
                state.lyrics, state.synced, state.lyricStatus = splitLines(data.plainLyrics), false, nil
            else
                state.lyrics, state.synced, state.lyricStatus = {}, false, "No lyrics found"
            end
        end

        local function poll()
            local d = jdecode(rawGet(Spotify.Bridge .. "/now") or "")
            if not d or not d.has then
                state.title, state.artist, state.playing = "Bridge offline", "start the launcher", false
                state.pos, state.dur, state.lyrics, state.lyricStatus = 0, 0, {}, nil
                state.at = tick()
                return
            end
            state.title = d.title or ""
            state.artist = d.artist or ""
            state.pos = d.pos or 0
            state.dur = math.max(d.dur or 0, 0.001)
            state.playing = d.playing and true or false
            state.at = tick()
            if d.art and d.art ~= "" and d.art ~= state.art then
                state.art = d.art
                local a = loadArt(d.art)
                if a then Items["Art"].Instance.Image = a end
            end
            if d.key and d.key ~= state.key then
                state.key = d.key
                state.lyrics, state.synced, state.lyricStatus = {}, false, "Loading lyrics..."
                Library:Thread(function() requestLyrics(d) end)
            end
        end

        local function control(action)
            rawGet(Spotify.Bridge .. "/" .. action)
            task.wait(0.15)
            poll()
        end

        Items["BtnNext"]:Connect("MouseButton1Click", function() control("next") end)
        Items["BtnPrev"]:Connect("MouseButton1Click", function() control("prev") end)
        Items["BtnPlay"]:Connect("MouseButton1Click", function() control("toggle") end)

        local function getPos()
            local p = state.pos
            if state.playing then p = p + (tick() - state.at) end
            return math.clamp(p, 0, state.dur)
        end

        local function drawLyrics(dpos)
            if not Spotify.Cfg.lyrics then return end
            if #state.lyrics == 0 then
                for i = 1, LYRICS_LINES do
                    local lbl = Items["Lyrics"][i].Instance
                    lbl.Text = (i == math.floor(LYRICS_LINES / 2) + 1) and (state.lyricStatus or "") or ""
                    lbl.TextColor3, lbl.TextTransparency = Library.Theme["Placeholder Text"], 0
                end
                return
            end
            if state.synced then
                local idx = math.max(currentIndex(dpos), 1)
                local start = idx - math.floor(LYRICS_LINES / 2)
                for i = 1, LYRICS_LINES do
                    local li = start + i - 1
                    local l = state.lyrics[li]
                    local lbl = Items["Lyrics"][i].Instance
                    if l then
                        lbl.Text = (l.text ~= "" and l.text) or "\u{266A}"
                        lbl.TextColor3 = (li == idx) and Library.Theme.Accent or Library.Theme.Text
                        lbl.TextTransparency = (li == idx) and 0 or 0.45
                    else
                        lbl.Text = ""
                    end
                end
            else
                for i = 1, LYRICS_LINES do
                    local l = state.lyrics[i]
                    local lbl = Items["Lyrics"][i].Instance
                    lbl.Text = l and l.text or ""
                    lbl.TextColor3, lbl.TextTransparency = Library.Theme.Text, 0.45
                end
            end
        end

        local function drawSky(dpos, dt)
            local sky = Items["Sky"] and Items["Sky"].Instance
            local board = Items["SkyBoard"] and Items["SkyBoard"].Instance
            if not sky or not board then return end

            local camera = Workspace.CurrentCamera
            local char = LocalPlayer and LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not (Spotify.Visible and Spotify.Cfg.skyLyrics and camera and root) then
                sky.Enabled = false
                return
            end

            sky.Enabled = true
            dt = dt or 0
            local t = os.clock()

            -- Placed once, far out in the sky, and then never moved again.
            -- Walking, turning, or changing camera angle does not affect it.
            if not skyPos then
                local look = camera.CFrame.LookVector
                local flat = Vector3.new(look.X, 0, look.Z)
                if flat.Magnitude < 0.001 then
                    flat = Vector3.new(0, 0, -1)
                end
                flat = flat.Unit

                local base = root.Position
                skyPos = base
                    + flat * 1800
                    + Vector3.new(0, 900, 0)

                -- Face the board at the spot it was created from, then leave it
                -- alone forever. It is a flat 2D plane hanging in the sky.
                board.CFrame = CFrame.lookAt(
                    skyPos,
                    Vector3.new(base.X, skyPos.Y, base.Z)
                )
            end

            local mid = math.floor(SKY_LINES / 2) + 1
            local fontChanged = skyFontName ~= Library.FontName
            if fontChanged then
                skyFontName = Library.FontName
                for i = 1, SKY_LINES do
                    SkyLabels[i].Instance.FontFace = Library.Font
                end
                Items["SkySizer"].Instance.FontFace = Library.Font
            end

            local function wordsOf(text)
                local words = { }
                for word in tostring(text or ""):gmatch("%S+") do
                    words[#words + 1] = word
                end
                return words
            end

            if #state.lyrics == 0 then
                Items["SkyWords"].Instance.Visible = false
                for i = 1, SKY_LINES do
                    SkyLabels[i].Instance.Visible = true
                end

                local msg = ""
                if state.title ~= "" then
                    msg = state.title .. (state.artist ~= "" and ("  -  " .. state.artist) or "")
                else
                    msg = state.lyricStatus or ""
                end
                if msg == "" then
                    sky.Enabled = false
                    return
                end

                local key = "title:" .. msg
                if key ~= skyKey then
                    skyKey = key
                    skyAlpha[mid] = 1
                    skyOffset[mid] = 0.06
                end

                local alphaRate = 1 - math.exp(-dt * 14)
                local offsetRate = 1 - math.exp(-dt * 10)
                for i = 1, SKY_LINES do
                    local lbl = SkyLabels[i].Instance
                    local active = i == mid
                    local text = active and msg or ""
                    local targetAlpha = active and 0 or 0.55
                    lbl.Text = text
                    lbl.TextColor3 = active and Library.Theme.Accent or Library.Theme.Text
                    skyAlpha[i] = skyAlpha[i] + (targetAlpha - skyAlpha[i]) * alphaRate
                    skyOffset[i] = skyOffset[i] + (0 - skyOffset[i]) * offsetRate
                    lbl.TextTransparency = skyAlpha[i]
                    lbl.Position = UDim2New(0, 0, skyRows[i] + skyOffset[i], 0)
                end
                return
            end

            local wordMode = Spotify.Cfg.skyWords
            Items["SkyWords"].Instance.Visible = wordMode
            for i = 1, SKY_LINES do
                SkyLabels[i].Instance.Visible = not wordMode
            end

            if wordMode then
                local lineKey, words, count, fullText

                if state.synced then
                    local idx = math.max(currentIndex(dpos), 1)
                    local line = state.lyrics[idx]
                    words = wordsOf(line and line.text or "")
                    if #words == 0 then words = { "\u{266A}" } end
                    local startT = (line and line.time) or 0
                    local nextT = (state.lyrics[idx + 1] and state.lyrics[idx + 1].time)
                        or (startT + math.max(2.5, #words * 0.5))
                    local progress = math.clamp((dpos - startT) / math.max(nextT - startT, 0.05), 0, 0.9999)
                    count = math.clamp(math.floor(progress * #words) + 1, 1, #words)
                    fullText = table.concat(words, " ")
                    lineKey = "s:" .. idx
                else
                    local lineDur = 3.2
                    local li = math.floor(t / lineDur) % #state.lyrics + 1
                    local line = state.lyrics[li]
                    words = wordsOf(line and line.text or "")
                    if #words == 0 then words = { "\u{266A}" } end
                    local progress = (t % lineDur) / lineDur
                    count = math.clamp(math.floor(progress * #words) + 1, 1, #words)
                    fullText = table.concat(words, " ")
                    lineKey = "p:" .. li
                end

                -- The visible word labels all share the size of the whole line,
                -- so text never re-scales as each word is written out.
                local sizer = Items["SkySizer"].Instance
                if skySizerText ~= fullText then
                    skySizerText = fullText
                    sizer.Text = fullText
                end
                local bounds = sizer.TextBounds
                if bounds.Y > 1 then
                    skyWordSize = math.clamp(bounds.Y * 0.85, 12, 96)
                end
                local size = skyWordSize

                if skyWordLine ~= lineKey or count < skyWordCount then
                    clearSkyWords()
                    skyWordLine = lineKey
                    for i = 1, count do
                        local lbl = newSkyWord(i, words[i] or "", size, i == count)
                        styleSkyWord(lbl, i == count, true)
                    end
                    skyWordCount = count
                elseif count > skyWordCount then
                    local old = skyWordCount
                    for i = old + 1, count do
                        local lbl = newSkyWord(i, words[i] or "", size, i == count)
                        styleSkyWord(lbl, i == count, true)
                    end
                    local prev = SkyWordLabels[old]
                    if prev then styleSkyWord(prev, false, true) end
                    skyWordCount = count
                end

                for i = 1, #SkyWordLabels do
                    local inst = SkyWordLabels[i] and SkyWordLabels[i].Instance
                    if inst then
                        if fontChanged then inst.FontFace = Library.Font end
                        if math.abs(inst.TextSize - size) > 0.5 then inst.TextSize = size end
                    end
                end
                return
            end

            local texts = { "", "", "" }
            local key = ""
            local activeMid = true

            if state.synced then
                local idx = math.max(currentIndex(dpos), 1)
                for i = 1, SKY_LINES do
                    local l = state.lyrics[idx + (i - mid)]
                    texts[i] = l and ((l.text ~= "" and l.text) or "\u{266A}") or ""
                end
                key = "l:" .. idx
            else
                activeMid = false
                for i = 1, SKY_LINES do
                    local l = state.lyrics[i]
                    texts[i] = l and l.text or ""
                end
                key = "p:1"
            end

            if key ~= skyKey then
                skyKey = key
                skyAlpha[mid] = 1
                skyOffset[mid] = 0.06
            end

            local alphaRate = 1 - math.exp(-dt * 14)
            local offsetRate = 1 - math.exp(-dt * 10)
            for i = 1, SKY_LINES do
                local lbl = SkyLabels[i] and SkyLabels[i].Instance
                if lbl then
                    local active = activeMid and i == mid
                    local targetAlpha = active and 0 or (activeMid and 0.55 or 0.4)
                    lbl.Text = texts[i] or ""
                    lbl.TextColor3 = active and Library.Theme.Accent or Library.Theme.Text
                    skyAlpha[i] = skyAlpha[i] + (targetAlpha - skyAlpha[i]) * alphaRate
                    skyOffset[i] = skyOffset[i] + (0 - skyOffset[i]) * offsetRate
                    lbl.TextTransparency = skyAlpha[i]
                    lbl.Position = UDim2New(0, 0, skyRows[i] + skyOffset[i], 0)
                end
            end
        end

        Library:Connect(RunService.RenderStepped, function(dt)
            if not Spotify.Visible then return end
            Items["Track"].Instance.Text = state.title ~= "" and state.title or "Nothing playing"
            Items["Artist"].Instance.Text = state.artist
            Items["BtnPlay"].Instance.Text = ICONS.play and "" or (state.playing and "II" or ">")
            if Items["PlayIcon"] then
                Items["PlayIcon"].Instance.Image = state.playing and (ICONS.pause or ICONS.play) or ICONS.play
            end
            local dpos = getPos()
            if state.dur > 0 then
                Items["BarFill"].Instance.Size = UDim2New(math.clamp(dpos / state.dur, 0, 1), 0, 1, 0)
            end
            Items["Elapsed"].Instance.Text = fmt(dpos)
            Items["Remaining"].Instance.Text = "-" .. fmt(math.max(state.dur - dpos, 0))
            drawLyrics(dpos)
            drawSky(dpos, dt)
        end)

        local pollRunning = false
        function Spotify:SetVisibility(Bool)
            Spotify.Visible = Bool
            Items["Panel"].Instance.Visible = Bool
            if Items["Sky"] then
                Items["Sky"].Instance.Enabled = Bool and Spotify.Cfg.skyLyrics or false
            end
            if Bool then
                layout()
                Library:Thread(function()
                    if pollRunning then return end
                    pollRunning = true
                    while Spotify.Visible do
                        poll()
                        task.wait(Spotify.Poll)
                    end
                    pollRunning = false
                end)
            end
        end

        function Spotify:Destroy()
            if Items["SkyBoard"] then Items["SkyBoard"]:Clean() end
            if Items["Sky"] then Items["Sky"]:Clean() end
            if Items["Panel"] then Items["Panel"]:Clean() end
            if Items["Screen"] then Items["Screen"]:Clean() end
            Spotify.Visible = false
        end

        return Spotify
    end

    -- ===== Embedded 3D UI (ships inside the library; no external file / localhost) =====
    local Hood3DPresenter = (function()
--[[
================================================================================
  Hood3DUI  --  Build 1: the 3D UI (presenter)
================================================================================
  * On OPEN the panel is placed at the player's position, a little forward and
    angled slightly upward, and then STAYS where it is while open.
  * While CLOSED it follows the character (so it is already with you when you
    open it).
  * Smaller: the menu content is scaled down (keeps slider accuracy).
  * Little open effect: a scale "pop" as it appears.
  * Draggable (grab the top / drag key), scroll for depth, smooth movement.
  * No world greyscale / blur -- the world is untouched.
  * Watermark / Keybind list / ESP preview / notifications stay 2D on screen.
    Only the menu itself is 3D.

  API:
      ui:Reanchor()  ui:SetDistance(n)  ui:SetScale(n)
      ui:SetEnabled(bool)  ui:SetAnchorMode("Player")  ui:Destroy()

  OPTIONS
      AnchorMode       "Player" | "World"                            ("Player")
      Side             "Front" | "Behind"                             ("Front")
      Distance         studs in front of you                          (5)
      VerticalOffset   raise/lower the panel (studs)                  (0)
      Tilt             degrees, angles the panel upward               (9)
      Scale            menu size (0.2..2.5)                           (1.5)
      Smoothness       position easing (higher = snappier)            (9)
      DragScale        how far it moves per mouse pixel               (0.8)
      (drag by the window's top bar, or hold the drag key and drag anywhere)
      DragKey          hold to drag from anywhere (nil to disable)    (LeftAlt)
      ReanchorKey      snap back in front of you                      (Home)
      AlwaysOnTop      draw over geometry (off = occluded by walls/you)(false)
      LockWindow       misclicks don't drag the Scoot window          (true)
      KeepOnScreen     watermark/keybinds/ESP/notifs stay 2D          (true)
      PopTime          open "pop" duration (0 to disable)             (0.3)
      Parent           where the part lives                           (Workspace)
================================================================================
]]

local Hood3D = {}
Hood3D.__index = Hood3D

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function resolveScreenGui(target)
	if typeof(target) == "Instance" then
		if target:IsA("ScreenGui") then
			return target
		end
		return nil
	end
	if type(target) == "table" then
		if target.Holder and target.Holder.Instance and target.Holder.Instance:IsA("ScreenGui") then
			return target.Holder.Instance
		end
		if target.Instance and typeof(target.Instance) == "Instance" and target.Instance:IsA("ScreenGui") then
			return target.Instance
		end
	end
	return nil
end

local function findCustomCursor(root)
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("Frame") and child.ZIndex >= 9999 and child:FindFirstChildOfClass("ImageLabel") then
			return child
		end
	end
	return nil
end

local function findWindow(root)
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("Frame") and child.BackgroundTransparency < 1 then
			local x, y = child.Size.X.Offset, child.Size.Y.Offset
			if x >= 600 and x <= 900 and y >= 400 and y <= 700 then
				return child
			end
		end
	end
	return nil
end

local function isOverlay(child)
	if not child:IsA("Frame") then
		return false
	end
	if child:FindFirstChildWhichIsA("ViewportFrame", true) then
		return true -- ESP preview panel
	end
	if child.AnchorPoint.Y >= 1 then
		return true -- watermark (bottom-anchored)
	end
	if child.AnchorPoint.X <= 0 and child.AnchorPoint.Y == 0.5 then
		return true -- keybind list (left-middle)
	end
	return false
end

function Hood3D.Mount(target, options)
	options = options or {}

	local gui = resolveScreenGui(target)
	assert(gui, "Hood3D.Mount: expected a ScreenGui (or a Scoot Library / holder object)")

	-- Things that should stay on screen (2D) rather than go on the 3D panel.
	local keepInstances = {}
	if type(target) == "table" then
		if target.NotifHolder and typeof(target.NotifHolder.Instance) == "Instance" then
			keepInstances[target.NotifHolder.Instance] = true
		end
		if target.UnusedHolder and typeof(target.UnusedHolder.Instance) == "Instance" then
			keepInstances[target.UnusedHolder.Instance] = true
		end
	end
	for _, instance in ipairs(options.KeepOnScreen2D or {}) do
		if typeof(instance) == "Instance" then
			keepInstances[instance] = true
		end
	end

	local camera = Workspace.CurrentCamera
	assert(camera, "Hood3D.Mount: no CurrentCamera")

	local distance = tonumber(options.Distance) or 5
	local anchorMode = tostring(options.AnchorMode or "Player")
	local side = tostring(options.Side or "Front")
	local smoothing = math.clamp(tonumber(options.Smoothness) or 9, 0.5, 60)
	local dragScale = math.clamp(tonumber(options.DragScale) or 0.8, 0.05, 3)
	local verticalOffset = tonumber(options.VerticalOffset) or 0
	local tilt = math.rad(tonumber(options.Tilt) or 9)
	local menuScale = math.clamp(tonumber(options.Scale) or 1.5, 0.2, 2.5)
	local alwaysOnTop = options.AlwaysOnTop == true
	local hideCustomCursor = options.HideCustomCursor ~= false
	local canQuery = options.CanQuery ~= false
	local lockWindow = options.LockWindow ~= false
	local keepOnScreen = options.KeepOnScreen ~= false
	local popTime = math.max(tonumber(options.PopTime) or 0.3, 0)
	local dragKey = options.DragKey
	if dragKey == nil then
		dragKey = Enum.KeyCode.LeftAlt
	end
	local reanchorKey = options.ReanchorKey
	if reanchorKey == nil then
		reanchorKey = Enum.KeyCode.Home
	end
	local parent = options.Parent or Workspace

	local folder = Instance.new("Folder")
	folder.Name = "Hood3DUI"

	local panel = Instance.new("Part")
	panel.Name = "Hood3DPanel"
	panel.Anchored = true
	panel.CanCollide = false
	panel.CanTouch = false
	panel.CastShadow = false
	panel.CanQuery = false
	panel.Transparency = 1
	panel.TopSurface = Enum.SurfaceType.Smooth
	panel.BottomSurface = Enum.SurfaceType.Smooth
	panel.Size = Vector3.new(1, 1, 0.08)
	panel.CFrame = camera.CFrame * CFrame.new(0, 0, -math.max(distance, 0.1))
	panel.Parent = folder

	local surface = Instance.new("SurfaceGui")
	surface.Name = "Hood3DSurface"
	surface.Face = Enum.NormalId.Front
	surface.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
	surface.CanvasSize = Vector2.new(camera.ViewportSize.X, camera.ViewportSize.Y)
	surface.PixelsPerStud = 64
	surface.LightInfluence = 0
	surface.AlwaysOnTop = alwaysOnTop
	surface.ZIndexBehavior = Enum.ZIndexBehavior.Global
	surface.ResetOnSpawn = false
	surface.Adornee = panel
	surface.Parent = panel

	folder.Parent = parent

	local function staysOnScreen(child)
		return (keepOnScreen and isOverlay(child)) or keepInstances[child] == true
	end

	-- Move everything to the surface, except the on-screen HUD elements.
	for _, child in ipairs(gui:GetChildren()) do
		if not staysOnScreen(child) then
			child.Parent = surface
		end
	end

	-- Wrap ONLY the menu window so we can scale it (and pop it) without
	-- affecting dropdown / colorpicker / tooltip frames, which stay siblings.
	local windowFrame = findWindow(surface)
	local contentScale
	local disabledDragConnections = {}
	if windowFrame then
		local wrapper = Instance.new("Frame")
		wrapper.Name = "Hood3DWindowWrap"
		wrapper.BackgroundTransparency = 1
		wrapper.BorderSizePixel = 0
		wrapper.AnchorPoint = Vector2.new(0.5, 0.5)
		wrapper.Position = UDim2.fromScale(0.5, 0.5)
		wrapper.Size = UDim2.fromScale(1, 1)
		wrapper.Parent = surface

		contentScale = Instance.new("UIScale")
		contentScale.Scale = menuScale
		contentScale.Parent = wrapper

		windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		windowFrame.Position = UDim2.fromScale(0.5, 0.5)
		windowFrame.Parent = wrapper

		-- Kill Scoot's own window-drag so it can't fight the panel drag /
		-- jiggle against the position lock (that was the "moves then snaps back").
		-- Keep the connections so we can re-enable them when 3D mode is turned off.
		local gc = getconnections or (getgenv and getgenv().getconnections)
		if gc then
			pcall(function()
				for _, connection in ipairs(gc(windowFrame.InputBegan)) do
					connection:Disable()
					table.insert(disabledDragConnections, connection)
				end
			end)
		end
	end

	local state = {
		Panel = panel,
		Surface = surface,
		Folder = folder,
		Window = windowFrame,
		ContentScale = contentScale,
		DragOffset = Vector3.new(),
		BasePosition = panel.Position,
		BaseSize = panel.Size,
		PopActive = false,
		PopStart = 0,
		Orientation = panel.CFrame.Rotation,
		Distance = distance,
		VerticalOffset = verticalOffset,
		Tilt = tilt,
		Side = side,
		Scale = menuScale,
		AnchorMode = anchorMode,
		AlwaysOnTop = alwaysOnTop,
		Enabled = true,
		Open = false,
		Connections = {},
	}

	table.insert(state.Connections, gui.ChildAdded:Connect(function(child)
		if child.Parent == gui and not staysOnScreen(child) then
			child.Parent = surface
		end
	end))

	local cursor = hideCustomCursor and findCustomCursor(surface) or nil

	------------------------------------------------------------------
	-- Geometry: canvas == viewport, 1 surface px == 1 screen px.
	------------------------------------------------------------------
	local lastVpX, lastVpY, lastFov, lastDist = -1, -1, -1, -1

	local function updateGeometry()
		local vp = camera.ViewportSize
		local fov = camera.FieldOfView
		local dist = state.Distance
		if vp.X == lastVpX and vp.Y == lastVpY and fov == lastFov and dist == lastDist then
			return
		end
		lastVpX, lastVpY, lastFov, lastDist = vp.X, vp.Y, fov, dist

		local focal = (vp.Y * 0.5) / math.tan(math.rad(fov) * 0.5)
		local ppu = focal / math.max(dist, 0.1)
		if ppu <= 0 or ppu ~= ppu then
			ppu = 64
		end

		local canvasX = math.max(vp.X, 1)
		local canvasY = math.max(vp.Y, 1)
		surface.CanvasSize = Vector2.new(canvasX, canvasY)
		surface.PixelsPerStud = ppu
		state.BaseSize = Vector3.new(canvasX / ppu, canvasY / ppu, 0.08)
		panel.Size = state.BaseSize
	end

	------------------------------------------------------------------
	-- Placement
	------------------------------------------------------------------
	local function characterPart()
		local player = Players.LocalPlayer
		local character = player and player.Character
		if not character then
			return nil
		end
		return character:FindFirstChild("HumanoidRootPart")
			or character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
			or character:FindFirstChild("Head")
	end

	local function computePlayerTarget()
		updateGeometry()
		local part = characterPart()
		local base = part and part.CFrame or camera.CFrame
		local flat = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
		if flat.Magnitude < 1e-3 then
			flat = Vector3.new(0, 0, -1)
		end
		flat = flat.Unit

		local dir = (state.Side == "Front") and 1 or -1
		local y = base.Position.Y + state.VerticalOffset
		local pos = Vector3.new(
			base.Position.X + flat.X * (state.Distance * dir),
			y,
			base.Position.Z + flat.Z * (state.Distance * dir)
		)

		local camPos = camera.CFrame.Position
		local rot = (CFrame.lookAt(pos, camPos) * CFrame.Angles(state.Tilt, 0, 0)).Rotation
		return pos, rot
	end

	local function computeWorldTarget()
		local cf = options.CFrame or (camera.CFrame * CFrame.new(0, 0, -state.Distance))
		return cf.Position, cf.Rotation
	end

	local function computeTarget()
		if state.AnchorMode == "World" then
			return computeWorldTarget()
		end
		return computePlayerTarget()
	end

	-- Base anchor WITHOUT the drag offset. Follows while closed; frozen while open.
	local function follow()
		local pos, rot = computeTarget()
		state.BasePosition = pos
		state.Orientation = rot
		return pos, rot
	end

	local function targetPosition()
		return state.BasePosition + state.DragOffset
	end

	------------------------------------------------------------------
	-- Dragging (stable screen-space delta) + scroll wheel = resize
	------------------------------------------------------------------
	local drag = {
		active = false,
		startMouse = Vector2.new(),
		startOffset = Vector3.new(),
	}

	local function screenRay()
		local loc = UserInputService:GetMouseLocation()
		return camera:ViewportPointToRay(loc.X, loc.Y)
	end

	local function panelHit()
		if not panel.Parent then
			return nil
		end
		local ray = screenRay()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Include
		params.FilterDescendantsInstances = { panel }
		local previous = panel.CanQuery
		panel.CanQuery = true
		local result = Workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
		panel.CanQuery = previous
		return result
	end

	local function isDragGrab(result)
		if not result then
			return false
		end
		if dragKey and UserInputService:IsKeyDown(dragKey) then
			return true
		end
		local localPos = panel.CFrame:PointToObjectSpace(result.Position)
		local canvasY = (panel.Size.Y * 0.5 - localPos.Y) * surface.PixelsPerStud
		local windowTop = (windowFrame and windowFrame.AbsolutePosition.Y) or 0
		return canvasY < (windowTop + 40) -- the top bar of the window + area above it
	end

	table.insert(state.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if isDragGrab(panelHit()) then
				drag.active = true
				drag.startMouse = UserInputService:GetMouseLocation()
				drag.startOffset = state.DragOffset
			end
		end
	end))

	table.insert(state.Connections, UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if not drag.active then
				return
			end
			local delta = UserInputService:GetMouseLocation() - drag.startMouse
			local vp = camera.ViewportSize
			local focal = (vp.Y * 0.5) / math.tan(math.rad(camera.FieldOfView) * 0.5)
			local dist = (panel.Position - camera.CFrame.Position).Magnitude
			local worldScale = (dist / math.max(focal, 1)) * dragScale
			-- move within the camera's screen plane (right / up), like dragging on glass
			local offset = camera.CFrame.RightVector * (delta.X * worldScale)
				+ camera.CFrame.UpVector * (-delta.Y * worldScale)
			state.DragOffset = drag.startOffset + offset
		end
	end))

	table.insert(state.Connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			drag.active = false
		end
	end))

	------------------------------------------------------------------
	-- Open / close + little open "pop"
	------------------------------------------------------------------
	local function isOpen()
		if windowFrame then
			return windowFrame.Visible
		end
		return gui.Enabled
	end

	-- Pop by scaling the PART (cheap) instead of a UIScale (which would force
	-- the whole menu to re-layout every frame).
	local function playOpenEffect()
		if popTime <= 0 then
			return
		end
		state.PopActive = true
		state.PopStart = os.clock()
	end

	local wasOpen = false

	local function refresh()
		local open = gui.Enabled and isOpen()
		state.Open = open

		if open and not wasOpen then
			-- Land at the player's current spot and freeze there.
			state.DragOffset = Vector3.new()
			local pos, rot = computeTarget()
			state.BasePosition = pos
			state.Orientation = rot
			playOpenEffect()
		end
		wasOpen = open
	end

	table.insert(state.Connections, gui:GetPropertyChangedSignal("Enabled"):Connect(refresh))
	if windowFrame then
		table.insert(state.Connections, windowFrame:GetPropertyChangedSignal("Visible"):Connect(refresh))
	end

	if reanchorKey then
		table.insert(state.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == reanchorKey then
				state.DragOffset = Vector3.new()
				follow()
			end
		end))
	end

	------------------------------------------------------------------
	-- Frame loop
	------------------------------------------------------------------
	local lastSurfaceEnabled, lastCanQuery, lastWindowPos, lastCFrame

	table.insert(state.Connections, RunService.RenderStepped:Connect(function(dt)
		if hideCustomCursor then
			if not UserInputService.MouseIconEnabled then
				UserInputService.MouseIconEnabled = true
			end
			if cursor and cursor.Parent and cursor.Visible then
				cursor.Visible = false
			end
		end

		-- Follow only while the menu is closed; once open it stays put.
		if not state.Open then
			follow()
		end

		local target = targetPosition()
		-- snap the follow fast while actively dragging so it tracks the cursor
		local rate = drag.active and math.max(smoothing, 60) or smoothing
		local alpha = 1 - math.exp(-dt * rate)
		local nextPos = panel.Position:Lerp(target, alpha)
		if (nextPos - target).Magnitude < 0.002 then
			nextPos = target
		end
		local targetCFrame = CFrame.new(nextPos) * state.Orientation
		-- Skip redundant writes so a still panel costs nothing per frame.
		if not lastCFrame or not lastCFrame:FuzzyEq(targetCFrame, 0.0005) then
			lastCFrame = targetCFrame
			panel.CFrame = targetCFrame
		end

		-- Open "pop" (scales the part, no GUI re-layout).
		if state.PopActive then
			local t = (os.clock() - state.PopStart) / popTime
			if t >= 1 then
				state.PopActive = false
				panel.Size = state.BaseSize
			else
				local c1 = 1.70158
				local back = 1 + (c1 + 1) * ((t - 1) ^ 3) + c1 * ((t - 1) ^ 2)
				panel.Size = state.BaseSize * (0.85 + 0.15 * back)
			end
		end

		if lockWindow and windowFrame and windowFrame.Position ~= lastWindowPos then
			windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			windowFrame.Position = UDim2.fromScale(0.5, 0.5)
			lastWindowPos = windowFrame.Position
		end

		local enabled = gui.Enabled
		if enabled ~= lastSurfaceEnabled then
			lastSurfaceEnabled = enabled
			surface.Enabled = enabled
		end
		local cq = canQuery and state.Open
		if cq ~= lastCanQuery then
			lastCanQuery = cq
			panel.CanQuery = cq
		end
	end))

	function state:Reanchor()
		self.DragOffset = Vector3.new()
		follow()
		panel.CFrame = CFrame.new(targetPosition()) * self.Orientation
	end

	function state:SetDistance(value)
		self.Distance = tonumber(value) or self.Distance
	end

	function state:SetScale(value)
		self.Scale = math.clamp(tonumber(value) or self.Scale, 0.2, 2.5)
		if self.ContentScale then
			self.ContentScale.Scale = self.Scale
		end
	end

	function state:SetAnchorMode(mode)
		self.AnchorMode = tostring(mode or self.AnchorMode)
	end

	function state:SetEnabled(value)
		gui.Enabled = value and true or false
	end

	function state:Destroy()
		for _, connection in ipairs(self.Connections) do
			pcall(function()
				connection:Disconnect()
			end)
		end
		table.clear(self.Connections)

		-- Restore Scoot's window-drag (we disabled it while 3D was active).
		for _, connection in ipairs(disabledDragConnections) do
			pcall(function()
				connection:Enable()
			end)
		end
		table.clear(disabledDragConnections)

		pcall(function()
			folder:Destroy()
		end)
		UserInputService.MouseIconEnabled = true
	end

	follow()
	panel.CFrame = CFrame.new(targetPosition()) * state.Orientation
	refresh()

	return state
end

getgenv().Hood3D = Hood3D
getgenv().Hood3D_Mount = Hood3D.Mount

return Hood3D

    end)()

    Library.Hood3DPresenter = Hood3DPresenter
    Library.ThreeDUI = { Desired = false, Mounted = nil }

    function Library.Apply3D()
        local Window = Library.CurrentWindow
        if not Window then
            return
        end

        if Library.ThreeDUI.Desired and not Library.ThreeDUI.Mounted then
            local KeepOnScreen2D = { }

            for _, Overlay in ipairs({ Library.WatermarkObj, Library.KeybindListObj, Library.ESPPreviewObj }) do
                local Elements = Overlay and Overlay.Elements

                if Elements then
                    local Root = Elements["Watermark"] or Elements["KeybindList"] or Elements["Panel"]

                    if Root and Root.Instance then
                        TableInsert(KeepOnScreen2D, Root.Instance)
                    end
                end
            end

            local ok, mounted = pcall(Hood3DPresenter.Mount, Library, {
                AnchorMode = "Player",
                Side = "Front",
                Distance = 5,
                VerticalOffset = 0,
                Tilt = 9,
                Scale = 1.5,
                Smoothness = 9,
                DragScale = 0.8,
                DragKey = Enum.KeyCode.LeftAlt,
                PopTime = 0.3,
                LockWindow = true,
                AlwaysOnTop = false,
                KeepOnScreen = true,
                KeepOnScreen2D = KeepOnScreen2D,
                HideCustomCursor = true,
                CanQuery = true,
            })
            if ok and mounted then
                Library.ThreeDUI.Mounted = mounted
                getgenv().Hood3DUI = mounted
            end
        elseif not Library.ThreeDUI.Desired and Library.ThreeDUI.Mounted then
            local mounted = Library.ThreeDUI.Mounted
            local holder = Library.Holder.Instance
            pcall(function()
                local surface = mounted.Surface
                if surface then
                    for _, child in ipairs(surface:GetChildren()) do
                        if child.Name == "Hood3DWindowWrap" then
                            for _, sub in ipairs(child:GetChildren()) do
                                if sub:IsA("GuiObject") then
                                    sub.AnchorPoint = Vector2.new(0, 0)
                                    sub.Position = UDim2.fromScale(0.3, 0.3)
                                    sub.Parent = holder
                                end
                            end
                        else
                            child.Parent = holder
                        end
                    end
                end
            end)
            pcall(function()
                mounted:Destroy()
            end)
            Library.ThreeDUI.Mounted = nil
            getgenv().Hood3DUI = nil
        end
    end

    Library.OnThreeDUI = function(value)
        Library.ThreeDUI.Desired = value
        pcall(function()
            Library:Notification("3D UI", value and "Reopen the menu to switch to 3D" or "Reopen the menu to go back to 2D", 4)
        end)
    end
end

getgenv().Library = Library
return Library
