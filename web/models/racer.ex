defmodule BotoGP.Racer do
  use BotoGP.Web, :model

  schema "racers" do
    field :name, :string
    field :description, :string
    field :colors, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
