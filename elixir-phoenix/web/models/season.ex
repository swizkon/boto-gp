defmodule BotoGP.Season do
  use BotoGP.Web, :model

    use Ecto.Schema

    import Ecto.Changeset
    
  schema "seasons" do
    field :name, :string
    field :ticket, :string
    field :description, :string

    timestamps
  end

  @required_fields ~w(name ticket description)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :ticket, :description])
    |> validate_required([:name, :ticket, :description])
  end

  # def changeset(model, params \\ :empty) do
  #   model
  #   |> cast(params, @required_fields, @optional_fields)
  # end

end
