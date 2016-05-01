-- Filename: BevHelper.lua 
-- Author: xupang
-- Date: 2016-04-29
-- Purpose: 行为树帮助类

-- 行为树状态
E_BevState_Success 	= 0 --成功
E_BevState_Fail		= 1 --失败
E_BevState_Running 	= 2 --该节点正在运行

-- 外部强制中断
E_IS_NONE		= 0
E_IS_FAIL		= 1
E_IS_SUCCESS	= 2

-- leafState
E_LS_ENTER 		= 0
E_LS_RUNNING 	= 1
E_LS_EXIT 		= 2

require("src.bt.BevNode")
require("src.bt.Agent")

BevHelper={}


-- 获取巡逻点
function BevHelper.getMovePos()
	local _map = HomeHelper.getMap()
    local _tTbl = HomeHelper.tile
    local _pos =cc.p(0,0)
    local _isEmpty = true
    while(_isEmpty) do
        local _x = math.random(0,_tTbl.widthN-1)
        local _y = math.random(0,_tTbl.heightN -1)
        local _tile = {x=_x,y=_y}
        if _map[_tile.x][_tile.y] == HomeHelper.sType.none  then
            _pos.x= _tile.x
            _pos.y = _tile.y
            _isEmpty = false
        end
    end
    return _pos
end
