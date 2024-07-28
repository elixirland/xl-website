defmodule XlWebsite.FileSystem do
  @callback read!(path :: File.Path.t()) :: binary()
  @callback read(path :: File.Path.t()) :: {:ok, binary()} | {:error, File.posix()}
  @callback write!(path :: File.Path.t(), content :: iodata()) :: :ok
  @callback mkdir_p!(path :: File.Path.t()) :: :ok
  @callback exists?(path :: File.Path.t(), [exists_option]) :: boolean()
            when exists_option: :raw

  def read!(path), do: impl().read!(path)
  def read(path), do: impl().read(path)
  def write!(path, content), do: impl().write!(path, content)
  def mkdir_p!(path), do: impl().mkdir_p!(path)
  def exists?(path, opts \\ []), do: impl().exists?(path, opts)

  def impl(), do: Application.get_env(:xl_website, :file_system, File)
end

defmodule FileFake do
  alias XlWebsite.FileSystem
  @behaviour FileSystem

  @impl FileSystem
  def read!(path), do: {:ok, read(path)}

  @impl FileSystem
  def read(path) do
    file = Path.basename(path)
    dir = Path.dirname(path)
    read(file, dir)
  end

  def read("topics.json", _), do: {:ok, topics()}
  def read("README.md", _), do: {:ok, readme_md()}
  def read(_, _), do: {:ok, "Some file content"}

  @impl FileSystem
  def write!(_path, _content), do: :ok

  @impl FileSystem
  def mkdir_p!(_path), do: :ok

  @impl FileSystem
  def exists?(_path, _opts), do: true

  defp topics(), do: ~s|["topic1", "topic2"]|

  defp readme_md() do
    """
    # Some Exercise Name
    Some text.

    ## Status
    Exercise: ***Not Reviewed***<br>
    Solution: ***Not Reviewed***

    > [!NOTE]
    > Some note.

    ## Introduction
    Some text.

    ## Task
    Some text.

    ## Requirements
    ### Some heading
      - Some list.

    > [!TIP]
    > Some tip.

    ## How to get started
    Some text.

    ## Example solution
    Some text.
    """
  end
end
