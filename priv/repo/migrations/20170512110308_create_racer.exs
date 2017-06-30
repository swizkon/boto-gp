defmodule BotoGP.Repo.Migrations.CreateRacer do
  use Ecto.Migration

  def change do
    create table(:racers) do
      add :name, :string
      add :description, :string
      add :number, :string
      add :colors, :string

      timestamps()
    end

  end
end
