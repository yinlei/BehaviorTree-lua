-- Filename: SequenceNode.lua 
-- Author: xupang
-- Date: 2016-04-28
-- Purpose: 序列节点
-- Detail:从头到尾按顺序执行每个子节点，遇到false为止

local SequenceNode = class("SequenceNode",BevNode)

function SequenceNode:ctor(...)
	SequenceNode.super.ctor(self,...)
end

function SequenceNode:execute(dt )
	local result = E_BevState_Success
	for k,v in pairs(self.m_vecChildren) do
		local s = v:execute(dt)
		if s ~= E_BevState_Success then
			result = s
			return result
		end
	end
	return result
end
return SequenceNode
