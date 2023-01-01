
local machine = {}
machine.__index = machine

local NONE = "none"
local ASYNC = "async"

local function call_handler(handler, params)
  if handler then
    return handler(unpack(params))
  end
end

local function create_transition(name)
  local can, to, from, params

  local function transition(self, ...)
    if self.asyncState == NONE then
      can, to = self:can(name)
      from = self.current
      params = { self, name, from, to, ...}

      if not can then return false end
      self.currentTransitioningEvent = name

      local beforeReturn = call_handler(self["onbefore" .. name], params)
      local leaveReturn = call_handler(self["onleave" .. from], params)

      if beforeReturn == false or leaveReturn == false then
        return false
      end

      self.asyncState = name .. "WaitingOnLeave"

      if leaveReturn ~= ASYNC then
        transition(self, ...)
      end
      
      return true
    elseif self.asyncState == name .. "WaitingOnLeave" then
      self.current = to

      local enterReturn = call_handler(self["onenter" .. to] or self["on" .. to], params)

      self.asyncState = name .. "WaitingOnEnter"

      if enterReturn ~= ASYNC then
        transition(self, ...)