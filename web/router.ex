defmodule BotoGP.Router do
  use BotoGP.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BotoGP do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/seasons", BotoGP do  
    pipe_through :browser # Use the default browser stack
    get "/edit/:seasonid", SeasonController, :edit
    get "/", SeasonController, :index
    get "/new", SeasonController, :new
    get "/:seasonid", SeasonController, :show
    delete "/:seasonid", SeasonController, :delete
    post "/", SeasonController, :create
    put "/:seasonid", SeasonController, :update
  end

  scope "/racers", BotoGP do  
    pipe_through :browser # Use the default browser stack
    get "/edit/:id", RacerController, :edit
    get "/", RacerController, :index
    get "/new", RacerController, :new
    get "/:id", RacerController, :show
    delete "/:id", RacerController, :delete
    post "/", RacerController, :create
    put "/:id", RacerController, :update
  end

  scope "/endurance", BotoGP do  
    pipe_through :browser # Use the default browser stack
    get "/edit/:id", EnduranceController, :edit
    get "/", EnduranceController, :index
    get "/new", EnduranceController, :new
    get "/race/:id", EnduranceController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", BotoGP do
    pipe_through :api
    resources "/circuits", CircuitController
    options "/circuits", CircuitController, :options
    get "/circuits/:id/tileinfo", CircuitController, :tileinfo
  end

end
