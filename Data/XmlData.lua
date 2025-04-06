---@class Decomp.Data.XmlData
local XmlData = {}
Decomp.Data.XmlData = XmlData

local s_XmlData = {}

---@return table?
function XmlData.GetXmlData(filePath)
    return s_XmlData[filePath]
end