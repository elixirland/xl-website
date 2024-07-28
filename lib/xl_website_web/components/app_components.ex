defmodule XlWebsiteWeb.AppComponents do
  use XlWebsiteWeb, :html

  attr :repo, :map

  def exercise_card(assigns) do
    ~H"""
    <.link href={@repo.html_url}>
      <article class="w-[360px] bg-white rounded-xl overflow-clip hover:-translate-x-[2px] hover:-translate-y-[3px] transition-all shadow-md hover:shadow-lg relative">
        <%!-- TODO: Replace hard-coded status --%>
        <span class="absolute top-2 right-2 bg-[#f7f7f7f7] drop-shadow py-1 px-2 font-medium rounded-md text-[0.8rem] tracking-wide"><%= status(@repo.name) %></span>
        <img
          src={"/images/#{@repo.name}.webp"}
          width="360"
          height="240"
          class="h-[240px] bg-cover bg-center"
        />
        <div class="p-5 flex flex-col h-[180px]">
          <h1 class="text-3xl mb-1.5 font-bold">
            <%= @repo.name %>
          </h1>
          <p><%= @repo.description %></p>
          <div class="mt-auto flex gap-2 flex-wrap">
            <.topic
              :for={topic <- @repo.topics}
              topic={topic}
            />
          </div>
        </div>
      </article>
    </.link>
    """
  end

  defp status(repo_name) do
    case repo_name do
      "Book Club" -> "Ready To Be Reviewed"
      _ -> "In Development"
    end
  end

  attr :topic, :string

  def topic(assigns) do
    ~H"""
    <span class="bg-primary-100 text-primary-900 rounded-md px-2 py-1 text-xs bg-indigo-50">
      <%= @topic %>
    </span>
    """
  end
end
