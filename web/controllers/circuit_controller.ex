defmodule BotoGP.CircuitController do
  use BotoGP.Web, :controller

  alias BotoGP.Circuit

  def options(conn, _params) do
    conn
  end

  def tileinfo(conn, %{"id" => id, "x" => x, "y" => y}) do
    circuit = Repo.get!(Circuit, id)
    row = circuit.datamap["heat"][y]
    tile = calc_tile(row, String.to_integer(x))
    text conn, tile
  end

  defp calc_tile(:nil, x), do: "Out" # "No match on this row, fried.."
  defp calc_tile(row, -1), do: "Out" # "No match on this col"
  defp calc_tile(row, x) do
    tile = row[Integer.to_string(x)]
    calc_tile(row, tile, x - 1)
  end

  defp calc_tile(row, 1, x), do: "Hit"
  defp calc_tile(row, 0, x), do: "Out"
  defp calc_tile(row, :nil, x) do
    calc_tile(row, x)
  end

  def index(conn, _params) do
    circuits = Repo.all(Circuit)
    render(conn, "index.json", circuits: circuits)
  end

  def create(conn, %{"circuit" => circuit_params}) do
    changeset = Circuit.changeset(%Circuit{}, circuit_params)

    case Repo.insert(changeset) do
      {:ok, circuit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", circuit_path(conn, :show, circuit))
        |> render("show.json", circuit: circuit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BotoGP.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    circuit = Repo.get!(Circuit, id)
    render(conn, "show.json", circuit: circuit)
  end

  def update(conn, %{"id" => id, "circuit" => circuit_params}) do
    circuit = Repo.get!(Circuit, id)
    changeset = Circuit.changeset(circuit, circuit_params)

    case Repo.update(changeset) do
      {:ok, circuit} ->
        render(conn, "show.json", circuit: circuit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(BotoGP.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    circuit = Repo.get!(Circuit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(circuit)

    send_resp(conn, :no_content, "")
  end
end
