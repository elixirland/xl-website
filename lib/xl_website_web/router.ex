defmodule XlWebsiteWeb.Router do
  use XlWebsiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {XlWebsiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", XlWebsiteWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/ecosystem", PageController, :ecosystem
    get "/projects", PageController, :projects
    get "/projects/:slug", PageController, :project
    get "/about", PageController, :about
    get "/reviewing", PageController, :reviewing
    get "/contributions", PageController, :contributions
    get "/contributions/submission-guidelines", PageController, :guidelines
  end

  scope "/webhooks", XlWebsiteWeb do
    pipe_through :api

    post "/push", WebhookController, :callback
    post "/ecosystem", WebhookController, :ecosystem
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:xl_website, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: XlWebsiteWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
