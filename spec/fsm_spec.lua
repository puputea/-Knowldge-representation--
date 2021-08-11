
require("busted")

local machine = require("statemachine")
local _ = require("luassert.match")._

describe("Lua state machine framework", function()
  describe("A stop light", function()
    local fsm
    local stoplight = {
      { name = 'warn',  from = 'green',  to = 'yellow' },
      { name = 'panic', from = 'yellow', to = 'red'    },
      { name = 'calm',  from = 'red',    to = 'yellow' },
      { name = 'clear', from = 'yellow', to = 'green'  }
    }

    before_each(function()
      fsm = machine.create({ initial = 'green', events = stoplight })
    end)

    it("should start as green", function()
      assert.are_equal(fsm.current, 'green')
    end)

    it("should not let you get to the wrong state", function()
      assert.is_false(fsm:panic())
      assert.is_false(fsm:calm())
      assert.is_false(fsm:clear())
    end)

    it("should let you go to yellow", function()
      assert.is_true(fsm:warn())
      assert.are_equal(fsm.current, 'yellow')
    end)

    it("should tell you what it can do", function()
      assert.is_true(fsm:can('warn'))
      assert.is_false(fsm:can('panic'))
      assert.is_false(fsm:can('calm'))
      assert.is_false(fsm:can('clear'))
    end)

    it("should tell you what it can't do", function()
      assert.is_false(fsm:cannot('warn'))
      assert.is_true(fsm:cannot('panic'))
      assert.is_true(fsm:cannot('calm'))
      assert.is_true(fsm:cannot('clear'))
    end)

    it("should support checking states", function()
      assert.is_true(fsm:is('green'))
      assert.is_false(fsm:is('red'))
      assert.is_false(fsm:is('yellow'))
    end)

    it("should fire callbacks", function()
      local fsm = machine.create({
        initial = 'green',
        events = stoplight,
        callbacks = {
          onbeforewarn = stub.new(),
          onleavegreen = stub.new(),
          onenteryellow = stub.new(),
          onafterwarn = stub.new(),
          onstatechange = stub.new(),
          onyellow = stub.new(),
          onwarn = stub.new()
        }
      })

      fsm:warn()

      assert.spy(fsm.onbeforewarn).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onleavegreen).was_called_with(_, 'warn', 'green', 'yellow')

      assert.spy(fsm.onenteryellow).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onafterwarn).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onstatechange).was_called_with(_, 'warn', 'green', 'yellow')

      assert.spy(fsm.onyellow).was_not_called()
      assert.spy(fsm.onwarn).was_not_called()
    end)

    it("should fire handlers", function()
      fsm.onbeforewarn = stub.new()
      fsm.onleavegreen = stub.new()
      fsm.onenteryellow = stub.new()
      fsm.onafterwarn = stub.new()
      fsm.onstatechange = stub.new()

      fsm.onyellow = stub.new()
      fsm.onwarn = stub.new()

      fsm:warn()

      assert.spy(fsm.onbeforewarn).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onleavegreen).was_called_with(_, 'warn', 'green', 'yellow')

      assert.spy(fsm.onenteryellow).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onafterwarn).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onstatechange).was_called_with(_, 'warn', 'green', 'yellow')

      assert.spy(fsm.onyellow).was_not_called()
      assert.spy(fsm.onwarn).was_not_called()
    end)

    it("should accept additional arguments to handlers", function()
      fsm.onbeforewarn = stub.new()
      fsm.onleavegreen = stub.new()
      fsm.onenteryellow = stub.new()
      fsm.onafterwarn = stub.new()
      fsm.onstatechange = stub.new()

      fsm:warn('bar')

      assert.spy(fsm.onbeforewarn).was_called_with(_, 'warn', 'green', 'yellow', 'bar')
      assert.spy(fsm.onleavegreen).was_called_with(_, 'warn', 'green', 'yellow', 'bar')
      
      assert.spy(fsm.onenteryellow).was_called_with(_, 'warn', 'green', 'yellow', 'bar')
      assert.spy(fsm.onafterwarn).was_called_with(_, 'warn', 'green', 'yellow', 'bar')
      assert.spy(fsm.onstatechange).was_called_with(_, 'warn', 'green', 'yellow', 'bar')
    end)

    it("should fire short handlers as a fallback", function()
      fsm.onyellow = stub.new()
      fsm.onwarn = stub.new()

      fsm:warn()

      assert.spy(fsm.onyellow).was_called_with(_, 'warn', 'green', 'yellow')
      assert.spy(fsm.onwarn).was_called_with(_, 'warn', 'green', 'yellow')
    end)