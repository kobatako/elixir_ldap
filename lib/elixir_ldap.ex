defmodule ElixirLdap do
  @moduledoc """
  This module LDAP Client for Elixir.

  ## Using ElixirLdap Example

  ElixirLdap example

      iex> handle = ElixirLdap.connect("192.168.11.101")
      #PID<0.212.0>

      iex> ElixirLdap.Search.search_single_level_all(handle)
      {:ok,
      [%ElixirLdap.Entry{attributes: [{'objectClass', ['dcObject', 'organization']},
          {'dc', ['corporation']}, {'o', ['Corporation Inc']}],
        object_name: 'dc=corporation,dc=home,dc=local'}]}

      iex> ElixirLdap.Search.search_subtree(handle, [filter: :equal, field: "cn", name: "user01"])
      {:ok,
      [%ElixirLdap.Entry{attributes: [{'objectClass', ['person']},
          {'sn', ['Valentine']}, {'telephoneNumber', ['041 000 000']},
          {'cn', ['user01']}],
        object_name: 'cn=user01,ou=People,dc=corporation,dc=home,dc=local'}]}

  connect LDAP server and search signle level and search subtree equal cn

  """

  @doc """
  open handle ldap client socket

  ## Example

      ElixirLdap.open("127.0.0.1", [port: port, ssl: ssl, timeout: timeout])

  ### parameter
  port : connect to port
  ssl : true or false
  timeout : connect timeout
  """
  def open(host, options) when is_list(options) do
    :eldap.open([to_charlist(host)], options)
  end

  @doc """
  open handle ldap client socket

  ## Example

      ElixirLdap.open("127.0.0.1")

  ### parameter
  open parameter config.exs

      config :elixir_ldap, :settings,
        host: "127.0.0.1",
        port: 389,
        ssl: false,
        timeout: 5000,
        user_dn: "cn=Manager,dc=home,dc=local",
        password: "secret",
        base: "dc=home,dc=local"
  """
  def open(host) do
    options =
      Application.get_env(:elixir_ldap, :settings)
      |> Keyword.take([:port, :ssl, :timeout])

    open(host, options)
  end

  def open() do
    {:ok, host} =
      Application.get_env(:elixir_ldap, :settings)
      |> Keyword.fetch(:host)

    open(host)
  end

  @doc """
  ldap connect open and simple bind

  ## Example

      ElixirLdap.connect("127.0.0.1", [port: port, ssl: ssl, timeout: timeout])

  """
  def connect(
        host,
        [port: port, ssl: ssl, timeout: timeout],
        user_dn: user_dn,
        password: password
      ) do
    case open([to_charlist(host)], port: port, ssl: ssl, timeout: timeout) do
      {:ok, handle} -> simple_bind(handle, user_dn, password)
      error -> error
    end
  end

  def connect(host, user_dn: user_dn, password: password) do
    options =
      Application.get_env(:elixir_ldap, :settings)
      |> Keyword.take([:port, :ssl, :timeout])

    case open(host, options) do
      {:ok, handle} -> simple_bind(handle, user_dn, password)
      error -> error
    end
  end

  def connect(host, port: port, ssl: ssl, timeout: timeout) do
    [user_dn: user_dn, password: password] =
      Application.get_env(:elixir_ldap, :settings)
      |> Keyword.take([:user_dn, :password])

    case open(host, port: port, ssl: ssl, timeout: timeout) do
      {:ok, handle} -> simple_bind(handle, user_dn, password)
      error -> error
    end
  end

  def connect(host) do
    options =
      Application.get_env(:elixir_ldap, :settings)
      |> Keyword.take([:port, :ssl, :timeout])

    connect(host, options)
  end

  def connect() do
    settings = Application.get_env(:elixir_ldap, :settings)
    {:ok, host} = Keyword.fetch(settings, :host)
    connect(host)
  end

  @doc """
  """
  def simple_bind(handle, user_dn, password) do
    case :eldap.simple_bind(handle, user_dn, password) do
      :ok -> handle
      {_, message} -> {:error, message}
    end
  end

  @doc """
  close handle

  ## Exsample

      ElixirLdap.close(handle)

  """
  def close(handle) do
    :eldap.close(handle)
  end

  defp to_char_tuple_key({key, value}) do
    {to_charlist(key), value}
  end

  defp to_listchar_atom_key(dn_list) do
    Enum.map_join(dn_list, ",", fn {key, value} -> to_string(key) <> "=" <> value end)
  end

  @doc """
  add entry

  ## Exsample

      ElixirLdap.add(handle, [cn: "user01", ou: "People", dc: "corporation", dc: "home", dc: "local"], [telephoneNumber: ["545 555 0001"], objectClass: ["person"], sn: ["user"]])

  """
  def add(handle, dn, attribute) when is_list(dn) and is_list(attribute) do
    add(handle, to_listchar_atom_key(dn), Enum.map(attribute, &to_char_tuple_key(&1)))
  end

  @doc """
  add entry

  ## Exsample

      ElixirLdap.add(handle, "cn=user01,ou=People,dc=corporation,dc=home,dc=local", [telephoneNumber: ["545 555 0001"], objectClass: ["person"], sn: ["user"]])

  """
  def add(handle, dn, attribute) when is_list(attribute) do
    :eldap.add(handle, to_charlist(dn), Enum.map(attribute, &to_char_tuple_key(&1)))
  end

  @doc """
  delete entry

  ## Exsample

      ElixirLdap.delete(handle, [cn: "user01", ou: "People", dc: "corporation", dc: "home", dc: "local"])

  """
  def delete(handle, dn) when is_list(dn) do
    delete(handle, to_listchar_atom_key(dn))
  end

  @doc """
  delete entry

  ## Exsample

      ElixirLdap.delete(handle, "cn=user01,ou=People,dc=corporation,dc=home,dc=local")

  """
  def delete(handle, dn) do
    :eldap.delete(handle, to_charlist(dn))
  end

  @doc """
  """
  defp mod_options_params({type, value}) when is_list(value) do
    mod_options_params({:replace, type, value})
  end

  defp mod_options_params({:add, type, value}) when is_list(value) do
    :eldap.mod_add(to_charlist(type), value)
  end

  defp mod_options_params({:replace, type, value}) when is_list(value) do
    :eldap.mod_replace(to_charlist(type), value)
  end

  defp mod_options_params({:delete, type, value}) when is_list(value) do
    :eldap.mod_delete(to_charlist(type), value)
  end

  @doc """
  modify entry

  ## Exsample

      ElixirLdap.modify(handle, "cn=user01,ou=People,dc=corporation,dc=home,dc=local", [telephoneNumber: ["545 555 333"]])

  """
  def modify(handle, dn, attribute) when is_list(dn) and is_list(attribute) do
    modify(handle, to_listchar_atom_key(dn), Enum.map(attribute, &mod_options_params(&1)))
  end

  @doc """
  modify entry

  ## Exsample

      ElixirLdap.modify(handle, [cn: "user01", ou: "People", dc: "corporation", dc: "home", dc: "local"], [telephoneNumber: ["545 555 333"]])

  """
  def modify(handle, dn, attribute) when is_list(attribute) do
    :eldap.modify(handle, to_charlist(dn), Enum.map(attribute, &mod_options_params(&1)))
  end

  @doc """
  """
  def modify_password(handle, dn, password) when is_list(dn) do
    modify_password(handle, to_listchar_atom_key(dn), to_charlist(password))
  end

  def modify_password(handle, dn, password) do
    :eldap.modify_password(handle, to_charlist(dn), to_charlist(password))
  end

  def modify_password(handle, dn, new_password, old_password) when is_list(dn) do
    modify_password(
      handle,
      to_listchar_atom_key(dn),
      to_charlist(new_password),
      to_charlist(old_password)
    )
  end

  def modify_password(handle, dn, new_password, old_password) do
    :eldap.modify_password(
      handle,
      to_charlist(dn),
      to_charlist(new_password),
      to_charlist(old_password)
    )
  end

  @doc """
  modify dn entry

  ## Exsample

      ElixirLdap.modify_dn(handle, [cn: "user01", ou: "People", dc: "corporation", dc: "home", dc: "local"], "cn=user101", true, "")

  """
  def modify_dn(handle, dn, new_rdn, delete_old_rdn, new_sup_dn) when is_list(dn) do
    modify_dn(
      handle,
      to_listchar_atom_key(dn),
      to_charlist(new_rdn),
      delete_old_rdn,
      to_charlist(new_sup_dn)
    )
  end

  @doc """
  modify dn entry

  ## Exsample

      ElixirLdap.modify_dn(handle, "cn=user01,ou=People,dc=corporation,dc=home,dc=local", "cn=user101", true, "")

  """
  def modify_dn(handle, dn, new_rdn, delete_old_rdn, new_sup_dn) do
    :eldap.modify_dn(
      handle,
      to_charlist(dn),
      to_charlist(new_rdn),
      delete_old_rdn,
      to_charlist(new_sup_dn)
    )
  end

  @doc """
  convert object name add map entity list

  ## Example

      ElixirLdap.Search.search_subtree_all(handle) |> ElixirLdap.convert_objects_name

  """
  def convert_objects_name([]) do
    nil
  end

  def convert_objects_name({:ok, objects}) do
    convert_objects_name(objects)
  end

  def convert_objects_name([object | []]) do
    [convert_object_name(object)]
  end

  def convert_objects_name([object | tail]) do
    [convert_object_name(object)] ++ convert_objects_name(tail)
  end

  @doc """
  convert objerct name add map entity

  ## Example

      ElixirLdap.convert_object_name(entity)

      >%{
      >  __struct__: ElixirLdap.Entry,
      >  attributes: [
      >    {'objectClass', ['dcObject', 'organization']},
      >    {'dc', ['corporation']},
      >    {'o', ['Corporation Inc']},
      >    {'telephoneNumber', ['999 0000 0000']},
      >    {'postalCode', ['820-0000']}
      >  ],
      >  object_name: 'dc=corporation,dc=home,dc=local',
      >  object_names: [
      >    %{"name" => "dc", "value" => "corporation"},
      >    %{"name" => "dc", "value" => "home"},
      >    %{"name" => "dc", "value" => "local"}
      >  ]
      >}

  """
  def convert_object_name(object) do
    Map.merge(object, %{
      object_names:
        Regex.split(~r/,/, to_string(object.object_name))
        |> Enum.map(&Regex.named_captures(~r/(?<name>.*)=(?<value>.*)/, &1))
    })
  end
end
