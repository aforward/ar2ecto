defmodule Ar2ecto.ParserTest do
  use ExUnit.Case
  alias Ar2ecto.Parser, as: P

  setup do
    File.rm_rf!("./tmp/outfixtures")
    { :ok, [] }
  end

  test "parse a file" do
    assert P.parse("MyApp", "test/fixtures/activerecord/20080727191751_create_users.rb", "./tmp/outputfixtures")
           == "./tmp/outputfixtures/20080727191751_create_users.exs"
    assert File.read!("./tmp/outputfixtures/20080727191751_create_users.exs")
           == File.read!("test/fixtures/ecto/20080727191751_create_users.exs")
  end

  test "handle ignore_blocks" do
    P.parse("MyApp", "test/fixtures/activerecord/20080925003517_add_websites_theme.rb", "./tmp/outputfixtures")
    assert File.read!("./tmp/outputfixtures/20080925003517_add_websites_theme.exs")
           == File.read!("test/fixtures/ecto/20080925003517_add_websites_theme.exs")
  end

  test "parse multiple files" do
    assert (P.parse("MyApp", "test/fixtures/activerecord", "./tmp/outputfixtures") |> Enum.sort)
           == ["./tmp/outputfixtures/20080727191751_create_users.exs",
               "./tmp/outputfixtures/20080728200552_create_sessions.exs",
               "./tmp/outputfixtures/20080925003517_add_websites_theme.exs"]
    assert File.read!("./tmp/outputfixtures/20080727191751_create_users.exs")
           == File.read!("test/fixtures/ecto/20080727191751_create_users.exs")
    assert File.read!("./tmp/outputfixtures/20080728200552_create_sessions.exs")
           == File.read!("test/fixtures/ecto/20080728200552_create_sessions.exs")
  end

end
