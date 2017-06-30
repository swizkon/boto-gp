defmodule BotoGP.SeasonControllerTest do
  use BotoGP.ConnCase

  alias BotoGP.Season
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, season_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing seasons"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, season_path(conn, :new)
    assert html_response(conn, 200) =~ "New season"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, season_path(conn, :create), season: @valid_attrs
    assert redirected_to(conn) == season_path(conn, :index)
    assert Repo.get_by(Season, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, season_path(conn, :create), season: @invalid_attrs
    assert html_response(conn, 200) =~ "New season"
  end

  test "shows chosen resource", %{conn: conn} do
    season = Repo.insert! %Season{}
    conn = get conn, season_path(conn, :show, season)
    assert html_response(conn, 200) =~ "Show season"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, season_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    season = Repo.insert! %Season{}
    conn = get conn, season_path(conn, :edit, season)
    assert html_response(conn, 200) =~ "Edit season"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    season = Repo.insert! %Season{}
    conn = put conn, season_path(conn, :update, season), season: @valid_attrs
    assert redirected_to(conn) == season_path(conn, :show, season)
    assert Repo.get_by(Season, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    season = Repo.insert! %Season{}
    conn = put conn, season_path(conn, :update, season), season: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit season"
  end

  test "deletes chosen resource", %{conn: conn} do
    season = Repo.insert! %Season{}
    conn = delete conn, season_path(conn, :delete, season)
    assert redirected_to(conn) == season_path(conn, :index)
    refute Repo.get(Season, season.id)
  end
end
