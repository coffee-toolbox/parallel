'use strict'
{Logger} = require('@coffee-toolbox/logger')
{EventEmitter} = require('@coffee-toolbox/eventemitter')

SEQUENTIAL = 1

class Parallel extends EventEmitter
	constructor: (@concurrency)->
		super
		@logger = new Logger @constructor.name
		@semaphore = 1
		@queue = []
		@concurrency ?= SEQUENTIAL
		@logger.assert @concurrency > 0, '@concurrency is not larger than 0'

	add: (f)->
		@logger.assert f instanceof Function
		@logger.assert @semaphore isnt 0, 'adding to an "all-done" Parallel"'

		@semaphore += 1
		@queue.push @_run_next f

		if @semaphore - 1 <= @concurrency
			@queue.shift()()

		this

	allDone: ->
		@semaphore -= 1
		if @semaphore is 0
			Promise.resolve()
		else
			new Promise (res)=>
				@once 'ALLDONE', ->
					res()

	_run_next: (f)->
		=>
			Promise.resolve(f())
			.then =>
				@semaphore -= 1
				if @queue.length > 0
					@queue.shift()()
				else if @semaphore is 0
					@emit 'ALLDONE'

module.exports =
	Parallel: Parallel
