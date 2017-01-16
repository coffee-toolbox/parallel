{Parallel} = require('./Parallel.coffee')

works = [0..10].map (i)->
	(s)->
		new Promise (res)->
			setTimeout ->
				res console.log s, i
			, 50

console.log 'run sequential'
sequential = new Parallel()

works.forEach (w)->
	sequential.add ->
		w 'seq'

sequential.allDone().then ->
	console.log 'sequential done'

console.log 'run parallel'
p2 = new Parallel(2)

works.forEach (w)->
	p2.add ->
		w 'parallel'

setTimeout ->
	works.forEach (w)->
		p2.add ->
			w 'parallel later'

	p2.allDone().then ->
		console.log 'parallel done'
, 2000
