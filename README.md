Ar2ecto
=======

This project is to help you migrate a ruby project that is using ActiveRecord towards an Elixir project that uses Ecto.  The first feature is to transform your migrations from ruby (rb) to elixir (exs).


Getting Started
=======

Install the latest version

```
git clone git@github.com:aforward/ar2ecto.git
cd ar2ecto
mix do deps.get, compile
```

Transform from your ruby ActiveRecord migrations to
Ecto migrations.

```
mix ar2ecto MyApp \
  /path/to/rubyproj/db/migrate \
  /path/to/elixirproj/priv/repo/migrations
```

The output should look similar to

```
Migrating MyApp from ActiveRecord to Ecto...
  -- Looking for migrations in /path/to/rubyproj/db/migrate
  -- Migrating to /path/to/elixirproj/priv/repo/migrations
DONE, Migrating from ActiveRecord to Ecto.
```

And within that diretory you should see your new migrations.

This is under active development so please be vocal when you encounter issues.
