

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
            ["Background"] = FromRGB(14, 14, 16),
            ["Inline"] = FromRGB(20, 20, 23),
            ["Page Background"] = FromRGB(28, 28, 32),
            ["Border"] = FromRGB(8, 8, 9),
            ["Outline"] = FromRGB(42, 42, 48),
            ["Accent"] = FromRGB(168, 138, 232),
            ["Element"] = FromRGB(36, 36, 41),
            ["Hovered Element"] = FromRGB(45, 45, 51),
            ["Text"] = FromRGB(224, 224, 228),
            ["Text Border"] = FromRGB(0, 0, 0),
            ["Placeholder Text"] = FromRGB(152, 152, 160)
        },

        MenuKeybind = Enum.KeyCode.RightControl, 

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

        Images = { 
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/hue.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Resize"] = { "Resize.png", "https://github.com/sametexe001/images/blob/main/resize.png?raw=true" },
        },

        
        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },

        SetFlags = { },
        OpenDropdowns = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = nil,
        KeyList = nil,

        CurrentColorpicker = nil,

        FeatureRegistry = { },
        TrackedSections = { },
        SearchGroups = { },
        AccentRefreshers = { }
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    Library.IsMobile = (getgenv().FM_MOBILE == true)
        or (UserInputService.TouchEnabled == true and UserInputService.KeyboardEnabled == false)

    
    
    function Library:CloseDropdowns()
        for Dropdown in pairs(self.OpenDropdowns) do
            if Dropdown.SetOpen and Dropdown.IsOpen then
                Dropdown:SetOpen(false)
            end
        end
        self.OpenDropdowns = { }
    end

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

    
    for _, FileName in Library.Folders do
        if not isfolder(FileName) then
            makefolder(FileName)
        end
    end

    local function DecodeB64(Data)
        local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local Out, Buffer, Bits = { }, 0, 0

        for Index = 1, #Data do
            local Value = string.find(B64, Data:sub(Index, Index), 1, true)

            if Value then
                Buffer = Buffer * 64 + (Value - 1)
                Bits = Bits + 6

                if Bits >= 8 then
                    Bits = Bits - 8
                    Out[#Out + 1] = string.char(math.floor(Buffer / 2 ^ Bits) % 256)
                    Buffer = Buffer % (2 ^ Bits)
                end
            end
        end

        return table.concat(Out)
    end

    Library.EmbeddedAssets = Library.EmbeddedAssets or {
        ["Scrollbar.png"] = "iVBORw0KGgoAAAANSUhEUgAAAV0AAAFcCAYAAABr1G0SAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAS0SURBVHhe7dQxAQAgDMCwgX/PwIGGXslTB13nGQAS+xeAgOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIGS6ACHTBQiZLkDIdAFCpgsQMl2AkOkChEwXIDNzAbxZBrRnb/1JAAAAAElFTkSuQmCC",
        ["Resize.png"] = "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",
        ["Checkers.png"] = "/9j/4AAQSkZJRgABAQEBLAEsAAD/4QCkRXhpZgAASUkqAAgAAAAEAA4BAgBIAAAAPgAAAJiCAgAGAAAAhgAAABoBBQABAAAAjAAAABsBBQABAAAAlAAAAAAAAABWZWN0b3IgY2hlY2tlciBjaGVzcyBzcXVhcmUgYWJzdHJhY3QgYmFja2dyb3VuZC4gQmxhY2sgYW5kIFdoaXRlIFNxdWFyZXNTa2FyaW4sAQAAAQAAACwBAAABAAAA/+EF02h0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8APD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyI+Cgk8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgoJCTxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1sbnM6SXB0YzR4bXBDb3JlPSJodHRwOi8vaXB0Yy5vcmcvc3RkL0lwdGM0eG1wQ29yZS8xLjAveG1sbnMvIiAgIHhtbG5zOkdldHR5SW1hZ2VzR0lGVD0iaHR0cDovL3htcC5nZXR0eWltYWdlcy5jb20vZ2lmdC8xLjAvIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBsdXM9Imh0dHA6Ly9ucy51c2VwbHVzLm9yZy9sZGYveG1wLzEuMC8iICB4bWxuczppcHRjRXh0PSJodHRwOi8vaXB0Yy5vcmcvc3RkL0lwdGM0eG1wRXh0LzIwMDgtMDItMjkvIiB4bWxuczp4bXBSaWdodHM9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9yaWdodHMvIiBkYzpSaWdodHM9IlNrYXJpbiIgcGhvdG9zaG9wOkNyZWRpdD0iR2V0dHkgSW1hZ2VzL2lTdG9ja3Bob3RvIiBHZXR0eUltYWdlc0dJRlQ6QXNzZXRJRD0iNTQ0NTg0MTAwIiB4bXBSaWdodHM6V2ViU3RhdGVtZW50PSJodHRwczovL3d3dy5pc3RvY2twaG90by5jb20vbGVnYWwvbGljZW5zZS1hZ3JlZW1lbnQ/dXRtX21lZGl1bT1vcmdhbmljJmFtcDt1dG1fc291cmNlPWdvb2dsZSZhbXA7dXRtX2NhbXBhaWduPWlwdGN1cmwiIHBsdXM6RGF0YU1pbmluZz0iaHR0cDovL25zLnVzZXBsdXMub3JnL2xkZi92b2NhYi9ETUktUFJPSElCSVRFRC1FWENFUFRTRUFSQ0hFTkdJTkVJTkRFWElORyIgPgo8ZGM6Y3JlYXRvcj48cmRmOlNlcT48cmRmOmxpPlNrYXJpbjwvcmRmOmxpPjwvcmRmOlNlcT48L2RjOmNyZWF0b3I+PGRjOmRlc2NyaXB0aW9uPjxyZGY6QWx0PjxyZGY6bGkgeG1sOmxhbmc9IngtZGVmYXVsdCI+VmVjdG9yIGNoZWNrZXIgY2hlc3Mgc3F1YXJlIGFic3RyYWN0IGJhY2tncm91bmQuIEJsYWNrIGFuZCBXaGl0ZSBTcXVhcmVzPC9yZGY6bGk+PC9yZGY6QWx0PjwvZGM6ZGVzY3JpcHRpb24+CjxwbHVzOkxpY2Vuc29yPjxyZGY6U2VxPjxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPjxwbHVzOkxpY2Vuc29yVVJMPmh0dHBzOi8vd3d3LmlzdG9ja3Bob3RvLmNvbS9waG90by9saWNlbnNlLWdtNTQ0NTg0MTAwLT91dG1fbWVkaXVtPW9yZ2FuaWMmYW1wO3V0bV9zb3VyY2U9Z29vZ2xlJmFtcDt1dG1fY2FtcGFpZ249aXB0Y3VybDwvcGx1czpMaWNlbnNvclVSTD48L3JkZjpsaT48L3JkZjpTZXE+PC9wbHVzOkxpY2Vuc29yPgoJCTwvcmRmOkRlc2NyaXB0aW9uPgoJPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KPD94cGFja2V0IGVuZD0idyI/Pgr/7QCcUGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAIAcAlAABlNrYXJpbhwCeABIVmVjdG9yIGNoZWNrZXIgY2hlc3Mgc3F1YXJlIGFic3RyYWN0IGJhY2tncm91bmQuIEJsYWNrIGFuZCBXaGl0ZSBTcXVhcmVzHAJ0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",
        ["Hue.png"] = "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",
        ["Saturation.png"] = "iVBORw0KGgoAAAANSUhEUgAAAaQAAAGkCAQAAADURZm+AAAAAmJLR0QAAKqNIzIAAAAHdElNRQfoBwUSCSk/70tWAAADrUlEQVR42u3TORLCMBBFwT+6/50hMqXSZgonBN0BWCDGYPwqSV6VJJkfk+qOrsf5aH61X+3WNZylf7c2u+vn3de6bfe0zcQa5txNbMOEtvz0PKttz3KaOJ7/u4nzN7n/HfOE9Zz7K/rkfzztznLPeIflcP9le7Ref55bgMeEBEICIYGQACGBkEBIICRASCAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEgjJJQAhgZBASICQQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZBASICQQEggJBASICQQEggJhAQICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIIySUAIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkEBIgJBASCAkEBIgJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZBASICQQEggJBASICQQEggJhAQICYQEQgKEBEKC//IG6/YFRSoFM5AAAAAldEVYdGRhdGU6Y3JlYXRlADIwMjQtMDctMDVUMTg6MDk6NDArMDA6MDDfCbSEAAAAJXRFWHRkYXRlOm1vZGlmeQAyMDI0LTA3LTA1VDE4OjA5OjQwKzAwOjAwrlQMOAAAACh0RVh0ZGF0ZTp0aW1lc3RhbXAAMjAyNC0wNy0wNVQxODowOTo0MCswMDowMPlBLecAAAAASUVORK5CYII=",
        ["Value.png"] = "iVBORw0KGgoAAAANSUhEUgAAAaQAAAGkCAQAAADURZm+AAAAAmJLR0QAAKqNIzIAAAAHdElNRQfoBwUSCgEhd7BvAAAD4klEQVR42u3YwQnAQAhFQTek/5pz9eBtEYzMlBD4PDcRADDBieMjwK3HJwBDghFepx0oEhgSOO0ARQJDAqcdKBJgSGBI4I0EhgQ47cCQwJDAGwlQJDAkcNqBIgGKBIoEhgROO0CRQJFAkQBDAqcdGBI47QBFAkUCQwKnHaBIoEigSKBIgCKBIYHTDhQJUCQwJHDagSIBigSGBE47UCRAkcCQwGkHKBIoEigSGBLgtANDAkMCbyTAkMBpB4oEigQoEhgSOO1AkQBDAqcdKBIoEqBIYEjgtANFUiRQJFAkMCTAaQeKBIoEigQYEjjtQJFAkQBFAkMCpx0oEmBI4LQDRQJFAhQJDAmcdqBIgCKBIoEhAU47UCRQJFAkwJDAaQeKBIYEOO1AkUCRYHuRTAmcduC0A0UCFAkUCQwJnHaAIoEigSKBIQFOO2gvkimBIoE3EhgS4LQDRQJDAqcdoEigSKBIYEiAIYEhwXx+NoAigSGB0w5QJDAkMCQwJKDiZwMoEhgSOO0ARQJFgnlFMiVw2oHTDhQJUCRQJDAkcNoBVZFMCRQJvJHAkACnHSgSKBIoElANSZPAaQdOOzAkwGkHigSGBIYEGBK08LMBFAkUCRQJMCQwJDAkWMjPBlAkMCRw2gG5SKYEigTeSGBIgNMOFAkMCQwJMCRo4WcDKBIYEjjtgFwkUwJFAm8kMCTAaQeKBIoEigRUQ9IkcNqB0w4MCXDagSKBIsHCIpkSOO3AaQeKBCgSKBIYEhgSYEjQws8GUCQwJHDaAblIpgSKBN5IYEiA0w4UCQwJDAkwJGjhZwMoEhgSOO0ARQJDAkMCQwIqfjaAIoEigSIBhgROO5hXJFMCpx047UCRAEUCRQJDAqcdUBXJlECRwBsJDAlw2oEigSKBIgGGBIYEhgSL+dkAigSGBE47QJHAkMBpB4oEGBIYEhgSrOZnAygSKBIoEmBI4LQDRQJFAhQJDAmcdrC8SKYEigTeSGBIgNMOFAkMCZx2gCKBIoEigSEBTjtQJFAkUCTAkMBpB4oEigQoEhgSOO1AkQBDAqcdKBKgSKBIYEjgtAMUCRQJFAkMCXDagSKBIoEiAYYETjtQJFAkQJHAkMBpB4oEGBI47UCRQJEARQJDAqcdoEigSGBI4LQDFAkUCRQJFAkwJHDagSKBIQFOOzAkMCTwRgIMCZx2oEigSIAigSKBIYHTzkcARQJFAkMCnHZgSGBI4I0EGBI47UCRQJEAQwKnHSgSKBKgSGBI4LQDRQIUCRQJDAmcdoAigSGB0w5QJFAkUCQwJMBpB4oEhgROO0CRwJDAkMAbCVAkMCT4gw/reQYigE05fAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyNC0wNy0wNVQxODoxMDowMCswMDowMGbYTnQAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjQtMDctMDVUMTg6MTA6MDArMDA6MDAXhfbIAAAAKHRFWHRkYXRlOnRpbWVzdGFtcAAyMDI0LTA3LTA1VDE4OjEwOjAwKzAwOjAwQJDXFwAAAA5lWElmTU0AKgAAAAgAAAAAAAAA0lOTAAAAAElFTkSuQmCC",
    }

    for _, ImageData in Library.Images do
        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        local ImagePath = Library.Folders.Assets .. "/" .. ImageName

        if not isfile(ImagePath) then
            local Embedded = Library.EmbeddedAssets[ImageName]

            if Embedded then
                pcall(writefile, ImagePath, DecodeB64(Embedded))
            else
                local Success, Data = pcall(function()
                    return game:HttpGet(ImageLink)
                end)

                if Success and type(Data) == "string" then
                    pcall(writefile, ImagePath, Data)
                end
            end
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
                if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Resizing then
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

    
    Library.Fonts = { }
    Library.FontName = "GothamMedium"

    Library.FontList = {
        ["Tahoma XP"] = {Id = "TahomaXP", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/windows-xp-tahoma.ttf"},
        ["Tahoma Bold"] = {Id = "TahomaBold", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/tahomabd.ttf"},
        ["Verdana"] = {Id = "Verdana", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/verdana.ttf"},
        ["Inter"] = {Id = "Inter", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Inter.ttf"},
        ["Inter Medium"] = {Id = "InterMedium", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/InterMedium.ttf"},
        ["Poppins"] = {Id = "Poppins", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Poppins-Medium.ttf"},
        ["Lato Bold"] = {Id = "LatoBold", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Lato-Bold.ttf"},
        ["Monaco"] = {Id = "Monaco", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Monaco.ttf"},
        ["Roboto Mono"] = {Id = "RobotoMono", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/RobotoMono-Regular.ttf"},
        ["Lucida Console"] = {Id = "LucidaConsole", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/lucida-console.ttf"},
        ["Minecraft"] = {Id = "Minecraft", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/MinecraftStandard.ttf"},
        ["Minecraftia"] = {Id = "Minecraftia", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/minecraftia.ttf"},
        ["Pixel Operator"] = {Id = "PixelOperator", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/PixelOperator.ttf"},
        ["Smallest Pixel"] = {Id = "SmallestPixel", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/smallest_pixel-7.ttf"},
        ["Proggy Clean"] = {Id = "ProggyClean", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/proggy-clean.ttf"},
        ["Proggy Square"] = {Id = "ProggySquare", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/proggy-square.ttf"},
        ["Proggy Tiny"] = {Id = "ProggyTiny", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/proggy-tiny.ttf"},
        ["Cozette"] = {Id = "Cozette", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/cozette-vector.ttf"},
        ["Basis33"] = {Id = "Basis33", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/basis33.ttf"},
        ["NDS12"] = {Id = "NDS12", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/NDS12.ttf"},
        ["Bubblegum Sans"] = {Id = "BubblegumSans", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Bubblegum-Sans.ttf"},
        ["Figtree"] = {Id = "Figtree", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Figtree-Medium.ttf"},
        ["Lexend"] = {Id = "Lexend", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Lexend-Medium.ttf"},
        ["Outfit"] = {Id = "Outfit", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Outfit-Medium.ttf"},
        ["Prompt"] = {Id = "Prompt", Url = "https://raw.githubusercontent.com/sametexe001/luas/refs/heads/main/fonts/Prompt-Regular.ttf"}
    }

    local function GetBuiltInFont(Name)
        Name = Name or "GothamMedium"

        local ok, EnumFont = pcall(function()
            return Enum.Font[Name]
        end)

        if not ok or typeof(EnumFont) ~= "EnumItem" then
            return nil
        end

        local Success, NewFont = pcall(function()
            return Font.fromEnum(EnumFont)
        end)

        return Success and NewFont or nil
    end

    Library.Font = GetBuiltInFont("GothamMedium") or GetBuiltInFont("SourceSans")

    local CustomFont = { }
    function CustomFont:Get(Name)
        local Builtin = GetBuiltInFont(Name)

        if Builtin then
            return Builtin
        end

        local Data = Library.FontList[Name]

        if not Data then
            return nil
        end

        local TtfPath = Library.Folders.Assets .. "/" .. Data.Id .. ".ttf"
        local JsonPath = Library.Folders.Assets .. "/" .. Data.Id .. ".json"

        if not isfile(TtfPath) then
            local Success, Bytes = pcall(function()
                return game:HttpGet(Data.Url)
            end)

            if not Success or type(Bytes) ~= "string" or #Bytes == 0 then
                return nil
            end

            if not pcall(writefile, TtfPath, Bytes) then
                return nil
            end
        end

        local Success, NewFont = pcall(function()
            local FontData = {
                name = Data.Id,
                faces = { {
                    name = "Regular",
                    weight = 400,
                    style = "Regular",
                    assetId = getcustomasset(TtfPath)
                } }
            }

            writefile(JsonPath, HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(JsonPath))
        end)

        return Success and NewFont or nil
    end

    Library.SetFont = function(self, Name)
        Name = tostring(Name or "")

        local NewFont = self.Fonts[Name]

        if not NewFont then
            NewFont = CustomFont:Get(Name)
        end

        if not NewFont then
            return false
        end

        self.Fonts[Name] = NewFont
        self.Font = NewFont
        self.FontName = Name
        self.Flags["Font"] = Name

        for _, Holder in { self.Holder, self.NotifHolder } do
            if Holder and Holder.Instance then
                for _, Item in Holder.Instance:GetDescendants() do
                    if Item:IsA("TextLabel") or Item:IsA("TextButton") or Item:IsA("TextBox") then
                        pcall(function()
                            Item.FontFace = NewFont
                        end)
                    end
                end
            end
        end

        return true
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

        local ImagePath = self.Folders.Assets .. "/" .. ImageData[1]

        if not isfile(ImagePath) then
            return
        end

        local Success, Asset = pcall(getcustomasset, ImagePath)
        return Success and Asset or nil
    end

    Library.Round = function(self, Number, Float)
        Float = tonumber(Float)

        if Float == nil or Float ~= Float or Float <= 0 then
            return MathFloor(Number + 0.5)
        end

        local Multiplier = 1 / Float
        return MathFloor(Number * Multiplier + 0.5) / Multiplier
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

        NewTween.Tween.Completed:Once(function()
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
        self.UnnamedConnections += 1
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections, HttpService:GenerateGUID(false))

        
        
        if Event == UserInputService.InputBegan then
            local UserCallback = Callback
            Callback = function(Input, GameProcessed)
                if UserInputService:GetFocusedTextBox() and Input.UserInputType == Enum.UserInputType.Keyboard then
                    return
                end
                return UserCallback(Input, GameProcessed)
            end
        end

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = Event:Connect(Callback)
        }

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

    
    Library.SetAccent = function(self, Color)
        if typeof(Color) ~= "Color3" then
            return
        end

        self.Theme.Accent = Color

        for _, ThemeData in ipairs(self.ThemeItems) do
            local Item = ThemeData.Item

            if Item and Item.Parent then
                for Property, Key in pairs(ThemeData.Properties) do
                    if Key == "Accent" then
                        pcall(function()
                            Item[Property] = Color
                        end)
                    end
                end
            end
        end
    end

    Library.ConfigRules = {
        Ignored = {
            ThreeDUI = true,
            SpotifyWidget = true,
            ConfigString = true,
        },

        ForceOff = {
            AntiAimEnabled = true,
            AntiGlueEnabled = true,
            AntiKillEnabled = true,
            AntiStompEnabled = true,
            AntiVoidEnabled = true,
            AutoBangEnabled = true,
            AutoEatEnabled = true,
            AutoFoodEnabled = true,
            AutoSuicideEnabled = true,
            AutokillEnabled = true,
            AutoReloadEnabled = true,
            AutoSwitchEnabled = true,
            DamagePredictionEnabled = true,
            FPLabFakePos = true,
            FPLabResolver = true,
            GunNoSpread = true,
            KnifebotEnabled = true,
            LegitAimEnabled = true,
            MovementFlyEnabled = true,
            MovementGravityEnabled = true,
            MovementJumpEnabled = true,
            MovementSpin = true,
            MovementWalkEnabled = true,
            MultitoolEnabled = true,
            PingSpoofEnabled = true,
            PrefireEnabled = true,
            RagebotEnabled = true,
            RapidFireEnabled = true,
            SilentAimEnabled = true,
            TrashTalkEnabled = true,
            UndergroundAnim = true,
            VoidEnabled = true,
            WallbangEnabled = true,
        },
    }

    Library.IsFinite = function(self, Value)
        return type(Value) == "number" and Value == Value and Value ~= math.huge and Value ~= -math.huge
    end

    Library.SafeConfigName = function(self, Name)
        Name = tostring(Name or "")
        Name = Name:gsub("[^%w %-%_]", "")
        Name = Name:gsub("%s+", " ")
        Name = Name:gsub("^%s+", ""):gsub("%s+$", "")
        return Name ~= "" and Name or nil
    end

    Library.Serialize = function(self)
        local Out = { Version = 3, Flags = { } }
        local Rules = self.ConfigRules

        for Index, Value in Library.Flags do
            if Rules.Ignored[Index] then
                continue
            end

            local Kind = type(Value)

            if Kind == "table" and Value.Key then
                Out.Flags[Index] = { T = "key", Key = tostring(Value.Key or "Enum.KeyCode.None"), Mode = tostring(Value.Mode or "Toggle") }
            elseif Kind == "table" and Value.Color then
                Out.Flags[Index] = { T = "color", Color = "#" .. tostring(Value.HexValue), Alpha = tonumber(Value.Alpha) or 0 }
            elseif Kind == "number" and self:IsFinite(Value) then
                Out.Flags[Index] = { T = "num", V = Value }
            elseif Kind == "boolean" then
                Out.Flags[Index] = { T = "bool", V = Value }
            elseif Kind == "string" then
                Out.Flags[Index] = { T = "str", V = Value }
            elseif Kind == "table" then
                local List = { }
                local Clean = true

                for _, Item in ipairs(Value) do
                    if type(Item) == "string" then
                        List[#List + 1] = Item
                    else
                        Clean = false
                        break
                    end
                end

                if Clean and #List > 0 then
                    Out.Flags[Index] = { T = "list", V = List }
                end
            end
        end

        return Out
    end

    Library.NormalizeLegacy = function(self, Map)
        if type(Map) ~= "table" then
            return nil
        end

        local Out = { }
        local Count = 0

        for Index, Value in Map do
            local Kind = type(Value)

            if Kind == "table" and Value.Key then
                Out[Index] = { T = "key", Key = tostring(Value.Key or "Enum.KeyCode.None"), Mode = tostring(Value.Mode or "Toggle") }
                Count += 1
            elseif Kind == "table" and Value.Color then
                Out[Index] = { T = "color", Color = tostring(Value.Color), Alpha = tonumber(Value.Alpha) or 0 }
                Count += 1
            elseif Kind == "number" and self:IsFinite(Value) then
                Out[Index] = { T = "num", V = Value }
                Count += 1
            elseif Kind == "boolean" then
                Out[Index] = { T = "bool", V = Value }
                Count += 1
            elseif Kind == "string" then
                Out[Index] = { T = "str", V = Value }
                Count += 1
            elseif Kind == "table" then
                local List = { }

                for _, Item in ipairs(Value) do
                    if type(Item) == "string" then
                        List[#List + 1] = Item
                    end
                end

                Out[Index] = { T = "list", V = List }
                Count += 1
            end
        end

        return Count > 0 and Out or nil
    end

    Library.ApplyConfig = function(self, Saved)
        local Flags = type(Saved) == "table" and Saved.Flags or nil

        if not Flags then
            Flags = self:NormalizeLegacy(Saved)
        end

        if not Flags then
            return false, "not a valid config"
        end

        local Rules = self.ConfigRules
        local Applied = 0

        for Index, Entry in Flags do
            if type(Entry) ~= "table" or not Entry.T then
                continue
            end

            if Rules.Ignored[Index] then
                continue
            end

            local Set = Library.SetFlags[Index]

            if not Set then
                continue
            end

            local Kind = Entry.T

            if Rules.ForceOff[Index] then
                if Kind == "bool" then
                    Set(false)
                    Applied += 1
                end

                continue
            end

            if Kind == "key" then
                Set({ Key = tostring(Entry.Key or "Enum.KeyCode.None"), Mode = tostring(Entry.Mode or "Toggle") })
                Applied += 1
            elseif Kind == "color" then
                local OkColor, Color = pcall(function()
                    return Color3.fromHex(tostring(Entry.Color))
                end)

                if OkColor and Color then
                    Set(Color, tonumber(Entry.Alpha) or 0)
                    Applied += 1
                end
            elseif Kind == "num" then
                local Number = tonumber(Entry.V)

                if self:IsFinite(Number) then
                    Set(Number)
                    Applied += 1
                end
            elseif Kind == "bool" then
                Set(Entry.V == true)
                Applied += 1
            elseif Kind == "str" then
                Set(tostring(Entry.V))
                Applied += 1
            elseif Kind == "list" then
                Set(Entry.V)
                Applied += 1
            end
        end

        return true, Applied
    end

    Library.GetConfig = function(self)
        return HttpService:JSONEncode(self:Serialize())
    end

    Library.LoadConfig = function(self, Config)
        local OkDecoded, Decoded = pcall(function()
            if type(Config) == "table" then
                return Config
            end

            return HttpService:JSONDecode(tostring(Config or ""))
        end)

        if not OkDecoded then
            Library:Notification("Error", "Config is not valid JSON", 5, Color3.fromRGB(255, 90, 90))
            return false, "invalid json"
        end

        local OkApply, Result = self:ApplyConfig(Decoded)

        if OkApply then
            Library:Notification("Successfully loaded config", 5, Color3.fromRGB(0, 255, 0))
        else
            Library:Notification("Error", tostring(Result), 5, Color3.fromRGB(255, 90, 90))
        end

        return OkApply, Result
    end

    Library.GetTheme = function(self)
        local Saved = self:Serialize()
        local Out = { Version = 3, Theme = true, Flags = { } }

        for Index, Entry in Saved.Flags do
            if Entry.T == "color" and Index:sub(1, 5) == "Theme" then
                Out.Flags[Index] = Entry
            end
        end

        return HttpService:JSONEncode(Out)
    end

    Library.LoadTheme = function(self, Config)
        local OkDecoded, Decoded = pcall(function()
            if type(Config) == "table" then
                return Config
            end

            return HttpService:JSONDecode(tostring(Config or ""))
        end)

        if not OkDecoded or type(Decoded) ~= "table" or type(Decoded.Flags) ~= "table" then
            Library:Notification("Error", "Theme file is not valid", 5, Color3.fromRGB(255, 90, 90))
            return false, "invalid theme"
        end

        local Applied = 0

        for Index, Entry in Decoded.Flags do
            if type(Entry) == "table" and Entry.T == "color" and Index:sub(1, 5) == "Theme" then
                local Set = Library.SetFlags[Index]

                if Set then
                    local OkColor, Color = pcall(function()
                        return Color3.fromHex(tostring(Entry.Color))
                    end)

                    if OkColor and Color then
                        Set(Color, tonumber(Entry.Alpha) or 0)
                        Applied += 1
                    end
                end
            end
        end

        local Done = Applied > 0

        Library:Notification(Done and "Success" or "Error", Done and "Loaded theme" or "Theme has no colors", 5, Done and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 90, 90))

        return Done, Applied
    end

    Library.DeleteConfig = function(self, Config)
        local Name = self:SafeConfigName(Config)

        if not Name then
            return false
        end

        local Path = Library.Folders.Configs .. "/" .. Name

        if not isfile(Path) and isfile(Path .. ".json") then
            Path = Path .. ".json"
        end

        if isfile(Path) then
            delfile(Path)
            Library:Notification("Deleted config " .. Name, 5, Color3.fromRGB(0, 255, 0))
            return true
        end

        return false
    end

    Library.SaveConfig = function(self, Config)
        local Name = self:SafeConfigName(Config)

        if not Name then
            return false
        end

        local Path = Library.Folders.Configs .. "/" .. Name

        if not isfile(Path) and isfile(Path .. ".json") then
            Path = Path .. ".json"
        end

        local OkWrite = pcall(function()
            writefile(Path, self:GetConfig())
        end)

        local Saved = OkWrite and isfile(Path)

        if Saved then
            Library:Notification("Saved config " .. Name, 5, Color3.fromRGB(0, 255, 0))
        else
            Library:Notification("Error", "Failed saving config " .. Name, 5, Color3.fromRGB(255, 90, 90))
        end

        return Saved
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

        
        if Theme == "Accent" then
            for _, Callback in self.AccentRefreshers do
                pcall(Callback, Color)
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
                BorderColor3 = FromRGB(8, 8, 9),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Watermark"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 17),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
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
                BackgroundColor3 = FromRGB(168, 138, 232)
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
                BorderColor3 = FromRGB(8, 8, 9),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 17),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 13, 0, 2),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
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
        local KeybindList = { Enabled = false }
        self.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(8, 8, 9),
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 15, 0.5, 0),
                Size = UDim2New(0, 200, 0, 18),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(168, 138, 232)
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Name = "\0",
                Size = UDim2New(1, 0, 0, 17),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 14,
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
                Size = UDim2New(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "[" .. Key .. "] " .. Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 17),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                BorderSizePixel = 0,
                TextSize = 11,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = NewKey.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        
            function NewKey:Set(Mode, Name, Key)
                NewKey.Instance.Text = "[" .. Key .. "] " .. Name
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

            function NewKey:SetVisible(Bool)
                NewKey.Instance.Visible = Bool

                if not Bool then
                    NewKey.Instance.Text = ""
                end
            end

            return NewKey
        end

        function KeybindList:Refresh()
            local AnyVisible = false

            for _, Child in Items["Content"].Instance:GetChildren() do
                if Child:IsA("TextLabel") and Child.Visible then
                    AnyVisible = true
                    break
                end
            end

            Items["KeybindList"].Instance.Visible = (KeybindList.Enabled ~= false) and AnyVisible
        end

        function KeybindList:SetVisibility(Bool)
            KeybindList.Enabled = Bool
            KeybindList:Refresh()
        end

        Items["KeybindList"].Instance.Visible = false

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
                Color = FromRGB(42, 42, 48)
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
                BorderColor3 = FromRGB(8, 8, 9),
                Visible = false,
                Size = UDim2New(0, 238, 0, 224),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["ColorpickerWindow"]:MakeDraggable()
            Items["ColorpickerWindow"]:MakeResizeable(Vector2New(200, 180), Vector2New(9999, 9999))

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Data.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 17),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, -2, 0, -3),
                BorderSizePixel = 0,
                TextSize = 14,
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
                BackgroundColor3 = FromRGB(168, 138, 232)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 8),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
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
                Color = FromRGB(42, 42, 48)
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
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Image = Library:GetImage("Hue"),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 17),
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
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
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
                Color = FromRGB(42, 42, 48)
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
                Color = FromRGB(42, 42, 48)
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

            NewTween.Tween.Completed:Once(function()
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

        function Colorpicker:Update(IsFromAlpha, Animate)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            
            
            
            if Animate == false then
                Items["ColorpickerButton"].Instance.BackgroundColor3 = self.Color
                Items["Palette"].Instance.BackgroundColor3 = FromHSV(self.Hue, 1, 1)

                if not IsFromAlpha then
                    Items["Alpha"].Instance.BackgroundColor3 = self.Color
                end
            else
                Items["ColorpickerButton"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
                Items["Palette"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

                if not IsFromAlpha then 
                    Items["Alpha"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
                end
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

            Items["PaletteDragger"].Instance.Position = UDim2New(SlideX, 0, SlideY, 0)
            self:Update(nil, false)            
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            local PositionY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.994)

            Items["HueDragger"].Instance.Position = UDim2New(0, 0, PositionY, 0)
            self:Update(nil, false)
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local PositionX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.994)

            Items["AlphaDragger"].Instance.Position = UDim2New(PositionX, 0, 0, 0)
            self:Update(true, false)
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
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
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
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
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
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if not (SlidingPalette or SlidingHue or SlidingAlpha) then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
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
            Value = "None",
            Mode = "Toggle",

            Toggled = false,
            IsOpen = false,

            Picking = false,

            Class = "Keybind"
        }

        local function IsBoundKey(Key)
            return type(Key) == "string" and Key ~= "" and Key ~= "None" and Key ~= "nil" and Key ~= "Enum.KeyCode.None"
        end

        Library.Flags[Data.Flag] = { Mode = "Toggle", Toggled = false }

        local KeyListItem

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(42, 42, 48),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 1, 1),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

            if Library.KeyList then 
                KeyListItem = Library.KeyList:Add(Keybind.Mode, Data.Name, Keybind.Value)
            end
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(8, 8, 9)
            }):AddToTheme({Color = "Border"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["KeyButton"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "None",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
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
                BorderColor3 = FromRGB(8, 8, 9),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 1, 5),
                Size = UDim2New(0, 50, 0, 48),
                BorderSizePixel = 2,
                Visible = false,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Window"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(168, 138, 232),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 0, 17),
                TextSize = 14,
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Hold",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 15),
                Size = UDim2New(1, 0, 0, 17),
                TextSize = 14,
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Always",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 30),
                Size = UDim2New(1, 0, 0, 17),
                TextSize = 14,
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

        Items["Toggle"]:ChangeItemTheme({TextColor3 = "Accent"})
        Items["Toggle"].Instance.TextColor3 = Library.Theme.Accent

        local Update = function()
            if KeyListItem then
                local Bound = IsBoundKey(Keybind.Key)

                KeyListItem:SetVisible(Bound)

                if Bound then
                    KeyListItem:Set(Keybind.Mode, Data.Name, Keybind.Value)
                    KeyListItem:SetStatus(Keybind.Toggled and "Active" or "Inactive")
                end

                if Library.KeyList and Library.KeyList.Refresh then
                    Library.KeyList:Refresh()
                end
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

        local function RefreshKeyLabel()
            Keybind.Picking = false
            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Text"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X, 1, 1)
            Update()
        end

        function Keybind:Unbind()
            local Always = Keybind.Mode == "Always"

            Keybind.Key = nil
            Keybind.Value = "None"
            Keybind.Toggled = Always
            Items["Text"].Instance.Text = "None"

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Toggled = Always
            }

            RefreshKeyLabel()

            if Data.Callback then
                Library:SafeCall(Data.Callback, Always)
            end
        end

        function Keybind:Set(Key)
            local IsEnum = typeof(Key) == "EnumItem"
                or (type(Key) == "table" and Key.EnumType ~= nil and Key.Name ~= nil)

            if not IsEnum and type(Key) == "table" then
                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                end

                local RawKey = Key.Key

                if RawKey == nil or RawKey == "" or RawKey == "None" or RawKey == "nil" or RawKey == "MB1" or RawKey == "MB2" or tostring(RawKey) == "Enum.KeyCode.Backspace" or tostring(RawKey) == "Enum.KeyCode.None" then
                    Keybind:Unbind()
                    return
                end

                Key = RawKey
            end

            IsEnum = typeof(Key) == "EnumItem"
                or (type(Key) == "table" and Key.EnumType ~= nil and Key.Name ~= nil)

            if Key == nil then
                Keybind:Unbind()
                return
            end

            if type(Key) == "string" then
                if Key == "Toggle" or Key == "Hold" or Key == "Always" then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)
                    RefreshKeyLabel()
                    return
                end

                if Key == "" or Key == "None" or Key == "nil" or Key == "MB1" or Key == "MB2" or Key == "Enum.KeyCode.Backspace" or Key == "Enum.KeyCode.None" or StringFind(Key, "UserInputType.") then
                    Keybind:Unbind()
                    return
                end
            end

            if IsEnum then
                if Key.EnumType == Enum.KeyCode and (Key.Name == "Backspace" or Key.Name == "None") then
                    Keybind:Unbind()
                    return
                end

                
                if Key.EnumType == Enum.UserInputType
                    and (Key == Enum.UserInputType.MouseButton1 or Key == Enum.UserInputType.MouseButton2 or Key == Enum.UserInputType.MouseButton3) then
                    RefreshKeyLabel()
                    return
                end

                Keybind.Key = tostring(Key)
                Keybind.Value = Key.Name
            elseif type(Key) == "string" then
                Keybind.Key = Key

                local Name = StringGSub(StringGSub(StringGSub(Key, "Enum.", ""), "KeyCode.", ""), "UserInputType.", "")
                Keybind.Value = Keys[Name] or Name
            else
                RefreshKeyLabel()
                return
            end

            Items["Text"].Instance.Text = Keybind.Value

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            RefreshKeyLabel()

            if Data.Callback then
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end
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
            if Keybind.Mode ~= "Always" and not IsBoundKey(Keybind.Key) then
                Keybind.Toggled = false
            elseif Keybind.Mode == "Toggle" then
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
                    if Input.KeyCode == Enum.KeyCode.Escape then
                        RefreshKeyLabel()
                    elseif Input.KeyCode == Enum.KeyCode.Backspace then
                        Keybind:Unbind()
                    else
                        Keybind:Set(Input.KeyCode)
                    end
                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2 then
                    
                    RefreshKeyLabel()
                else
                    RefreshKeyLabel()
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            if Keybind.Picking then
                return
            end

            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if UserInputService:GetFocusedTextBox() then
                return
            end

            if Input.UserInputType == Enum.UserInputType.Keyboard and IsBoundKey(Keybind.Key) and tostring(Input.KeyCode) == Keybind.Key then
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
            if Input.UserInputType == Enum.UserInputType.Keyboard and IsBoundKey(Keybind.Key) and tostring(Input.KeyCode) == Keybind.Key then
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

        Update()

        return Keybind
    end

    
    
    
    

    Library.LogoPath = "functionmeta_title.png"
    Library.LogoHeight = 26
    Library.LogoForName = "Function.Meta"

    Library.DecodeBase64 = function(self, Data)
        Data = tostring(Data or ""):gsub("%s", "")

        local Map = self.Base64Map

        if not Map then
            Map = { }

            local Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

            for Index = 1, #Chars do
                Map[Chars:sub(Index, Index)] = Index - 1
            end

            self.Base64Map = Map
        end

        local Out = { }
        local Length = #Data

        for Index = 1, Length, 4 do
            local A = Map[Data:sub(Index, Index)] or 0
            local B = Map[Data:sub(Index + 1, Index + 1)] or 0
            local CChar = Data:sub(Index + 2, Index + 2)
            local DChar = Data:sub(Index + 3, Index + 3)
            local C = Map[CChar]
            local D = Map[DChar]

            Out[#Out + 1] = string.char(A * 4 + math.floor(B / 16))

            if CChar ~= "=" and CChar ~= "" then
                Out[#Out + 1] = string.char((B % 16) * 16 + math.floor((C or 0) / 4))
            end

            if DChar ~= "=" and DChar ~= "" and CChar ~= "=" then
                Out[#Out + 1] = string.char(((C or 0) % 4) * 64 + (D or 0))
            end
        end

        return table.concat(Out)
    end

    Library.LoadLogo = function(self)
        if self.LogoImage ~= nil then
            return self.LogoImage or nil
        end

        self.LogoImage = false

        if self.DisableLogo or type(self.LogoBase64) ~= "string" then
            return nil
        end

        if type(getcustomasset) ~= "function" or type(writefile) ~= "function" then
            return nil
        end

        local Path = self.LogoPath
        local Wrote = pcall(function()
            if type(isfile) == "function" then
                local Exists = false
                pcall(function()
                    Exists = isfile(Path)
                end)

                if Exists then
                    return
                end
            end

            writefile(Path, self:DecodeBase64(self.LogoBase64))
        end)

        if not Wrote then
            return nil
        end

        local Success, Asset = pcall(getcustomasset, Path)

        if Success and type(Asset) == "string" and Asset ~= "" then
            self.LogoImage = Asset
            return Asset
        end

        return nil
    end

    
    
    

    Library.TrackFeature = function(self, Element, Row, Class)
        if not Element or not Row then
            return
        end

        local Name = Element.Name

        if type(Name) ~= "string" or Name == "" then
            return
        end

        self.FeatureRegistry[#self.FeatureRegistry + 1] = {
            Name = Name,
            LowerName = StringLower(Name),
            Class = Class or Element.Class or "Element",
            Row = Row,
            Page = Element.Page,
            Section = Element.Section,
            Window = Element.Window,
            Element = Element
        }
    end

    Library.TrackSection = function(self, Section, Apply)
        if not Section or not Apply then
            return
        end

        self.TrackedSections[#self.TrackedSections + 1] = {
            Section = Section,
            Window = Section.Window,
            Apply = Apply
        }
    end

    Library.FilterFeatures = function(self, Window, Query)
        if not Window then
            return
        end

        Query = StringLower(Query or "")
        local Filtering = Query ~= ""

        local SectionVisible = { }
        local PageVisible = { }
        local SectionMatch = { }
        local PageMatch = { }

        if Filtering then
            
            for _, Tracked in self.TrackedSections do
                local Section = Tracked.Section
                local Name = Section and Section.Name

                if Tracked.Window == Window and type(Name) == "string"
                    and StringFind(StringLower(Name), Query, 1, true) then
                    SectionMatch[Section] = true
                end
            end

            
            for _, Page in Window.Pages do
                if StringFind(StringLower(Page.Name or ""), Query, 1, true) then
                    PageMatch[Page] = true
                end

                for _, SubPage in (Page.SubPages or { }) do
                    if StringFind(StringLower(SubPage.Name or ""), Query, 1, true) then
                        PageMatch[Page] = true
                    end
                end
            end
        end

        for _, Entry in self.FeatureRegistry do
            if Entry.Window == Window then
                local Page = Entry.Page

                if Page and Page.Page then
                    Page = Page.Page
                end

                local Match = true

                if Filtering then
                    Match = StringFind(Entry.LowerName, Query, 1, true) ~= nil
                        or SectionMatch[Entry.Section] == true
                        or (Page ~= nil and PageMatch[Page] == true)
                end

                Entry.Row.Visible = Match

                if Match then
                    SectionVisible[Entry.Section] = true

                    if Page then
                        PageVisible[Page] = true
                    end
                end
            end
        end

        for _, Tracked in self.TrackedSections do
            if Tracked.Window == Window then
                local Owned = false

                for _, Entry in self.FeatureRegistry do
                    if Entry.Section == Tracked.Section then
                        Owned = true
                        break
                    end
                end

                if Owned then
                    local Show = SectionVisible[Tracked.Section] == true
                        or SectionMatch[Tracked.Section] == true

                    Tracked.Apply(Tracked.Section, Show or not Filtering)
                end
            end
        end

        
        
        for _, Group in self.SearchGroups do
            if Group.Window == Window and #Group.Members > 0 then
                local Any = not Filtering

                if not Any then
                    for _, Member in Group.Members do
                        if SectionVisible[Member] == true or SectionMatch[Member] == true then
                            Any = true
                            break
                        end
                    end
                end

                Group.Container.Visible = Any
            end
        end

        local ActivePage

        for _, Page in Window.Pages do
            if Page.Active then
                ActivePage = Page
            end
        end

        local FirstVisible

        for _, Page in Window.Pages do
            local Has = PageVisible[Page] == true or PageMatch[Page] == true or not Filtering

            if Has and not FirstVisible then
                FirstVisible = Page
            end

            local Label = Page.Elements and Page.Elements["Text"]

            if Label then
                if Filtering and not Has then
                    Label.Instance.TextTransparency = 0.75
                else
                    Label.Instance.TextTransparency = Page.Active and 0 or 0.5
                end
            end
        end

        
        if Filtering and not FirstVisible then
            FirstVisible = ActivePage
        elseif Filtering and ActivePage
            and PageVisible[ActivePage] ~= true and PageMatch[ActivePage] ~= true then
            for _, Page in Window.Pages do
                Page:Turn(Page == FirstVisible)

                local Label = Page.Elements and Page.Elements["Text"]

                
                if Label and PageVisible[Page] ~= true and PageMatch[Page] ~= true then
                    Label.Instance.TextTransparency = 0.75
                end
            end

            ActivePage = FirstVisible
        end

        local NoResults = Window.Elements and Window.Elements["NoResults"]

        if NoResults then
            local Show = Filtering
                and (ActivePage == nil
                    or (PageVisible[ActivePage] ~= true and PageMatch[ActivePage] ~= true))

            NoResults.Instance.Visible = Show
        end
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

        local baseWidth = Window.Size.X.Offset
        local baseHeight = Window.Size.Y.Offset

        if Library.IsMobile then
            local viewport = Camera.ViewportSize
            Window.Size = UDim2New(
                0, math.min(baseWidth, math.floor(viewport.X * 0.92)),
                0, math.min(baseHeight, math.floor(viewport.Y * 0.8))
            )
        end

        local Items = { } do 
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(8, 8, 9),
                Size = Window.Size,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            local initialX = math.max(16, (Camera.ViewportSize.X - Window.Size.X.Offset) / 2)
            local initialY = math.max(16, (Camera.ViewportSize.Y - Window.Size.Y.Offset) / 2)
            Items["MainFrame"].Instance.Position = UDim2New(0, initialX, 0, initialY)

            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))

            if Library.IsMobile then
                Library:Connect(Camera:GetPropertyChangedSignal("ViewportSize"), function()
                    local viewport = Camera.ViewportSize
                    Items["MainFrame"].Instance.Size = UDim2New(
                        0, math.min(baseWidth, math.floor(viewport.X * 0.92)),
                        0, math.min(baseHeight, math.floor(viewport.Y * 0.8))
                    )
                end)
            end

            
            Items["AccentBorder"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Thickness = 2,
                Color = FromRGB(168, 138, 232)
            })  Items["AccentBorder"]:AddToTheme({Color = "Accent"})

            
            
            local function BorderRamp(Accent)
                return RGBSequence{
                    RGBSequenceKeypoint(0, Accent:Lerp(Color3.new(0, 0, 0), 0.8)),
                    RGBSequenceKeypoint(0.25, Accent:Lerp(Color3.new(1, 1, 1), 0.9)),
                    RGBSequenceKeypoint(0.5, Accent:Lerp(Color3.new(0, 0, 0), 0.8)),
                    RGBSequenceKeypoint(0.75, Accent:Lerp(Color3.new(1, 1, 1), 0.9)),
                    RGBSequenceKeypoint(1, Accent:Lerp(Color3.new(0, 0, 0), 0.8))
                }
            end

            Items["AccentBorderGradient"] = Instances:Create("UIGradient", {
                Parent = Items["AccentBorder"].Instance,
                Rotation = 0,
                Color = BorderRamp(Library.Theme.Accent)
            })

            Library.AccentRefreshers[#Library.AccentRefreshers + 1] = function(Accent)
                Items["AccentBorderGradient"].Instance.Color = BorderRamp(Accent)
            end

            TweenService:Create(
                Items["AccentBorderGradient"].Instance,
                TweenInfo.new(4.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                { Rotation = 180 }
            ):Play()

            
            TweenService:Create(
                Items["AccentBorder"].Instance,
                TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                { Thickness = 2.6 }
            ):Play()
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 20),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 14, 0, 10),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            
            local LogoHeight = Library.LogoHeight or 26
            local LogoWidth = math.floor(LogoHeight * 5.593 + 0.5)

            Items["Logo"] = Instances:Create("ImageLabel", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = "",
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2New(0, LogoWidth, 0, LogoHeight),
                Position = UDim2New(0, 15, 0, math.floor((40 - LogoHeight) / 2)),
                ImageColor3 = FromRGB(255, 255, 255),
                Visible = false
            })

            Items["LogoGradient"] = Instances:Create("UIGradient", {
                Parent = Items["Logo"].Instance,
                Rotation = 0,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, Library.Theme.Accent),
                    RGBSequenceKeypoint(1, Library.Theme.Accent)
                }
            })

            local ShowLogo = Library.DisableLogo ~= true
                and (Library.LogoForName == nil or Window.Name == Library.LogoForName)

            if ShowLogo and Library:LoadLogo() then
                Items["Logo"].Instance.Image = Library.LogoImage
                Items["Logo"].Instance.Visible = true
                Items["Title"].Instance.Visible = false
            end

            
            
            Items["TitleGradient"] = Instances:Create("UIGradient", {
                Parent = Items["Title"].Instance,
                Rotation = 12,
                Color = RGBSequence{
                    RGBSequenceKeypoint(0, Color3.new(1, 1, 1)),
                    RGBSequenceKeypoint(1, Color3.new(1, 1, 1))
                }
            })

            local SHIMMER_WIDTH = 0.07   
            local SHIMMER_CORE = 0.55    
            local SHIMMER_SPEED = 0.3    
            local shimmerTime = 0
            local shimmerAccum = 0

            
            
            local function buildShimmer(accent, t)
                local white = Color3.new(1, 1, 1)
                local head = (t * SHIMMER_SPEED) % 1
                local w = SHIMMER_WIDTH

                local xs = { 0, 1 }

                for _, offset in ipairs({ -w, -w * SHIMMER_CORE, w * SHIMMER_CORE, w }) do
                    local x = head + offset

                    if x > 0.001 and x < 0.999 then
                        xs[#xs + 1] = x
                    end
                end

                table.sort(xs)

                local points = {}
                local last = -1

                for _, x in ipairs(xs) do
                    if x - last > 0.001 then
                        local d = math.abs(x - head)
                        d = math.min(d, 1 - d)

                        local k

                        if d <= w * SHIMMER_CORE then
                            k = 1
                        elseif d <= w then
                            k = (w - d) / (w * (1 - SHIMMER_CORE))
                        else
                            k = 0
                        end

                        points[#points + 1] = RGBSequenceKeypoint(x, accent:Lerp(white, k))
                        last = x
                    end
                end

                return RGBSequence(points)
            end

            Library:Connect(RunService.RenderStepped, function(dt)
                shimmerTime += dt

                if not Window.IsOpen then
                    return
                end

                shimmerAccum += dt

                if shimmerAccum >= 1 / 30 then
                    shimmerAccum = 0

                    local accent = Library.Theme.Accent or FromRGB(168, 138, 232)
                    local UsingLogo = Items["Logo"].Instance.Visible

                    pcall(function()
                        
                        local Sequence = buildShimmer(accent, shimmerTime)

                        if UsingLogo then
                            Items["LogoGradient"].Instance.Color = Sequence
                        else
                            Items["Title"].Instance.TextColor3 = Color3.new(1, 1, 1)
                            Items["TitleGradient"].Instance.Color = Sequence
                        end
                    end)
                end
            end)

            
            Items["SearchBar"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2New(1, -14, 0, 7),
                Size = UDim2New(0, 232, 0, 26),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["SearchLine"] = Instances:Create("Frame", {
                Parent = Items["SearchBar"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 42, 48)
            })  Items["SearchLine"]:AddToTheme({BackgroundColor3 = "Outline"})

            Items["SearchUnderline"] = Instances:Create("Frame", {
                Parent = Items["SearchBar"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 1),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent
            })  Items["SearchUnderline"]:AddToTheme({BackgroundColor3 = "Accent"})

            Items["SearchBox"] = Instances:Create("TextBox", {
                Parent = Items["SearchBar"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                PlaceholderColor3 = FromRGB(152, 152, 160),
                Text = "",
                PlaceholderText = "Search features...",
                Name = "\0",
                Size = UDim2New(1, -20, 1, -2),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                ClearTextOnFocus = false,
                TextSize = 13
            })  Items["SearchBox"]:AddToTheme({TextColor3 = "Text", PlaceholderColor3 = "Placeholder Text"})

            Items["SearchClear"] = Instances:Create("TextButton", {
                Parent = Items["SearchBar"].Instance,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, 0, 0.5, -1),
                Size = UDim2New(0, 14, 0, 14),
                BackgroundTransparency = 1,
                Text = "x",
                FontFace = Library.Font,
                TextColor3 = FromRGB(152, 152, 160),
                TextSize = 11,
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Name = "\0",
                Visible = false
            })  Items["SearchClear"]:AddToTheme({TextColor3 = "Placeholder Text"})

            local function ApplySearch(Text)
                Items["SearchClear"].Instance.Visible = Text ~= ""
                Library:FilterFeatures(Window, Text)
            end

            Items["SearchBox"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                ApplySearch(Items["SearchBox"].Instance.Text)
            end)

            Items["SearchBox"]:Connect("Focused", function()
                Items["SearchUnderline"].Instance.BackgroundTransparency = 0
                Items["SearchBox"].Instance.PlaceholderColor3 = Library.Theme.Accent
            end)

            Items["SearchBox"]:Connect("FocusLost", function()
                Items["SearchUnderline"].Instance.BackgroundTransparency = 1
                Items["SearchBox"].Instance.PlaceholderColor3 = Library.Theme["Placeholder Text"]
            end)

            Items["SearchClear"]:Connect("MouseButton1Down", function()
                Items["SearchBox"].Instance.Text = ""
                ApplySearch("")
                Items["SearchBox"].Instance:CaptureFocus()
            end)

            Items["SearchClear"]:Connect("MouseEnter", function()
                Items["SearchClear"].Instance.TextColor3 = Library.Theme.Accent
            end)

            Items["SearchClear"]:Connect("MouseLeave", function()
                Items["SearchClear"].Instance.TextColor3 = Library.Theme["Placeholder Text"]
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.KeyCode == Enum.KeyCode.Slash and Window.IsOpen then
                    Items["SearchBox"].Instance:CaptureFocus()
                end
            end)

            Items["HeaderLine"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 12, 0, 40),
                Size = UDim2New(1, -24, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 42, 48)
            })  Items["HeaderLine"]:AddToTheme({BackgroundColor3 = "Outline"})

            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 8, 0, 44),
                BorderColor3 = FromRGB(42, 42, 48),
                Size = UDim2New(1, -16, 1, -52),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 23)
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
                Position = UDim2New(0, 10, 0, 10),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -20, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 10, 0, 48),
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(1, -20, 1, -58),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

        
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})

            Items["NoResults"] = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(152, 152, 160),
                Text = "No matching features",
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 50,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["NoResults"]:AddToTheme({TextColor3 = "Placeholder Text"})
        end

        local Debounce = false

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool
            Items["MainFrame"].Instance.Visible = Bool
            if not Bool then
                Library:CloseDropdowns()
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == tostring(Library.MenuKeybind) or tostring(Input.UserInputType) == tostring(Library.MenuKeybind) then
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
                BorderColor3 = FromRGB(8, 8, 9),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(28, 28, 32)
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
                TextColor3 = FromRGB(224, 224, 228),
                TextTransparency = 0.47999998927116394,
                Text = Page.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 14,
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
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 42, 48)
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
                BackgroundColor3 = FromRGB(42, 42, 48)
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
                        ScrollBarImageColor3 = FromRGB(168, 138, 232),
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
                        PaddingTop = UDimNew(0, 12),
                        PaddingBottom = UDimNew(0, 12),
                        PaddingRight = UDimNew(0, 12),
                        PaddingLeft = UDimNew(0, 12)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Padding = UDimNew(0, 10),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }) 

                    Page.ColumnsData[Index] = NewColumn
                end
            else
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 10, 0, 50),
                    BorderColor3 = FromRGB(8, 8, 9),
                    Size = UDim2New(1, -20, 1, -60),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(14, 14, 16)
                })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["SubTabs"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 10),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -20, 0, 34),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = Items["SubTabs"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end
        end

        local Debounce = false

        function Page:Turn(Bool)
            Page.Active = Bool
            Items["Page"].Instance.Visible = Bool
            Items["Hide"].Instance.Visible = Bool

            if Bool then
                Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                Items["Text"].Instance.TextColor3 = Library.Theme.Accent
                Items["Text"].Instance.TextTransparency = 0
            else
                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                Items["Text"].Instance.TextColor3 = Library.Theme.Text
                Items["Text"].Instance.TextTransparency = 0.5
            end
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            Library:CloseDropdowns()
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
                BorderColor3 = FromRGB(8, 8, 9),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -2),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(28, 28, 32)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
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
                BackgroundColor3 = FromRGB(20, 20, 23)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(42, 42, 48)
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
                BackgroundColor3 = FromRGB(42, 42, 48)
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
                    TextColor3 = FromRGB(224, 224, 228),
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
                PaddingTop = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 8)
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
                Color = FromRGB(42, 42, 48),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            for Index = 1, SubPage.Columns do
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Subtab"].Instance,
                    ScrollBarImageColor3 = FromRGB(168, 138, 232),
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
                    PaddingTop = UDimNew(0, 8),
                    PaddingBottom = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 

                SubPage.ColumnsData[Index] = NewColumn
            end
        end

        local Debounce = false

        function SubPage:Turn(Bool)
            SubPage.Active = Bool
            Items["Subtab"].Instance.Visible = Bool
            Items["Hide"].Instance.Visible = Bool
            Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, Bool and 1 or -2)

            if SubPage.Icon then
                Items["Icon"]:ChangeItemTheme({ImageColor3 = Bool and "Accent" or "Text"})
                Items["Icon"].Instance.ImageColor3 = Bool and Library.Theme.Accent or Library.Theme.Text
                Items["Icon"].Instance.ImageTransparency = Bool and 0 or 0.35
            else
                Items["Icon"]:ChangeItemTheme({TextColor3 = Bool and "Accent" or "Text"})
                Items["Icon"].Instance.TextColor3 = Bool and Library.Theme.Accent or Library.Theme.Text
                Items["Icon"].Instance.TextTransparency = Bool and 0 or 0.35
            end
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            Library:CloseDropdowns()
            local PageSubPages = (SubPage.Page and SubPage.Page.SubPages) or SubPage.Window.SubPages

            for Index, Value in PageSubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if SubPage.Page and SubPage.Page.SubPages then
            if #SubPage.Page.SubPages == 0 then
                SubPage:Turn(true)
            else
                Items["Subtab"].Instance.Visible = false
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
                Size = UDim2New(1, 0, 0, 28),
                BorderColor3 = FromRGB(42, 42, 48),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 23)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(8, 8, 9),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 8)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(168, 138, 232)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -16, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 8, 0, 5),
                BorderSizePixel = 0,
                TextSize = 14,
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
                Position = UDim2New(0, 8, 0, 28),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -16, 1, -27),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        Library:TrackSection(Section, function(_, Bool)
            Items["Section"].Instance.Visible = Bool
        end)

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
                Size = UDim2New(1, 0, 0, 28),
                BorderColor3 = FromRGB(42, 42, 48),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 23)
            })  Items["MultiSection"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["MultiSection"].Instance,
                Color = FromRGB(8, 8, 9),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["MultiSection"].Instance,
                PaddingBottom = UDimNew(0, 8)
            }) 
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(168, 138, 232)
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
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(14, 14, 16)
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
                    BorderColor3 = FromRGB(8, 8, 9),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(28, 28, 32)
                })  SubItems["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                SubItems["Text"] = Instances:Create("TextLabel", {
                    Parent = SubItems["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(224, 224, 228),
                    TextTransparency = 0.48,
                    Text = NewSection.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 14,
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
                    BackgroundColor3 = FromRGB(14, 14, 16)
                })  SubItems["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

                SubItems["MiscPixel1"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    Size = UDim2New(0, 1, 0, 1),
                    Name = "\0",
                    Position = UDim2New(0, -1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(42, 42, 48)
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
                    BackgroundColor3 = FromRGB(42, 42, 48)
                })  SubItems["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0",
                    Color = FromRGB(42, 42, 48)
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
                    Padding = UDimNew(0, 10),
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

                NewTween.Tween.Completed:Once(function()
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

            Library:TrackSection(NewSection, function(_, Bool)
                SubItems["Inactive"].Instance.Visible = Bool
                SubItems["Content"].Instance.Visible = Bool and NewSection.Active
            end)

            MultiSection.SectionContents[#MultiSection.SectionContents+1] = setmetatable(NewSection, Library.Sections)
        end

        Library.SearchGroups[#Library.SearchGroups + 1] = {
            Window = MultiSection.Window,
            Container = Items["MultiSection"].Instance,
            Members = MultiSection.SectionContents
        }

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
                BorderColor3 = FromRGB(42, 42, 48),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 23)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Items["Fade"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 2),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = FromRGB(42, 42, 48)
            })  Items["Fade"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIGradient", {
                Parent = Items["Fade"].Instance,
                Rotation = -90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.718, 0.768750011920929), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(8, 8, 9),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 8)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(168, 138, 232)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -16, 0, 16),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 8, 0, 5),
                BorderSizePixel = 0,
                TextSize = 14,
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
                ScrollBarImageColor3 = FromRGB(168, 138, 232),
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
                Padding = UDimNew(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        Library:TrackSection(Section, function(_, Bool)
            Items["Section"].Instance.Visible = Bool
        end)

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
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(1, 0, 0, 3),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(14, 14, 16)
            })  Items["RealDivider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDivider"].Instance,
                Color = FromRGB(42, 42, 48),
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
                Size = UDim2New(1, 0, 0, 20),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                AnchorPoint = Vector2New(0, 0.5),
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(0, 12, 0, 12),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

            
            Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                TextTransparency = 0.48,
                Text = Toggle.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                Position = UDim2New(0, 18, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 14,
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
            if Bool == nil then
                Bool = not Toggle.Value
            end

            Toggle.Value = Bool == true

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
                Default = Data.Default or Data.default,
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

        Library:TrackFeature(Toggle, Items["Toggle"].Instance)

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
                BorderColor3 = FromRGB(8, 8, 9),
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 17),
                Selectable = false,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
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
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"}) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 14,
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

        Library:TrackFeature(Button, Items["Button"].Instance)

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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 14,
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
                BorderColor3 = FromRGB(8, 8, 9),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
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
                BackgroundColor3 = FromRGB(168, 138, 232)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealSlider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50/100s",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
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
            Value = tonumber(Value)

            if Value == nil or Value ~= Value then
                Value = Slider.Min
            end

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

            local absPos = Items["RealSlider"].Instance.AbsolutePosition
            local absSize = Items["RealSlider"].Instance.AbsoluteSize

            if absSize.X <= 0 then
                return
            end

            local SizeX = math.clamp((UserInputService:GetMouseLocation().X - absPos.X) / absSize.X, 0, 1)
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(Value)
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and Slider.Sliding then
                local absPos = Items["RealSlider"].Instance.AbsolutePosition
                local absSize = Items["RealSlider"].Instance.AbsoluteSize

                if absSize.X <= 0 then
                    return
                end

                local SizeX = math.clamp((UserInputService:GetMouseLocation().X - absPos.X) / absSize.X, 0, 1)
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

        Library:TrackFeature(Slider, Items["Slider"].Instance)

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

        local WindowItems = Dropdown.Window and Dropdown.Window.Elements
        local MainFrame = WindowItems and WindowItems["MainFrame"]
        local DropdownLayer = WindowItems and WindowItems["DropdownLayer"]

        if MainFrame and not DropdownLayer then
            DropdownLayer = Instances:Create("Frame", {
                Parent = MainFrame.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                ClipsDescendants = false,
                Active = false,
                ZIndex = 10000
            })

            MainFrame.Instance.ClipsDescendants = false
            WindowItems["DropdownLayer"] = DropdownLayer
        end

        if not DropdownLayer then
            DropdownLayer = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                ClipsDescendants = false,
                Active = false,
                ZIndex = 10000
            })

            if WindowItems then
                WindowItems["DropdownLayer"] = DropdownLayer
            end
        end

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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 14,
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
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
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
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["Open"] = Instances:Create("TextButton", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "+",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0, -4, 0, -1),
                BorderSizePixel = 0,
                TextSize = 14,
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                Size = UDim2New(1, -25, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 5, 0, -1),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["OptionHolder"] = Instances:Create("ScrollingFrame", {
                Parent = DropdownLayer.Instance,
                Visible = false,
                BorderColor3 = FromRGB(8, 8, 9),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                Size = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 23),
                ClipsDescendants = true,
                Active = true,
                ScrollingEnabled = true,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Library.Theme.Accent,
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ZIndex = 10001
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border", ScrollBarImageColor3 = "Accent"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIListLayout", {
                Parent = Items["OptionHolder"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["OptionHolder"].Instance,
                PaddingBottom = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 4)
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

        local DropdownPositionConnection = nil
        local DropdownOpenToken = 0

        local function UpdateDropdownPosition()
            local Holder = Items["OptionHolder"].Instance
            local Row = Items["Dropdown"].Instance
            local Parent = Holder and Holder.Parent

            if not (Holder and Row and Parent) then
                return
            end

            if Dropdown.Window and Dropdown.Window.IsOpen == false then
                return
            end

            local Viewport = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Camera.ViewportSize
            local RowPosition = Row.AbsolutePosition
            local RowSize = Row.AbsoluteSize

            if RowSize.X <= 0 then
                return
            end

            local ParentPosition = Parent.AbsolutePosition
            local Count = 0

            for _ in pairs(Dropdown.Options) do
                Count += 1
            end

            local FullHeight = Holder.AbsoluteCanvasSize.Y

            if FullHeight <= 1 then
                FullHeight = Count * 15 + 4
            end

            FullHeight = math.max(15, FullHeight)

            local Gap = 5
            local BelowY = RowPosition.Y + RowSize.Y + Gap
            local AboveY = RowPosition.Y - Gap
            local SpaceBelow = math.max(0, Viewport.Y - BelowY - 8)
            local SpaceAbove = math.max(0, AboveY - 8)
            local ShownHeight, Y

            if FullHeight <= SpaceBelow then
                ShownHeight = FullHeight
                Y = BelowY
            elseif FullHeight <= SpaceAbove then
                ShownHeight = FullHeight
                Y = AboveY - FullHeight
            elseif SpaceBelow >= SpaceAbove then
                ShownHeight = math.max(30, SpaceBelow)
                Y = BelowY
            else
                ShownHeight = math.max(30, SpaceAbove)
                Y = AboveY - ShownHeight
            end

            local Width = math.max(80, RowSize.X)

            Holder.Position = UDim2New(0, RowPosition.X - ParentPosition.X, 0, Y - ParentPosition.Y)
            Holder.Size = UDim2New(0, Width, 0, ShownHeight)
        end

        function Dropdown:Set(Option)
            if Dropdown.Multi then
                local Wanted = { }
                local Labels = { }

                if type(Option) == "table" then
                    for _, Name in ipairs(Option) do
                        if type(Name) == "string" and Dropdown.Options[Name] and not Wanted[Name] then
                            Wanted[Name] = true
                            Labels[#Labels + 1] = Name
                        end
                    end
                elseif type(Option) == "string" and Dropdown.Options[Option] then
                    Wanted[Option] = true
                    Labels[1] = Option
                end

                for Name, OptionData in Dropdown.Options do
                    if Wanted[Name] then
                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    else
                        OptionData.Selected = false
                        OptionData:Toggle("Inactive")
                    end
                end

                Dropdown.Value = Labels
                Library.Flags[Dropdown.Flag] = Labels

                Items["Value"].Instance.Text = #Labels > 0 and TableConcat(Labels, ", ") or "--"
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
                Library:SafeCall(Dropdown.Callback, Dropdown.Multi and Dropdown.Value or Option)
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
                Size = UDim2New(1, 0, 0, 17),
                ZIndex = 10002,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 10003,
                TextSize = 14,
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

            Dropdown.Value = Dropdown.Multi and { } or nil
            Library.Flags[Dropdown.Flag] = Dropdown.Multi and { } or nil
            Items["Value"].Instance.Text = "--"

            for Index, Value in List do
                Dropdown:Add(Value)
            end
        end

        function Dropdown:Clear()
            local Names = { }

            for Name in Dropdown.Options do
                TableInsert(Names, Name)
            end

            for _, Name in Names do
                Dropdown:Remove(Name)
            end
        end

        
        
        function Dropdown:SetItems(List)
            Dropdown:Clear()

            for _, Value in List do
                Dropdown:Add(Value)
            end

            if Dropdown.Multi then
                if type(Dropdown.Value) == "table" then
                    for _, Name in Dropdown.Value do
                        local OptionData = Dropdown.Options[Name]

                        if OptionData then
                            OptionData.Selected = true
                            OptionData:Toggle("Active")
                        end
                    end
                end
            elseif Dropdown.Value then
                local OptionData = Dropdown.Options[Dropdown.Value]

                if OptionData then
                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end
            end
        end

        local Debounce = false

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            DropdownOpenToken += 1
            local Token = DropdownOpenToken

            Dropdown.IsOpen = Bool
            Library.OpenDropdowns[Dropdown] = Bool and true or nil
            Debounce = true 

            if DropdownPositionConnection then
                DropdownPositionConnection.Connection:Disconnect()
                DropdownPositionConnection = nil
            end

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.ZIndex = 10001
                Items["Open"].Instance.Text = "-"
                Items["Open"].Instance.Position = UDim2New(0, -5, 0, -1)
                UpdateDropdownPosition()

                DropdownPositionConnection = Library:Connect(RunService.RenderStepped, function()
                    if Dropdown.IsOpen then
                        UpdateDropdownPosition()
                    end
                end)
            else
                Items["Open"].Instance.Text = "+"
                Items["Open"].Instance.Position = UDim2New(0, -4, 0, -1)
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            local FadeSpeed = (Dropdown.Window and Dropdown.Window.FadeSpeed) or 0.25

            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, FadeSpeed)
                end
            end

            local function Finish()
                if Token ~= DropdownOpenToken then
                    return
                end

                Debounce = false
                Items["OptionHolder"].Instance.Visible = Bool
                Items["OptionHolder"].Instance.ZIndex = 10001
            end

            if NewTween and NewTween.Tween then
                NewTween.Tween.Completed:Once(Finish)
            else
                Finish()
            end
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

        Library:TrackFeature(Dropdown, Items["Dropdown"].Instance)

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
            Height = Data.Height or Data.height or 17,
            Wrapped = Data.Wrapped == true or Data.wrapped == true,

            Count = 0
        }

        local Items = { } do
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, Label.Height),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })

            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                TextYAlignment = Label.Wrapped and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
                TextWrapped = Label.Wrapped,
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 14,
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
                Default = Data.Default or Data.default,
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)

            return Keybind, Extension
        end

        Library:TrackFeature(Label, Items["Label"].Instance)

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
            Changed = Data.Changed or Data.changed,

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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 14,
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
                BorderColor3 = FromRGB(8, 8, 9),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
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
                Color = FromRGB(42, 42, 48)
            }):AddToTheme({Color = "Outline"})
            
            Items["Inline"] = Instances:Create("TextBox", {
                Parent = Items["Background"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
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
                TextSize = 14,
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

        if Textbox.Changed then
            Items["Inline"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                local Value = Items["Inline"].Instance.Text

                Textbox.Value = Value
                Library.Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Changed, Value)
            end)
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

        Library:TrackFeature(Textbox, Items["Textbox"].Instance)

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
                ScrollBarImageColor3 = FromRGB(168, 138, 232),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 1,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, 0, 1, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(14, 14, 16),
                BorderColor3 = FromRGB(8, 8, 9),
                BorderSizePixel = 2,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["RealListbox"]:AddToTheme({ScrollBarImageColor3 = "Accent", BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealListbox"].Instance,
                Color = FromRGB(42, 42, 48),
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
                Size = UDim2New(1, 0, 0, 17),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(224, 224, 228),
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
                TextSize = 14,
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

                if getgenv().__hoodMenuFxSyncBlur then
                    pcall(getgenv().__hoodMenuFxSyncBlur)
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
            local Name = Library:SafeConfigName(ThemeName)

            if Name then
                local OkWrite = pcall(function()
                    writefile(Library.Folders.Themes .. "/" .. Name .. ".json", Library:GetTheme())
                end)

                Library:RefreshThemesList(ThemesSearchbox)

                if OkWrite and isfile(Library.Folders.Themes .. "/" .. Name .. ".json") then
                    Library:Notification("Success", "Saved theme " .. Name, 4, Color3.fromRGB(0, 255, 0))
                else
                    Library:Notification("Error", "Failed saving theme " .. Name, 4, Color3.fromRGB(255, 90, 90))
                end
            end
        end)

        ThemeButtons:Add("Load", function()
            if ThemeSelected then
                local Path = Library.Folders.Themes .. "/" .. ThemeSelected

                if not isfile(Path) and isfile(Path .. ".json") then
                    Path = Path .. ".json"
                end

                if isfile(Path) then
                    local Success, Result = Library:LoadTheme(readfile(Path))
                    if not Success then
                        Library:Notification("Error", tostring(Result), 4, Color3.fromRGB(255, 90, 90))
                    end
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
            local Name = Library:SafeConfigName(ConfigName)

            if Name then
                if not isfile(Library.Folders.Configs .. "/" .. Name .. ".json") then
                    writefile(Library.Folders.Configs .. "/" .. Name .. ".json", Library:GetConfig())
                    Library:RefreshConfigsList(ConfigsSearchbox)
                    Library:Notification("Success", "Created config " .. Name, 4, Color3.fromRGB(0, 255, 0))
                else
                    Library:Notification("Error", "Config with that name already exists", 4, Color3.fromRGB(255, 90, 90))
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
                    if not Success then
                        Library:Notification("Error", tostring(Result), 4, Color3.fromRGB(255, 90, 90))
                    end
                end
            end
        end)

        ConfigButtons:Add("Save", function()
            if ConfigSelected then
                Library:SaveConfig(ConfigSelected)
                Library:RefreshConfigsList(ConfigsSearchbox)
            end
        end)

        local ConfigString = ConfigsSection:Textbox({
            Name = "Config string",
            Flag = "ConfigString",
            Default = "",
            Placeholder = "paste raw config json",
        })

        ConfigButtons:Add("Save string", function()
            local Raw = ConfigString:Get()
            local Name = Library:SafeConfigName(ConfigName)

            if not Name then
                Library:Notification("Error", "Enter a config name first", 4, Color3.fromRGB(255, 90, 90))
                return
            end

            if type(Raw) ~= "string" or Raw == "" then
                Library:Notification("Error", "Paste a config string first", 4, Color3.fromRGB(255, 90, 90))
                return
            end

            local OkDecode, Decoded = pcall(function()
                return HttpService:JSONDecode(Raw)
            end)

            if not OkDecode or type(Decoded) ~= "table" then
                Library:Notification("Error", "That string is not valid config JSON", 4, Color3.fromRGB(255, 90, 90))
                return
            end

            local Path = Library.Folders.Configs .. "/" .. Name .. ".json"
            local OkWrite = pcall(function()
                writefile(Path, Raw)
            end)

            if OkWrite and isfile(Path) then
                Library:RefreshConfigsList(ConfigsSearchbox)
                Library:Notification("Success", "Saved config " .. Name, 4, Color3.fromRGB(0, 255, 0))
            else
                Library:Notification("Error", "Failed saving config " .. Name, 4, Color3.fromRGB(255, 90, 90))
            end
        end)

        ConfigButtons:Add("Copy", function()
            if type(setclipboard) ~= "function" then
                Library:Notification("Error", "Clipboard not supported on this executor", 4, Color3.fromRGB(255, 90, 90))
                return
            end

            pcall(setclipboard, Library:GetConfig())
            Library:Notification("Success", "Config copied as JSON", 4, Color3.fromRGB(0, 255, 0))
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
            Default = false,
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

        local CreditsSection = SettingsSubPage:Section({ Name = "Credits", Side = 2 })

        CreditsSection:Label({
            Name = "thank you to: vincent (neuro) for ui inspo, et (precumlol) for open/close effects and menu effects and all testers for making fmeta what it is.",
            Wrapped = true,
            Height = 74,
        })

        local FontItems = { "GothamMedium" }
        local SeenFonts = { ["GothamMedium"] = true }

        local EnumOK, EnumFonts = pcall(function()
            return Enum.Font:GetEnumItems()
        end)

        if EnumOK and EnumFonts then
            for _, FontEnum in ipairs(EnumFonts) do
                local FontName = FontEnum.Name

                if FontName and not SeenFonts[FontName] then
                    local ValidFont = pcall(function()
                        return Font.fromEnum(FontEnum)
                    end)

                    if ValidFont then
                        SeenFonts[FontName] = true
                        TableInsert(FontItems, FontName)
                    end
                end
            end
        end

        for FontName in Library.FontList do
            if not SeenFonts[FontName] then
                SeenFonts[FontName] = true
                TableInsert(FontItems, FontName)
            end
        end

        table.sort(FontItems)

        MenuSection:Label("Font")

        MenuSection:Listbox({
            Name = "Font",
            Flag = "Font",
            Items = FontItems,
            Size = 120,
            Default = Library.FontName,
            Callback = function(Value)
                if not Library:SetFont(Value) then
                    Library:Notification("Font", "Failed to load " .. tostring(Value), 4)
                end
            end,
        })

        MenuSection:Label("Menu keybind"):Keybind({
            Name = "Menu keybind",
            Flag = "MenuKeybind",
            Default = Library.MenuKeybind,
            Mode = "Toggle",
            Callback = function()
                Library.MenuKeybind = Library.Flags["MenuKeybind"].Key or Enum.KeyCode.RightControl
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
            BorderColor3 = FromRGB(8, 8, 9),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(20, 20, 23)
        })  Items["Playerlist"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

        Instances:Create("UIStroke", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = FromRGB(42, 42, 48),
            Thickness = 1
        }):AddToTheme({Color = "Outline"})

        Items["RealPlayerlist"] = Instances:Create("Frame", {
            Parent = Items["Playerlist"].Instance,
            Name = "\0",
            Position = UDim2New(0, 8, 0, 8),
            Size = UDim2New(1, -16, 1, -86),
            BorderColor3 = FromRGB(8, 8, 9),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(14, 14, 16)
        })  Items["RealPlayerlist"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

        Instances:Create("UIStroke", {
            Parent = Items["RealPlayerlist"].Instance,
            Name = "\0",
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Color = FromRGB(42, 42, 48),
            Thickness = 1
        }):AddToTheme({Color = "Outline"})

        Items["PlayerHolder"] = Instances:Create("ScrollingFrame", {
            Parent = Items["RealPlayerlist"].Instance,
            Name = "\0",
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BorderSizePixel = 0,
            CanvasSize = UDim2New(0, 0, 0, 0),
            ScrollBarImageColor3 = FromRGB(168, 138, 232),
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
            TextColor3 = FromRGB(224, 224, 228),
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
            TextColor3 = FromRGB(152, 152, 160),
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
                BackgroundColor3 = FromRGB(20, 20, 23),
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
                TextColor3 = FromRGB(224, 224, 228),
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
                TextColor3 = FromRGB(152, 152, 160),
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
                TextColor3 = FromRGB(224, 224, 228),
                BorderColor3 = FromRGB(8, 8, 9),
                Text = "Neutral",
                TextSize = 9,
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Position = UDim2New(1, -2, 0.5, 0),
                Size = UDim2New(0, 68, 0, 20),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(36, 36, 41)
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

            task.delay(0.4 + Order * 0.05, function()
                if not PlayerData.Avatar.Instance or not PlayerData.Avatar.Instance.Parent then
                    return
                end

                local Success, Thumbnail = pcall(function()
                    return Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
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

            
            
            
            
            Model.Parent = Workspace.CurrentCamera or Camera
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()

            
            
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

            
            
            local function MatchHandle(Handle, Element, PadX, PadY, MinW)
                local Rel = Element.AbsolutePosition - Overlay.AbsolutePosition
                local Size = Element.AbsoluteSize
                Handle.Position = UDim2New(0, Rel.X - PadX, 0, Rel.Y - PadY)
                Handle.Size = UDim2New(0, math.max(Size.X, MinW or 0) + PadX * 2, 0, Size.Y + PadY * 2)
            end

            MatchHandle(Items["GrabName"].Instance, Items["ESPName"].Instance, 2, 1, 0)
            MatchHandle(Items["GrabTool"].Instance, Items["ESPTool"].Instance, 2, 1, 0)
            MatchHandle(Items["GrabHealth"].Instance, Items["HealthFill"].Instance, 5, 2, 8)

            
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
                
                
                task.wait(0.75)

                while Items["Panel"].Instance and Items["Panel"].Instance.Parent and not ESPPreview.IsOpen do
                    task.wait(0.25)
                end

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
            if not ESPPreview.Model or not ESPPreview.IsOpen or not Items["Panel"].Instance.Visible then
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

        
        local guiParent = (type(gethui) == "function" and (pcall(gethui) and gethui()))
            or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui"))
            or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        Items["Screen"] = Instances:Create("ScreenGui", {
            Parent = guiParent, Name = "SpotifyOverlay", ResetOnSpawn = false,
            IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Global, DisplayOrder = 999,
        })

        
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
            })  SkyLabels[i]:AddToTheme({ TextColor3 = "Text", TextStrokeColor3 = "Text Border" })
        end

        
        
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

    
    local Hood3DPresenter = (function()

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
		return true 
	end
	if child.AnchorPoint.Y >= 1 then
		return true 
	end
	if child.AnchorPoint.X <= 0 and child.AnchorPoint.Y == 0.5 then
		return true 
	end
	return false
end

function Hood3D.Mount(target, options)
	options = options or {}

	local gui = resolveScreenGui(target)
	assert(gui, "Hood3D.Mount: expected a ScreenGui (or a Scoot Library / holder object)")

	
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

	
	for _, child in ipairs(gui:GetChildren()) do
		if not staysOnScreen(child) then
			child.Parent = surface
		end
	end

	
	
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

	
	local function follow()
		local pos, rot = computeTarget()
		state.BasePosition = pos
		state.Orientation = rot
		return pos, rot
	end

	local function targetPosition()
		return state.BasePosition + state.DragOffset
	end

	
	
	
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
		return canvasY < (windowTop + 40) 
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
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not drag.active then
				return
			end
			local delta = UserInputService:GetMouseLocation() - drag.startMouse
			local vp = camera.ViewportSize
			local focal = (vp.Y * 0.5) / math.tan(math.rad(camera.FieldOfView) * 0.5)
			local dist = (panel.Position - camera.CFrame.Position).Magnitude
			local worldScale = (dist / math.max(focal, 1)) * dragScale
			
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

	
	
	
	local function isOpen()
		if windowFrame then
			return windowFrame.Visible
		end
		return gui.Enabled
	end

	
	
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

		
		if not state.Open then
			follow()
		end

		local target = targetPosition()
		
		local rate = drag.active and math.max(smoothing, 60) or smoothing
		local alpha = 1 - math.exp(-dt * rate)
		local nextPos = panel.Position:Lerp(target, alpha)
		if (nextPos - target).Magnitude < 0.002 then
			nextPos = target
		end
		local targetCFrame = CFrame.new(nextPos) * state.Orientation
		
		if not lastCFrame or not lastCFrame:FuzzyEq(targetCFrame, 0.0005) then
			lastCFrame = targetCFrame
			panel.CFrame = targetCFrame
		end

		
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

    
    Library.LogoBase64 = "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"

getgenv().Library = Library
return Library
