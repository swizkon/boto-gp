defmodule BotoGP.Repo.Migrations.CreateCircuit do
  use Ecto.Migration

  def change do
    create table(:circuits) do
      add :name, :string
      add :width, :integer
      add :height, :integer
      add :scale, :integer
      add :checkpoints, :text
      add :datamap, :jsonb

      timestamps()
    end

  end
end
