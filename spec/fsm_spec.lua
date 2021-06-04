
require("busted")

local machine = require("statemachine")
local _ = require("luassert.match")._

describe("Lua state machine framework", function()
  describe("A stop light", function()