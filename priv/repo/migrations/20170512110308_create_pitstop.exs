defmodule BotoGP.Repo.Migrations.CreatePitstop do
  use Ecto.Migration

  def change do
    create table(:pitstops) do
      add :title, :string
      add :description, :string
      add :journey_id, references(:journeys, on_delete: :nothing)

      timestamps()
    end
    create index(:pitstops, [:journey_id])

  end
end
