defmodule SafitechBackend.Messages do
  import Ecto.Query
  alias SafitechBackend.Repo
  alias SafitechBackend.Messages.Message

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def list_messages(opts \\ []) do
    page = Keyword.get(opts, :page, 1)
    per_page = Keyword.get(opts, :per_page, 50)
    unread_only = Keyword.get(opts, :unread_only, false)

    query = from(m in Message, order_by: [desc: m.inserted_at])

    query =
      if unread_only do
        from(m in query, where: m.is_read == false)
      else
        query
      end

    messages =
      query
      |> limit(^per_page)
      |> offset(^((page - 1) * per_page))
      |> Repo.all()

    total = Repo.aggregate(query, :count)

    %{
      messages: messages,
      total: total,
      page: page,
      per_page: per_page
    }
  end

  # NEW: Simple list for admin (no pagination)
  def list_messages_ordered do
    from(m in Message, order_by: [desc: m.inserted_at])
    |> Repo.all()
  end

  # NEW: List only unread messages
  def list_unread_messages do
    from(m in Message, where: m.is_read == false, order_by: [desc: m.inserted_at])
    |> Repo.all()
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def mark_as_read(%Message{} = message) do
    message
    |> Ecto.Changeset.change(is_read: true)
    |> Repo.update()
  end

  # NEW: Update message function
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def get_stats do
    total = Repo.aggregate(Message, :count)

    unread =
      from(m in Message, where: m.is_read == false)
      |> Repo.aggregate(:count)

    today =
      from(m in Message,
        where: fragment("DATE(?)", m.inserted_at) == ^Date.utc_today()
      )
      |> Repo.aggregate(:count)

    %{
      total: total,
      unread: unread,
      today: today
    }
  end
end
