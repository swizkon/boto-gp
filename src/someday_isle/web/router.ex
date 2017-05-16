defmodule SomedayIsle.Router do
  use SomedayIsle.Web, :router

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

  scope "/", SomedayIsle do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/journeys", SomedayIsle do  
    pipe_through :browser # Use the default browser stack
    get "/edit/:journeyid", JourneyController, :edit
    get "/", JourneyController, :index
    get "/new", JourneyController, :new
    get "/:journeyid", JourneyController, :show
    delete "/:journeyid", JourneyController, :delete
    post "/", JourneyController, :create
    put "/:journeyid", JourneyController, :update
  end

  scope "/pitstops", SomedayIsle do  
    pipe_through :browser # Use the default browser stack
    get "/edit/:id", PitstopController, :edit
    get "/", PitstopController, :index
    get "/new", PitstopController, :new
    get "/:id", PitstopController, :show
    delete "/:id", PitstopController, :delete
    post "/", PitstopController, :create
    put "/:id", PitstopController, :update
  end

  # Other scopes may use custom stacks.
  scope "/api", SomedayIsle do
    pipe_through :api
    resources "/circuits", CircuitController
    options "/circuits", CircuitController, :options
  end

end