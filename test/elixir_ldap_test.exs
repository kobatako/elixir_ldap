defmodule ElixirLdapTest do
  use ExUnit.Case
  doctest ElixirLdap

  test "open ldap client", _ do
    {result, _} = ElixirLdap.open()
    assert result == :ok
  end

  test "connect ldap client", _ do
    {result, _} = ElixirLdap.connect()
    assert result == :ok
  end

  test "open ldap and simple bind", _ do
    {_, handle} = ElixirLdapClient.open()
    {result, _} = ElixirLdap.simple_bind(, "cn=Manager,dc=home,dc=local", "secret")
    ElixirLdap.close(handle)
    assert result == :ok
  end

  test "search base" do
    {_, handle} = ElixirLdap.connect()
    
  end
end
