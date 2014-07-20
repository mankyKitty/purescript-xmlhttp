PureScript XMLHttpRequest
=========================

Skeleton lib for interacting with an XMLHttpRequest Object from the unprincipled
land of JavaScript.

This lib I am hoping will remain very barebones, with some simple interface functions
that mean you can either wire up your own interaction for requests or just use a
simple `get` or `post` function style.

There are many like it, but this one is mine. I wanted to build something that 
would not require you to pull in more javascript dependencies. Also I wanted to
learn more about the Effects monad, Row types, and the PureScript FFI. :)

### TODO
* Utilise `Data.Foreign` and `Data.Either` to handle errors and responses in a better way.
* Create some basic functions to just `get` and `post` etc.
* Clean up the types and type signatures.
* Rearrange the type signatures so operations can be sequenced `startXHR >>= open ...` etc.
