defmodule SafitechBackendWeb.AdminLoginLive do
  use SafitechBackendWeb, :live_view

  @admin_hash "$2b$12$H6nU0Gxw8Pj/7/8a8D8O6e5k6Q0R/PqfYh9jKJzO2N7HnKfM0l5lK"
  # Replace this with your hashed password from Bcrypt

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, password: "", logged_in: false, error: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm mt-20 p-6 border rounded shadow">
      <h2 class="text-2xl font-bold mb-4">Admin Login</h2>

      <%= if @logged_in do %>
        <p class="text-green-600 font-semibold mb-2">Logged in as Admin!</p>
        <button class="btn btn-primary" phx-click="logout">Logout</button>
      <% else %>
        <%= if @error do %>
          <p class="text-red-600 mb-2"><%= @error %></p>
        <% end %>

        <.form for={:admin} phx-submit="login">
          <.input type="password" name="password" value={@password} placeholder="Admin Password" required />
          <.button class="btn btn-primary mt-2 w-full">Login</.button>
        </.form>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("login", %{"admin" => %{"password" => password}}, socket) do
    if Bcrypt.verify_pass(password, @admin_hash) do
      {:noreply, assign(socket, logged_in: true, error: nil, password: "")}
    else
      {:noreply, assign(socket, error: "Incorrect password", password: "")}
    end
  end

  def handle_event("logout", _params, socket) do
    {:noreply, assign(socket, logged_in: false)}
  end
end
