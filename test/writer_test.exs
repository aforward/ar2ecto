defmodule Ar2ecto.WriterTest do
  use ExUnit.Case
  alias Ar2ecto.Writer, as: W

  defp create_dir do
    File.mkdir_p("tmp/migrations")
    on_exit(:cleanup, fn -> File.rm_rf!("tmp/migrations") end)
  end

  test "destination" do
    assert W.destination("x.rb","./tmp/migrations") == "./tmp/migrations/x.exs"
    assert W.destination("./somewhere/else/x.rb","./tmp/migrations") == "./tmp/migrations/x.exs"
  end

  test "write" do
    create_dir
    W.write(["a","b"], "test/fixtures/activerecord/20080727191751_create_users.rb", "tmp/migrations")
    assert File.read!("tmp/migrations/20080727191751_create_users.exs") == "a\nb"
  end

end
