
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