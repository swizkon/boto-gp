defmodule SomedayIsle.PitstopTest do
  use SomedayIsle.ModelCase

  alias SomedayIsle.Pitstop

  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pitstop.changeset(%Pitstop{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pitstop.changeset(%Pitstop{}, @invalid_attrs)
    refute changeset.valid?
  end
end