defmodule BotoGP.JourneyController do
  use BotoGP.Web, :controller

  #import BotoGP.Router.Helpers

  alias BotoGP.Journey

  def index(conn, _params) do
    journeys = Repo.all(Journey)
    render(conn, "index.html", journeys: journeys)
  end

  def new(conn, _params) do
    changeset = Journey.changeset(%Journey{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"journey" => journey_params}) do
    changeset = Journey.changeset(%Journey{}, journey_params)

    case Repo.insert(changeset) do
      {:ok, _journey} ->
        conn
        |> put_flash(:info, "Journey created successfully.")
        |> redirect(to: journey_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"journeyid" => journeyid}) do
    journey = Repo.get!(Journey, journeyid)
    render(conn, "show.html", journey: journey)
  end

  def edit(conn, %{"journeyid" => journeyid}) do
    journey = Repo.get!(Journey, journeyid)
    changeset = Journey.changeset(journey)
    render(conn, "edit.html", journey: journey, changeset: changeset)
  end

  def update(conn, %{"journeyid" => journeyid, "journey" => journey_params}) do
    journey = Repo.get!(Journey, journeyid)
    changeset = Journey.changeset(journey, journey_params)

    case Repo.update(changeset) do
      {:ok, journey} ->
        conn
        |> put_flash(:info, "Journey updated successfully.")
        |> redirect(to: journey_path(conn, :show, journey))
      {:error, changeset} ->
        render(conn, "edit.html", journey: journey, changeset: changeset)
    end
  end

  def delete(conn, %{"journeyid" => journeyid}) do
    journey = Repo.get!(Journey, journeyid)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(journey)

    conn
    |> put_flash(:info, "Journey deleted successfully.")
    |> redirect(to: journey_path(conn, :index))
  end
end
