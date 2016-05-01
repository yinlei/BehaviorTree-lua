-- Filename: MemorySelector.lua 
-- Author: xupang
-- Date: 2016-04-28
-- Purpose: 带记忆的选择节点
-- Detail:从上一次执行的子节点开始，按顺序执行每个子节点，遇到false为止

local MemorySelector = class("MemorySelector",BevNode)

function MemorySelector:ctor(...)
	MemorySelector.super.ctor(self,...)
	self.m_nLastIndex = 1
end

function MemorySelector:execute(dt )
	local result = E_BevState_Fail
	for i=self.m_nLastIndex,#self.m_vecChildren do
		local p = self.m_vecChildren[i]
		local s = p:execute(dt)
		if s ~= E_BevState_Fail then
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
return MemorySelector