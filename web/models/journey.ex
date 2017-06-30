defmodule BotoGP.Journey do
  use BotoGP.Web, :model

    use Ecto.Schema

    import Ecto.Changeset
    
  schema "journeys" do
    field :name, :string
    field :description, :string

    timestamps
  end

  @required_fields ~w(name description)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end

  # def changeset(model, params \\ :empty) do
  #   model
  #   |> cast(params, @required_fields, @optional_fields)
  # end

end
