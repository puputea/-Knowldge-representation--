
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