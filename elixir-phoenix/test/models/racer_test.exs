defmodule BotoGP.RacerTest do
  use BotoGP.ModelCase

  alias BotoGP.Racer

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Racer.changeset(%Racer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Racer.changeset(%Racer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
