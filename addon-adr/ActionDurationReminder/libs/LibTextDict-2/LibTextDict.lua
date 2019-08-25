local lib = LibStub:NewLibrary("LibTextDict-2", 2) --#Lib
if not lib then
  return  -- already loaded and no upgrade necessary
end


local dictProto = {} -- #Dict
do
  dictProto.getText  -- #(#Dict:self,#string:key,#any:...)->(#string)
  = function(self, key, ...)
    local text = self.map[key] or key
    if select("#", ...) > 0 then return zo_strformat(text, ...) end
    return text
  end

  dictProto.setText -- #(#Dict:self,#string:key,#string:translation)->()
  = function (self, key, translation)
    self.map[key] = translation
  end
end

do
  lib.dictMap = {} -- #map<#string, #Dict>
  lib.newDict -- #()->(#Dict)
  = function()
    local dict = {} --#Dict
    dict.map = {} -- #map<#string,#string>
    dict.text = function(key,...) return dict:getText(key,...) end -- #(#string:key,#any:...)->(#string)
    dict.put = function(key,translation) dict:setText(key,translation) end -- #(#string:key, #string:translation)->()
    setmetatable(dict,{__index=dictProto})
    return dict
  end
  lib.getAddonDict  -- #(#Lib:self, #string:addon)->(#Dict)
  = function(self, addon)
    if(not self.dictMap[addon]) then
      self.dictMap[addon] = self.newDict()
    end
    return self.dictMap[addon]
  end
end

setmetatable(lib, { __call = lib.getAddonDict })
