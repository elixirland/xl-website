defmodule XlWebsite.FileSystem do
  @callback read!(path :: File.Path.t()) :: binary()
  @callback write!(path :: File.Path.t(), content :: iodata()) :: :ok
  @callback mkdir!(path :: File.Path.t()) :: :ok
  @callback exists?(path :: File.Path.t(), [exists_option]) :: boolean()
            when exists_option: :raw

  def read!(path), do: impl().read!(path)
  def write!(path, content), do: impl().write!(path, content)
  def mkdir!(path), do: impl().mkdir!(path)
  def exists?(path, opts \\ []), do: impl().exists?(path, opts)

  def impl(), do: Application.get_env(:xl_website, :file_system, File)
end

defmodule FileFake do
  alias XlWebsite.FileSystem
  @behaviour FileSystem

  @impl FileSystem
  def read!(_path), do: "mocked content"

  @impl FileSystem
  def write!(_path, _content), do: :ok

  @impl FileSystem
  def mkdir!(_path), do: :ok

  @impl FileSystem
  def exists?(_path, _opts), do: true
end
