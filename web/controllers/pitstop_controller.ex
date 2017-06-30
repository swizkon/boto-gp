defmodule BotoGP.PitstopController do
  use BotoGP.Web, :controller

  alias BotoGP.Pitstop

  def index(conn, _params) do
    pitstops = Repo.all(Pitstop)
    render(conn, "index.html", pitstops: pitstops)
  end

  def new(conn, _params) do
    changeset = Pitstop.changeset(%Pitstop{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pitstop" => pitstop_params}) do
    changeset = Pitstop.changeset(%Pitstop{}, pitstop_params)

    case Repo.insert(changeset) do
      {:ok, _pitstop} ->
        conn
        |> put_flash(:info, "Pitstop created successfully.")
        |> redirect(to: pitstop_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pitstop = Repo.get!(Pitstop, id)
    render(conn, "show.html", pitstop: pitstop)
  end

  def edit(conn, %{"id" => id}) do
    pitstop = Repo.get!(Pitstop, id)
    changeset = Pitstop.changeset(pitstop)
    render(conn, "edit.html", pitstop: pitstop, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pitstop" => pitstop_params}) do
    pitstop = Repo.get!(Pitstop, id)
    changeset = Pitstop.changeset(pitstop, pitstop_params)

    case Repo.update(changeset) do
      {:ok, pitstop} ->
        conn
        |> put_flash(:info, "Pitstop updated successfully.")
        |> redirect(to: pitstop_path(conn, :show, pitstop))
      {:error, changeset} ->
        render(conn, "edit.html", pitstop: pitstop, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pitstop = Repo.get!(Pitstop, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pitstop)

    conn
    |> put_flash(:info, "Pitstop deleted successfully.")
    |> redirect(to: pitstop_path(conn, :index))
  end
end
