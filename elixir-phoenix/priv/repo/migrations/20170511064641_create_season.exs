defmodule BotoGP.Repo.Migrations.CreateSeason do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :name, :string
      add :ticket, :string
      add :description, :string

      timestamps()
    end

  end
end
