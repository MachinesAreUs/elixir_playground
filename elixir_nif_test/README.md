Elixir NIF Test
===============

1. Set Erlang root directory (I'm using a brew installed erlang, with fish shell)

    $ set -x ERL_ROOT /usr/local/Cellar/erlang/17.5/lib/erlang/

2. Compile the C code (this is for OSX)

    $ gcc -undefined dynamic_lookup -dynamiclib -o src/foobar_nif.so src/foobar_nif.c -I $ERL_ROOT/usr/include/

3. Test it in IEx

    iex> FooBar.foo 2
    4
    iex> FooBar.bar 3
    9
