-- Filename: BevNode.lua 
-- Author: xupang
-- Date: 2016-03-28
-- Purpose: 行为树基类

BevNode = class("BevNode")

function BevNode:ctor(...)
	self.m_pParent = nil --父节点
	self.m_vecChildren ={} --子节点
	-- 倘若想测试，可以打印...的数据
end
function BevNode:addChild(_pNode)
	table.insert(self.m_vecChildren,_pNode)
end
function BevNode:setParent(pParent )
	self.m_pParent = pParent
end
function BevNode:execute(dt )
	return E_BevState_Fail
end
function BevNode:clear( )
	for k,v in pairs(self.m_vecChildren) do
		-- TODO:clear
	end
end
 