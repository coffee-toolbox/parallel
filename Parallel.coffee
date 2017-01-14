'use strict'
{Logger} = require('@coffee-toolbox/logger')
{EventEmitter} = require('@coffee-toolbox/eventemitter')

SEQUENTIAL = 1

class Parallel extends EventEmitter
	constructor: (@parallel)->
		super
		@logger = new Logger @constructor.name
		@done = false
		@running = 0
		@queue = []
		@parallel ?= SEQUENTIAL

	add: (f)->
		@logger.assert f instanceof Function
		@queue.push @_run_next f

		if @running < @parallel
			@queue.shift()()

	allDone: (f)->
		@done = true
		@once 'ALLDONE', f

	_run_next: (f)->
		=>
			@running += 1
			p = Promise.resolve f()
			p.then =>
				@running -= 1
				if @queue.length > 0
					@queue.shift()()
				else if @done and @running is 0
					@emit 'ALLDONE'

module.exports =
	Parallel: Parallel
