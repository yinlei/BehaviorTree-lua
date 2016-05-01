-- Filename: LeafNode.lua 
-- Author: xupang
-- Date: 2016-03-28
-- Purpose: 叶子节点
-- Detail:

local LeafNode = class("LeafNode",BevNode)

function LeafNode:ctor(...)
	LeafNode.super.ctor(self,...)
	self.m_nInterrupt 	= E_IS_NONE
	self.m_nLeafStatus 	= E_LS_ENTER
	-- 以下方法会把该节点的self传出去
	self.m_enterFunc 	= nil --刚进入时的初始化操作，外部可能需要跟该节点交互.
	self.m_exitFunc 	= nil --退出时执行的逻辑
	self.m_executeFunc 	= nil --运行逻辑
end

function LeafNode:execute(dt )
	local result = E_BevState_Success
	-- 进入时
	if self.m_nLeafStatus == E_LS_ENTER then
		if self.m_enterFunc then
			self.m_enterFunc(self)
		end
		self.m_nLeafStatus = E_LS_RUNNING
	end
	-- 执行该节点
	if self.m_nLeafStatus == E_LS_RUNNING then
		if self.m_nInterrupt == E_IS_NONE then
			if self.m_executeFunc then
				result = self.m_executeFunc(self,dt)
				if result ~= E_BevState_Running then
					self.m_nLeafStatus = E_LS_EXIT
				end
			else
				result = E_BevState_Running
			end
		else
			-- 被打断
			if self.m_nInterrupt == E_IS_FAIL then
				result = E_BevState_Fail
			elseif self.m_nInterrupt == E_IS_SUCCESS then
				result = E_BevState_Running
			end
			self.m_nLeafStatus = E_LS_EXIT
		end
	end
	-- 退出该节点
	if self.m_nLeafStatus == E_LS_EXIT then
		if self.m_exitFunc then
			self.m_exitFunc(self)
		end
		self.m_nLeafStatus = E_LS_ENTER
		self.m_nInterrupt = E_IS_NONE
	end
	return result
end
function LeafNode:setEnterFunc(func )
	self.m_enterFunc = func
end
function LeafNode:setExecuteFunc(func )
	self.m_executeFunc = func
end
function LeafNode:setExitFunc(func )
	self.m_exitFunc = func
end
function LeafNode:interruptState(state )
	self.m_nInterrupt = state
end
return LeafNode

