defmodule ElixirLdap.Entry do
  require Record

  record = Record.extract(:eldap_entry, from_lib: "eldap/include/eldap.hrl")
  keys   = Enum.map(record, &elem(&1, 0))
  vals   = Enum.map(keys, &{&1, [], nil})
  pairs  = Enum.zip(keys, vals)

  defstruct keys
  @type t :: %__MODULE__{}

  def to_record(%ElixirLdap.Entry{unquote_splicing(pairs)})   do
    {:eldap_entry, unquote_splicing(vals)}
  end

  def from_record(eldap_tnry)
  def from_record({:eldap_entry, unquote_splicing(vals)}) do
    %ElixirLdap.Entry{unquote_splicing(pairs)}
  end
end
