defmodule BotoGP.JourneyControllerTest do
  use BotoGP.ConnCase

  alias BotoGP.Journey
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, journey_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing journeys"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, journey_path(conn, :new)
    assert html_response(conn, 200) =~ "New journey"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, journey_path(conn, :create), journey: @valid_attrs
    assert redirected_to(conn) == journey_path(conn, :index)
    assert Repo.get_by(Journey, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, journey_path(conn, :create), journey: @invalid_attrs
    assert html_response(conn, 200) =~ "New journey"
  end

  test "shows chosen resource", %{conn: conn} do
    journey = Repo.insert! %Journey{}
    conn = get conn, journey_path(conn, :show, journey)
    assert html_response(conn, 200) =~ "Show journey"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, journey_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    journey = Repo.insert! %Journey{}
    conn = get conn, journey_path(conn, :edit, journey)
    assert html_response(conn, 200) =~ "Edit journey"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    journey = Repo.insert! %Journey{}
    conn = put conn, journey_path(conn, :update, journey), journey: @valid_attrs
    assert redirected_to(conn) == journey_path(conn, :show, journey)
    assert Repo.get_by(Journey, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    journey = Repo.insert! %Journey{}
    conn = put conn, journey_path(conn, :update, journey), journey: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit journey"
  end

  test "deletes chosen resource", %{conn: conn} do
    journey = Repo.insert! %Journey{}
    conn = delete conn, journey_path(conn, :delete, journey)
    assert redirected_to(conn) == journey_path(conn, :index)
    refute Repo.get(Journey, journey.id)
  end
end
