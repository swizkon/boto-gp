defmodule BotoGP.EnduranceController do
  use BotoGP.Web, :controller

  alias BotoGP.Circuit

  def index(conn, _params) do
    circuits = Repo.all(Circuit)
    render(conn, "index.html", circuits: circuits)
  end

  #def new(conn, _params) do
  #  changeset = Circuit.changeset(%Circuit{})
  #  render(conn, "new.html", changeset: changeset)
  #end

  def edit(conn, %{"id" => circuitid}) do
    circuit = Repo.get!(Circuit, circuitid)
    render(conn, "edit.html", circuit: circuit)
  end

  #def show(conn, %{"id" => circuitid}) do
  #  circuit = Repo.get!(Circuit, circuitid)
  #  render(conn, "show.html", circuit: circuit)
  #end
  
end
