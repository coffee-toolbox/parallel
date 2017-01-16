# parallel

Run promise in parallel.

Add may works that should run in parallel and setup a number for concurrency.
Parallel will maintain a `concurrency` number of works running in parallel.

### NOTE
Do NOT download from npm!

Just add the dependency that use https git repo url as a version.

    "@coffee-toolbox/parallel": "https://github.com/coffee-toolbox/parallel.git"

npm is evil that it limit the publish of more than one project.
And its restriction on version number is terrible for fast development that
require local reference. (npm link sucks!)
[why npm link sucks](https://github.com/webpack/webpack/issues/554)

It ruined my productivity for a whole three days!

For any one who values his life, please be away from npm.

----

## API

### Require:

```coffeescript
{Parallel} = require '@coffee-toolbox/parallel'
```

### Create new Parallel

```coffeescript
# run works one after another
queue = new Parallel()

# run works concurrently, 2 at a time
pq = new Parallel 2
```

You have promises that should run one after another, just leave the
`concurrency` empty.

Otherwise, at most `concurrency` number of promises will be running in
parallel. When any of them is done, the next added will be started.

The `concurrency` must be larger than 0.

### Adding work

```coffeescript
# work must be a function returning Promise
w = ->
    Promise (res)->
        # do something ...
        res()

pq.add w
```
User should catch and handle the Rejected Promise in the work or use other way
to handle it.
The work **must Resolve** or queued work would abort.

### Wait for all done

```coffeescript
pq.allDone().then ->
    console.log 'all is done'
```

`allDone` returns a promise that resolves when all added works done.
When aborted, `allDone` will not fire.

## Example
```coffeescript
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

# run sequential
# run parallel
# seq 0
# parallel 0
# parallel 1
# seq 1
# parallel 2
# parallel 3
# seq 2
# parallel 4
# parallel 5
# seq 3
# parallel 6
# parallel 7
# seq 4
# parallel 8
# parallel 9
# seq 5
# parallel 10
# seq 6
# seq 7
# seq 8
# seq 9
# seq 10
# sequential done
# parallel later 0
# parallel later 1
# parallel later 2
# parallel later 3
# parallel later 4
# parallel later 5
# parallel later 6
# parallel later 7
# parallel later 8
# parallel later 9
# parallel later 10
# parallel done

