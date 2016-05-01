-- Filename: SelectorNode.lua 
-- Author: xupang
-- Date: 2016-03-28
-- Purpose: 选择节点
-- Detail:从头到尾按顺序选择执行条件为真的节点

local SelectorNode = class("SelectorNode",BevNode)

function SelectorNode:ctor(...)
	SelectorNode.super.ctor(self,...)
end

function SelectorNode:execute(dt )
	local result = E_BevState_Fail
	for k,v in pairs(self.m_vecChildren) do
		local s = v:execute(dt)
		if s ~= E_BevState_Fail then
			result = s
			break
		end
	end
	return result
end
return SelectorNode