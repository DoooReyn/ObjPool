--
-- Author: Reyn
-- Date: 2017-09-16 14:46:22
--

local _M = class("ObjPool")

function _M:ctor(objName, objCreator)
    self.objName    = objName	--池子名称
    self.objs       = {} 		--对象
    self.objCreator = objCreator--对象生产方法
    self.curIdx     = 1			--对象池子索引值
    self.defaultNum = 0			--对象初始数量
end

--[[清理对象池]]
function _M:cleanup()
    for _, obj in pairs(self.objs) do
        obj:release()
    end
    self.curIdx = 1
    self.objs = {}
end

--[[清理对象数量到初始数量,并重置使用索引]]
function _M:cleanupToDefault()
    if self.defaultNum > #self.objs then return end

    local objs = {}
    for i = 1, self.defaultNum do
        local obj = self.objs[i]
        obj:retain()
        objs[i] = obj
    end
    for _, obj in pairs(self.objs) do
        obj:release()
    end
    self.objs = objs
    self.curIdx = 1
end

--[[预加载数据]]
function _M:preload(num)
    self.defalutNum = num
    for i = 1, num do
        local obj = self.objCreator()
        obj:retain()
        self.objs[i] = obj
    end
end

--[[取出对象]]
function _M:getObj()
    local obj = self.objs[self.curIdx]
    self.curIdx = self.curIdx + 1
    if obj then return obj end

    obj = self.objCreator()
    obj:retain()
    table.insert(self.objs,obj)

    return obj
end

--[[重置索引]]
function _M:reset()
	self.curIdx = 1
end

--[[池子容量]]
function _M:size()
    return #self.objs
end

return _M
