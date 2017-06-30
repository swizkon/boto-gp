defmodule BotoGP.CircuitView do
  use BotoGP.Web, :view

  #def render("index.json", %{circuits: circuits}) do
  #  %{data: render_many(circuits, BotoGP.CircuitView, "circuit.json")}
  #end

  def render("index.json", %{circuits: circuits}) do
    Enum.map(circuits, &Map.take(&1, [:id, :name, :checkpoints]))
  end

  def render("show.json", %{circuit: circuit}) do
    %{data: render_one(circuit, BotoGP.CircuitView, "circuit.json")}
  end

  def render("circuit.json", %{circuit: circuit}) do
    %{id: circuit.id,
      name: circuit.name,
      width: circuit.width,
      height: circuit.height,
      scale: circuit.scale,
      checkpoints: circuit.checkpoints,
      datamap: circuit.datamap}
  end
end
