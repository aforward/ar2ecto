defmodule Ar2ecto.LineTest do
  use ExUnit.Case
  alias Ar2ecto.Line, as: L

  test "parse :defmodule" do
    assert L.parse("  class CreateUsers < ActiveRecord::Migration  ") == %{type: :defmodule, name: "CreateUsers"}
  end

  test "parse :up" do
    assert L.parse("  def self.up  ") == %{type: :up}
  end

  test "parse :down" do
    assert L.parse("  def self.down  ") == %{type: :down}
  end

  test "parse :change" do
    assert L.parse("  def self.change  ") == %{type: :change}
  end

  test "parse :create_table" do
    assert L.parse("create_table \"users\", :force => true do |t|") == %{type: :create_table, name: :users}
    assert L.parse("create_table \"peoples\" do |xxx|") == %{type: :create_table, name: :peoples}
    assert L.parse("create_table :peeps do |xxx|") == %{type: :create_table, name: :peeps}
  end

  test "parse :add_field" do
    assert L.parse("t.datetime :created_at") == %{type: :add_field, name: :created_at, format: :datetime}
    assert L.parse("t.string :type") == %{type: :add_field, name: :type, format: :string}
    assert L.parse("t.integer :destroyed_by") == %{type: :add_field, name: :destroyed_by, format: :integer}
  end

  test "parse :end" do
    assert L.parse("end") == %{type: :end, line: "end"}
    assert L.parse("  end") == %{type: :end, line: "  end"}
  end

  test "parse :unknown" do
    assert L.parse("xxx") == %{type: :unknown, line: "xxx"}
  end

  test "parse nil" do
    assert L.parse(nil) == %{type: :unknown, line: nil}
  end

  test "render :defmodule" do
    actual = "class CreateUsers < ActiveRecord::Migration" |> L.parse |> L.render("MyApp")
    assert actual == "defmodule MyApp.Repo.Migrations.CreateUsers do\n  use Ecto.Migration"
  end

  test "render :up" do
    actual = "def self.up" |> L.parse |> L.render("MyApp")
    assert actual == "  def up do"
  end

  test "render :down" do
    actual = "def self.down" |> L.parse |> L.render("MyApp")
    assert actual == "  def down do"
  end

  test "render :change" do
    actual = "def self.change" |> L.parse |> L.render("MyApp")
    assert actual == "  def change do"
  end

  test "render :create_table" do
    actual = "create_table :paydays do |xxx|" |> L.parse |> L.render("MyApp")
    assert actual == "    create table(:paydays) do"
  end

  test "render :add_field" do
    actual = "t.datetime :created_at" |> L.parse |> L.render("MyApp")
    assert actual == "      add :created_at, :datetime"
  end

  test "render :end" do
    actual = "  end" |> L.parse |> L.render("MyApp")
    assert actual == "  end"
  end

  test "render :unknown" do
    actual = "xxx" |> L.parse |> L.render("MyApp")
    assert actual == "xxx"
  end

end