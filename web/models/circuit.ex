defmodule BotoGP.Circuit do
  use BotoGP.Web, :model

  schema "circuits" do
    field :name, :string
    field :width, :integer
    field :height, :integer
    field :scale, :integer
    field :checkpoints, :string
    field :datamap, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :width, :height, :scale, :checkpoints, :datamap])
    |> validate_required([:name, :width, :height, :scale, :checkpoints])
  end
end
