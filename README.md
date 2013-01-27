# wormholes

shell utility that warps text elsewhere

## Installation

```
$ gem install wormholes
```
Make sure to include the "s". The singular form is something else entirely.

## Usage

Open one end of the wormhole with ```worm```. You can pipe any text into it you would like but a wormhole is generally best suited for some progressive, long-running output like a server log.

```
$ rails server | worm
```
At this point whatever is piped into the wormhole does not go anywhere. It disappears. You could say it goes into a black hole, I suppose.

If you want to start seeing any of that text again, open the other end with ```hole```.

```
$ hole
Started GET "/" for 127.0.0.1 at 2010-09-10 21:07:07 +1000
  Processing by UsersController#index as HTML
  SQL (0.5ms)  SELECT name
 FROM sqlite_master
 WHERE type = 'table' AND NOT name = 'sqlite_sequence'
  User Load (0.5ms)  SELECT "users".* FROM "users" LIMIT 15 OFFSET 0
  SQL (1.4ms)  SELECT COUNT(*) AS count_id FROM "users"
Rendered users/index.html.erb within layouts/application (24.8ms)
Completed 200 OK in 51ms (Views: 32.9ms | ActiveRecord: 2.3ms)
...
```

You can kill ```hole``` with Ctrl-C when you want to stop seeing the output. As long as ```worm``` is running the wormhole will be open and you can fire up ```hole``` again to see what is going into the ```worm``` end.

You can open as many ```hole```s as you would like, at the same time, and use them however you would use the original program producing the output.

```
$ hole | grep Rendered
Rendered users/index.html.erb within layouts/application (24.8ms)

```
Meanwhile in another shell…

```
$ hole | grep SQL
  SQL (0.5ms)  SELECT name
  SQL (1.4ms)  SELECT COUNT(*) AS count_id FROM "users"
```

### Named wormholes

So far you can only create one wormhole at a time, with one program piping its output into ```worm```. If you open another wormhole while the previous one is still open it will stop the other one. But you might want to open more than one at a time. To do this you can give a wormhole a name and refer to it when you open the other end.

```
$ yes | worm test
```
This creates a wormhole with the name 'test'. Open the other end with the same name.

```
$ hole test
y
y
y
...
```

This allows you to create as many wormholes as you want, at the same time, as long as they have unique names.

## Why use this?

Maybe you can think of ways to use this that I have not thought of. Getting log output wherever I want it, on demand, without restarting a server was the original use case.

So I use it for things like having multiple ```grep```s running on log output (as above). Or to tuck away a running server in another shell and just ```hole | grep something``` in the shell I'm working in to grab the few lines I'm looking for and Ctrl-C it away and get back to what I was doing.

All of these things can probably be done in other ways with the nice UNIX tools we know and love. If you have a file being appended to you can ```tail -f``` a bunch of times and get multiple outputs of your text. You can do stuff with ```tee```. You can use named pipes and sockets (wormholes uses UNIX sockets under the hood). You can think of wormholes as a formalization of some other ad hoc techniques.

## License

wormholes is MIT licensed
