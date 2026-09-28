---@class Interface.Console
local Interface = require("Isaac.Interface.Console")

--#region Stub

local Stub = {}

---@param console Component.Console
---@return Component.Console
function Stub.Constructor(console) end

---@param console Component.Console
function Stub.Destructor(console) end

---@param console Component.Console
function Stub.Init_qqq(console) end

---@param console Component.Console
function Stub.Clear_qqq(console) end

---@param console Component.Console
function Stub.LoadCommandHistory_qqq(console) end

---@param console Component.Console
---@param param_1 string
function Stub.AddHistoryEntry(console, param_1) end

---@param console Component.Console
---@param param_1 integer
function Stub.PrintNetStartError(console, param_1) end

---@param console Component.Console
---@return Font
function Stub.get_font() end

---@param console Component.Console
---@return Vector
function Stub.get_top_offset(console) end

---@param console Component.Console
---@return Component.XY
function Stub.get_bottom_offset_qqq(console, param_1) end

---@param console Component.Console
function Stub.SaveCommandHistory_qqq(console) end

---@param console Component.Console
---@param param_1 integer
---@return boolean
function Stub.check_key_autorepeat(console, param_1) end

---@param console Component.Console
---@param unk boolean
function Stub.submit_input(console, unk) end

---@param console Component.Console
function Stub.fill_omnicomplete(console) end

---@param console Component.Console
function Stub.ProcessInput(console) end

---@param console Component.Console
---@return boolean
function Stub.Update(console) end

---@param console Component.Console
---@param param_2 Font
---@param param_3 number
---@param param_4 number
---@param param_5 number
---@param param_6 number
---@param param_7 boolean
---@return integer
function Stub.render_history(console, param_2, param_3, param_4, param_5, param_6, param_7) end

---@param console Component.Console
function Stub.Render(console) end

---@param console Component.Console
---@param input string
---@param out string
---@param player Component.Entity.Player
function Stub.RunCommand(console, input, out, player) end

---@param console Component.Console
function Stub.compute_input_line_breaks(console) end

---@param console Component.Console
---@param param_1 /IsaacRepentance/Console/HistoryEntry
---@param param_2 boolean
function Stub.compute_line_breaks(console, param_1, param_2) end

---@param console Component.Console
function Stub.UpdateSize(console) end

---@param console Component.Console
---@param text string
---@param color integer
---@param fadeTime integer
function Stub.Print(console, text, color, fadeTime) end

---@param console Component.Console
---@param err string
function Stub.PrintError(console, err) end

---@param param_1 string
---@param this Component.Console
---@param string string
---@param param_4 unknown
function Stub.PrintF(param_1, this, string, param_4) end

---@param console Component.Console
---@param param_1 Component.Console
---@param param_2 integer
---@param param_3 string
function Stub.PrintF(console, param_1, param_2, param_3) end

--#endregion

Interface.Constructor = Stub.Constructor
Interface.Destructor = Stub.Destructor
Interface.Init_qqq = Stub.Init_qqq
Interface.Clear_qqq = Stub.Clear_qqq
Interface.LoadCommandHistory_qqq = Stub.LoadCommandHistory_qqq
Interface.AddHistoryEntry = Stub.AddHistoryEntry
Interface.PrintNetStartError = Stub.PrintNetStartError
Interface.get_font = Stub.get_font
Interface.get_top_offset = Stub.get_top_offset
Interface.get_bottom_offset_qqq = Stub.get_bottom_offset_qqq
Interface.SaveCommandHistory_qqq = Stub.SaveCommandHistory_qqq
Interface.check_key_autorepeat = Stub.check_key_autorepeat
Interface.submit_input = Stub.submit_input
Interface.fill_omnicomplete = Stub.fill_omnicomplete
Interface.ProcessInput = Stub.ProcessInput
Interface.Update = Stub.Update
Interface.render_history = Stub.render_history
Interface.Render = Stub.Render
Interface.RunCommand = Stub.RunCommand
Interface.compute_input_line_breaks = Stub.compute_input_line_breaks
Interface.compute_line_breaks = Stub.compute_line_breaks
Interface.UpdateSize = Stub.UpdateSize
Interface.Print = Stub.Print
Interface.PrintError = Stub.PrintError
Interface.PrintF = Stub.PrintF
Interface.PrintF = Stub.PrintF