defmodule BotoGP.Pitstop do
  use BotoGP.Web, :model

  schema "pitstops" do
    field :title, :string
    field :description, :string
    belongs_to :journey, BotoGP.Journey

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title, :description])
  end
end
