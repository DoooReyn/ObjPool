--
-- Author: Your Name
-- Date: 2017-09-16 15:01:28
--
local ObjPool = require('src.app.uihelper.objpool.ObjPool')
local _M = class('ObjPoolMgr')

function _M:ctor()
	self.pools = {}

    local player = ObjPool.new('player',function()
        local head = require('player').new()
        return head
    end)

    self.pools['player'] = {pool = player, num = 10}
end

function _M:preload()
    for _,v in ipairs(self.pools) do
		v.pool:preload(v.num)
    end
end

function _M:getObj(objname)
	if not self.pools[objname] then return nil end
	return self.pools[objname]:getObj()
end

function _M:cleanupToDefault(objname)
	if not self.pools[objname] then return nil end
	return self.pools[objname]:cleanupToDefault()
end

function _M:reset(objname)
	if not self.pools[objname] then return nil end
	return self.pools[objname]:reset()
end

return _M
