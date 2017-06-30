defmodule BotoGP.RacerController do
  use BotoGP.Web, :controller

  alias BotoGP.Racer

  def index(conn, _params) do
    racers = Repo.all(Racer)
    render(conn, "index.html", racers: racers)
  end

  def new(conn, _params) do
    changeset = Racer.changeset(%Racer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"racer" => racer_params}) do
    changeset = Racer.changeset(%Racer{}, racer_params)

    case Repo.insert(changeset) do
      {:ok, _racer} ->
        conn
        |> put_flash(:info, "Racer created successfully.")
        |> redirect(to: racer_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    racer = Repo.get!(Racer, id)
    render(conn, "show.html", racer: racer)
  end

  def edit(conn, %{"id" => id}) do
    racer = Repo.get!(Racer, id)
    changeset = Racer.changeset(racer)
    render(conn, "edit.html", racer: racer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "racer" => racer_params}) do
    racer = Repo.get!(Racer, id)
    changeset = Racer.changeset(racer, racer_params)

    case Repo.update(changeset) do
      {:ok, racer} ->
        conn
        |> put_flash(:info, "Racer updated successfully.")
        |> redirect(to: racer_path(conn, :show, racer))
      {:error, changeset} ->
        render(conn, "edit.html", racer: racer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    racer = Repo.get!(Racer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(racer)

    conn
    |> put_flash(:info, "Racer deleted successfully.")
    |> redirect(to: racer_path(conn, :index))
  end
end
