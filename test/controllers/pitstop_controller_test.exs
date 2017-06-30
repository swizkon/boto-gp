defmodule BotoGP.PitstopControllerTest do
  use BotoGP.ConnCase

  alias BotoGP.Pitstop
  @valid_attrs %{description: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pitstop_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing pitstops"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, pitstop_path(conn, :new)
    assert html_response(conn, 200) =~ "New pitstop"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, pitstop_path(conn, :create), pitstop: @valid_attrs
    assert redirected_to(conn) == pitstop_path(conn, :index)
    assert Repo.get_by(Pitstop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pitstop_path(conn, :create), pitstop: @invalid_attrs
    assert html_response(conn, 200) =~ "New pitstop"
  end

  test "shows chosen resource", %{conn: conn} do
    pitstop = Repo.insert! %Pitstop{}
    conn = get conn, pitstop_path(conn, :show, pitstop)
    assert html_response(conn, 200) =~ "Show pitstop"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pitstop_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    pitstop = Repo.insert! %Pitstop{}
    conn = get conn, pitstop_path(conn, :edit, pitstop)
    assert html_response(conn, 200) =~ "Edit pitstop"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pitstop = Repo.insert! %Pitstop{}
    conn = put conn, pitstop_path(conn, :update, pitstop), pitstop: @valid_attrs
    assert redirected_to(conn) == pitstop_path(conn, :show, pitstop)
    assert Repo.get_by(Pitstop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pitstop = Repo.insert! %Pitstop{}
    conn = put conn, pitstop_path(conn, :update, pitstop), pitstop: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit pitstop"
  end

  test "deletes chosen resource", %{conn: conn} do
    pitstop = Repo.insert! %Pitstop{}
    conn = delete conn, pitstop_path(conn, :delete, pitstop)
    assert redirected_to(conn) == pitstop_path(conn, :index)
    refute Repo.get(Pitstop, pitstop.id)
  end
end
