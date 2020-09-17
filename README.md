
Lua Finite State Machine
========================

This standalone lua module provides a finite state machine for your pleasure.
Based **heavily** on Jake Gordon's
[javascript-state-machine](https://github.com/jakesgordon/javascript-state-machine).

Download
========

You can download [statemachine.lua](https://github.com/kyleconroy/lua-state-machine/raw/master/statemachine.lua).

Alternatively:

    git clone git@github.com:kyleconroy/lua-state-machine


Usage
=====

In its simplest form, create a standalone state machine using:

```lua
local machine = require('statemachine')

local fsm = machine.create({
  initial = 'green',
  events = {
    { name = 'warn',  from = 'green',  to = 'yellow' },
    { name = 'panic', from = 'yellow', to = 'red'    },
    { name = 'calm',  from = 'red',    to = 'yellow' },
    { name = 'clear', from = 'yellow', to = 'green'  }
}})
```

... will create an object with a method for each event:

 * fsm:warn()  - transition from 'green' to 'yellow'
 * fsm:panic() - transition from 'yellow' to 'red'
 * fsm:calm()  - transition from 'red' to 'yellow'
 * fsm:clear() - transition from 'yellow' to 'green'

along with the following members:

 * fsm.current   - contains the current state
 * fsm.currentTransitioningEvent - contains the current event that is in a transition.
 * fsm:is(s)     - return true if state `s` is the current state
 * fsm:can(e)    - return true if event `e` can be fired in the current state
 * fsm:cannot(e) - return true if event `e` cannot be fired in the current state