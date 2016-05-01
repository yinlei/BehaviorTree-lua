-- Filename: MemorySequence.lua 
-- Author: xupang
-- Date: 2016-04-28
-- Purpose: 带记忆的序列节点
-- Detail:从头到尾按顺序执行每个子节点，遇到false为止

local MemorySequence = class("MemorySequence",BevNode)

function MemorySequence:ctor(...)
	MemorySequence.super.ctor(self,...)
	self.m_nLastIndex = 1
end

function MemorySequence:execute(dt )
	local result = E_BevState_Fail
	for i=self.m_nLastIndex,#self.m_vecChildren do
		local p = self.m_vecChildren[i]
		local s = p:execute(dt)
		if s ~= E_BevState_Success then
			if s == E_BevState_Running then
				self.m_nLastIndex = i
				result = s
				return result
			end
		end
	end
	self.m_nLastIndex = 1
	return result
end
return MemorySequence