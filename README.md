# Chores

Sometimes you have a lot of stuff to do, and you want to get it done fast.
What's the obvious thing to do? Have a bunch of kids, and tell *them* to do it, of course!

## Intent

This gem allows a straightforward model of multiprocessing: spin off multiple external programs
to do work, and then wait for them to finish. That use-case is already possible in a basic
way using `spawn`, but that gives you no control or interactivity with the spawned process.

Because you may have more tasks than can reasonably run simultaneously (memory restrictions,
processor count, etc), you usually would like to specify an upper-limit on how many of those
tasks may be running simultaneously. If you have chores that are disproportionately long, you
usually want to minimize the net run-time - Chores allows you to specify a 'cost' for each chore,
which it will use to sort them into longest-job first (provably minimzing the net run-time).

The most important detail is that your chores will probably want to do some kind of logging,
so that your main process can tell what is going on in each of them. The natural way to do this
is to allow the external processes to log via stderr, and to do something with each line of log
so produced - each chore takes a callable for how to thread-safely handle that output.

You can pass input to the child process via the `:stdin` option, but it is not intended for
bulk interaction - that string is fed to the process immediately, and the pipe is then closed.

## Thread-Safety

Chores uses threads internally to allow jobs to finish in arbitrary order. None of the callbacks
you initialize chores with will be used outside of the main thread however, and all data structures
passed into the options hash will be dup'd, so you can safely reuse them for multiple chores.

## Usage

```ruby

# build a coordinator that allows 4 children at a time
boss = Chores::Boss.new(4)

['ls', 'ls -l', 'ls -a', 'echo hello'].each do |cmd|
  boss.add_chore({
    :command    => cmd,
    :on_success => lambda { STDERR.puts "#{cmd} succeeded" },
    :on_failure => lambda { STDERR.puts "#{cmd} failed"    },
    :on_stderr  => lambda { |ln| STDERR.puts "#{cmd} produced: #{ln}" }
  })
end

boss.run!
```
