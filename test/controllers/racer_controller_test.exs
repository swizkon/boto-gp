defmodule BotoGP.RacerControllerTest do
  use BotoGP.ConnCase

  alias BotoGP.Racer
  @valid_attrs %{description: "some content", name: "some name"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, racer_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing racers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, racer_path(conn, :new)
    assert html_response(conn, 200) =~ "New racer"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, racer_path(conn, :create), racer: @valid_attrs
    assert redirected_to(conn) == racer_path(conn, :index)
    assert Repo.get_by(Racer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, racer_path(conn, :create), racer: @invalid_attrs
    assert html_response(conn, 200) =~ "New racer"
  end

  test "shows chosen resource", %{conn: conn} do
    racer = Repo.insert! %Racer{}
    conn = get conn, racer_path(conn, :show, racer)
    assert html_response(conn, 200) =~ "Show racer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, racer_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    racer = Repo.insert! %Racer{}
    conn = get conn, racer_path(conn, :edit, racer)
    assert html_response(conn, 200) =~ "Edit racer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    racer = Repo.insert! %Racer{}
    conn = put conn, racer_path(conn, :update, racer), racer: @valid_attrs
    assert redirected_to(conn) == racer_path(conn, :show, racer)
    assert Repo.get_by(Racer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    racer = Repo.insert! %Racer{}
    conn = put conn, racer_path(conn, :update, racer), racer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit racer"
  end

  test "deletes chosen resource", %{conn: conn} do
    racer = Repo.insert! %Racer{}
    conn = delete conn, racer_path(conn, :delete, racer)
    assert redirected_to(conn) == racer_path(conn, :index)
    refute Repo.get(Racer, racer.id)
  end
end
