defmodule BotoGP.CircuitControllerTest do
  use BotoGP.ConnCase

  alias BotoGP.Circuit
  @valid_attrs %{checkpoints: "some content", height: 42, name: "some content", scale: 42, width: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, circuit_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    circuit = Repo.insert! %Circuit{}
    conn = get conn, circuit_path(conn, :show, circuit)
    assert json_response(conn, 200)["data"] == %{"id" => circuit.id,
      "name" => circuit.name,
      "width" => circuit.width,
      "height" => circuit.height,
      "scale" => circuit.scale,
      "checkpoints" => circuit.checkpoints}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, circuit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, circuit_path(conn, :create), circuit: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Circuit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, circuit_path(conn, :create), circuit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    circuit = Repo.insert! %Circuit{}
    conn = put conn, circuit_path(conn, :update, circuit), circuit: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Circuit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    circuit = Repo.insert! %Circuit{}
    conn = put conn, circuit_path(conn, :update, circuit), circuit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    circuit = Repo.insert! %Circuit{}
    conn = delete conn, circuit_path(conn, :delete, circuit)
    assert response(conn, 204)
    refute Repo.get(Circuit, circuit.id)
  end
end
