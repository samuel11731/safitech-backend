defmodule SafitechBackendWeb.Layouts do
  use SafitechBackendWeb, :html

  def root(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
        <.live_title suffix=" · Safitech Admin">
          <%= assigns[:page_title] || "Safitech Admin" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"}/>
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}></script>
      </head>
      <body class="bg-white antialiased">
        <%= @inner_content %>
      </body>
    </html>
    """
  end

  # Add the missing app/1 function that LiveView is looking for
  attr :flash, :map, required: true
  attr :current_scope, :map, default: nil
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="csrf-token" content={Phoenix.Controller.get_csrf_token()} />
        <.live_title suffix=" · Safitech">
          <%= assigns[:page_title] || "Safitech" %>
        </.live_title>
        <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"}/>
        <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}></script>
      </head>
      <body class="bg-white antialiased">
        <%= render_slot(@inner_block) %>
      </body>
    </html>
    """
  end
end

  def flash_group(assigns) do
    ~H"""
    <div class="flash-group">
      <!-- Add flash message rendering here -->
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <button class="theme-toggle">
      Toggle Theme
    </button>
    """
  end

  def flash_group(assigns) do
    ~H"""
    <div class="flash-group">
      <!-- Add flash message rendering here -->
    </div>
    """
  end

  def theme_toggle(assigns) do
    ~H"""
    <button class="theme-toggle">
      Toggle Theme
    </button>
    """
  end
