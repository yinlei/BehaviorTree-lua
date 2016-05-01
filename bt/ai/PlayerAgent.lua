-- Filename: PlayerAgent.lua 
-- Author: xupang
-- Date: 2016-03-28
-- Purpose: 主角
-- Detail:
local MemorySequence = require("bt.control.MemorySequence")
local SelectorNode = require("bt.control.SelectorNode")
local SequenceNode = require("bt.control.SequenceNode")
local LeafNode = require("bt.leaf.LeafNode")

local PlayerAgent = class("PlayerAgent",Agent)

function PlayerAgent:ctor(_player)
	self.m_pRoot = nil
	self.player = _player
	self:createBevTree()

    local function updateLocal(dt )
        self:updateLogic(dt)
    end
   	self.player:scheduleUpdateWithPriorityLua(updateLocal,0)
end
function PlayerAgent:updateLogic(dt )
	if self.m_pRoot then
		self.m_pRoot:execute(dt)
	end
end
-- 构建整棵行为树，后续若有做行为树编辑器可在这个类里面加载文件，解析创建行为树
function PlayerAgent:createBevTree( )
	-- 攻击节点的条件节点
	local pWithIn = LeafNode.new()
	pWithIn:setExecuteFunc(function(node,dt)
		return self.player:RangeOfAttack(node,dt)
	end)
	-- 攻击idle
	local pAckIdle = LeafNode.new()
	pAckIdle:setEnterFunc(function(node)
		self.player:idle(node)
	end)
	-- 攻击动作
	local pAckAttack = LeafNode.new()
	pAckAttack:setEnterFunc(function(node)
		self.player:attack(node)
	end)
	local pAck = MemorySequence.new()
	pAck:addChild(pAckAttack)
	pAck:addChild(pAckIdle)
	-- 这边要注意添加的顺序
	-- # 攻击节点
	local pAckNode = SequenceNode.new()
	pAckNode:addChild(pWithIn)
	pAckNode:addChild(pAck)

	-- 巡逻idle
	local pPaIdle = LeafNode.new()
	pPaIdle:setEnterFunc(function(node)
		print("巡逻的站立")
		self.player:idle(node)
		pPaIdle.time = 5
	end)
	pPaIdle:setExecuteFunc(function(node,dt)
		if node.time then
			node.time = node.time - dt
			if node.time <0 then
				return E_BevState_Success
			else
				return E_BevState_Running
			end
		end
	end)
	-- 巡逻move
	local pPaMove = LeafNode.new()
	pPaMove:setEnterFunc(function(node)
		self.player:move(node)
	end)

	-- # 巡逻节点
	local pPatrol = MemorySequence.new()
	pPatrol:addChild(pPaIdle)
	pPatrol:addChild(pPaMove)

	-- 根节点
	self.m_pRoot = SelectorNode.new()
	-- //这边要注意添加的顺序
	self.m_pRoot:addChild(pAckNode);
	self.m_pRoot:addChild(pPatrol);
end
return PlayerAgent