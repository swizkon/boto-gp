defmodule BotoGP.Repo.Migrations.CreateJourney do
  use Ecto.Migration

  def change do
    create table(:journeys) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
