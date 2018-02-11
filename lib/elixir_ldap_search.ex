defmodule ElixirLdap.Search do
  @moduledoc """
  Documentation for ElixirLdap.Search
  """
  import ElixirLdap.Collation
  collation_define

  @doc """
  """
  defp is_collation_rule?(collation_rule) do
    Enum.any?(ElixirLdap.Collation.collation_rules, fn(rule) -> rule == collation_rule end)
  end

  @doc """
  """
  defp to_listchar_atom_key(dn_list) do
    Enum.map_join(dn_list, ",", fn({key, value}) -> to_string(key) <> "=" <> value end)
  end

  @doc """
  """
  def search_base_all(handle) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base_all(handle, base)
  end
  def search_base_all(handle, base) when is_list(base) do
    if is_tuple(List.first(base)) do
      search_base_all(handle, to_listchar_atom_key(base))
    else
      search_base(handle, base, [filter: :present, type: "objectClass"])
    end
  end
  def search_base_all(handle, base) do
    search_base(handle, base, [filter: :present, type: "objectClass"])
  end

  @doc """
  """
  def search_single_level_all(handle) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level_all(handle, base)
  end
  def search_single_level_all(handle, base) when is_list(base) do
    if is_tuple(List.first(base)) do
      search_single_level_all(handle, to_listchar_atom_key(base))
    else
      search_single_level(handle, base, [filter: :present, type: "objectClass"])
    end
  end
  def search_single_level_all(handle, base) do
    search_single_level(handle, base, [filter: :present, type: "objectClass"])
  end

  @doc """
  """
  def search_subtree_all(handle) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree_all(handle, base)
  end
  def search_subtree_all(handle, base) when is_list(base) do
    if is_tuple(List.first(base)) do
      search_subtree_all(handle, to_listchar_atom_key(base))
    else
    search_subtree(handle, base, [filter: :present, type: "objectClass"])
    end
  end
  def search_subtree_all(handle, base) do
    search_subtree(handle, base, [filter: :present, type: "objectClass"])
  end

  @doc """
  """
  def search_base(handle, [filter: :equal, field: field, name: name]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :equal, field: field, name: name])
  end
  def search_base(handle, base, [filter: :equal, field: field, name: name]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), equality_match(field, name), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :present, type: type]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :present, type: type])
  end
  def search_base(handle, base, [filter: :present, type: type]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), present(type), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :greater, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :greater, type: type, value: value])
  end
  def search_base(handle, base, [filter: :greater, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), greater_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :less, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :less, type: type, value: value])
  end
  def search_base(handle, base, [filter: :less, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), less_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :approx, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :approx, type: type, value: value])
  end
  def search_base(handle, base, [filter: :approx, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), approx_match(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute])
  end
  def search_base(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), extensible_match(value, type, rule, dn_attribute), :eldap.derefAlways(), false, search_timeout)
  end
  def search_base(handle, [filter: :strings, type: type, value: value]) when is_tuple(value) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, [filter: :strings, type: type, value: value])
  end
  def search_base(handle, base, [filter: :strings, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.baseObject(), substrings(type, value), :eldap.derefAlways(), false, search_timeout)
  end

  @doc """
  """
  def search_single_level(handle, [filter: :equal, field: field, name: name]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :equal, field: field, name: name])
  end
  def search_single_level(handle, base, [filter: :equal, field: field, name: name]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), equality_match(field, name), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :present, type: type]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :present, type: type])
  end
  def search_single_level(handle, base, [filter: :present, type: type]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), present(type), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :greater, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :greater, type: type, value: value])
  end
  def search_single_level(handle, base, [filter: :greater, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), greater_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :less, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :less, type: type, value: value])
  end
  def search_single_level(handle, base, [filter: :less, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), less_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :approx, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :approx, type: type, value: value])
  end
  def search_single_level(handle, base, [filter: :approx, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), approx_match(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute])
  end
  def search_single_level(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), extensible_match(value, type, rule, dn_attribute), :eldap.derefAlways(), false, search_timeout)
  end
  def search_single_level(handle, [filter: :strings, type: type, value: value]) when is_tuple(value) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, [filter: :strings, type: type, value: value])
  end
  def search_single_level(handle, base, [filter: :strings, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.singleLevel(), substrings(type, value), :eldap.derefAlways(), false, search_timeout)
  end

  @doc """
  """
  def search_subtree(handle, [filter: :equal, field: field, name: name]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :equal, field: field, name: name])
  end
  def search_subtree(handle, base, [filter: :equal, field: field, name: name]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), equality_match(field, name), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :present, type: type]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :present, type: type])
  end
  def search_subtree(handle, base, [filter: :present, type: type]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), present(type), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :greater, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :greater, type: type, value: value])
  end
  def search_subtree(handle, base, [filter: :greater, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), greater_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :less, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :less, type: type, value: value])
  end
  def search_subtree(handle, base, [filter: :less, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), less_or_equal(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :approx, type: type, value: value]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :approx, type: type, value: value])
  end
  def search_subtree(handle, base, [filter: :approx, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), approx_match(type, value), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute])
  end
  def search_subtree(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), extensible_match(value, type, rule, dn_attribute), :eldap.derefAlways(), false, search_timeout)
  end
  def search_subtree(handle, [filter: :strings, type: type, value: value]) when is_tuple(value) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, [filter: :strings, type: type, value: value])
  end
  def search_subtree(handle, base, [filter: :strings, type: type, value: value]) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :eldap.wholeSubtree(), substrings(type, value), :eldap.derefAlways(), false, search_timeout)
  end

  @doc """
  """
  def equality_match(field, name) do
    :eldap.equalityMatch(to_charlist(field), to_charlist(name))
  end

  @doc """
  """
  def present(type) do
    :eldap.present(to_charlist(type))
  end

  @doc """
  """
  def greater_or_equal(type, value) do
    :eldap.greaterOrEqual(to_charlist(type), to_charlist(value))
  end

  @doc """
  """
  def less_or_equal(type, value) do
    :eldap.lessOrEqual(to_charlist(type), to_charlist(value))
  end

  @doc """
  """
  def approx_match(type, value) do
    :eldap.approxMatch(to_charlist(type), to_charlist(value))
  end

  @doc """
  """
  def extensible_match(match_value, type, matching_rule, dn_attributes \\ false) do
    if !is_collation_rule?(matching_rule) do
      raise "not collation rule : " <> matching_rule
    end
    :eldap.extensibleMatch(to_charlist(match_value), [type: type, matchingRule: matching_rule, dnAttributes: dn_attributes])
  end

  @doc """
  """
  def substrings(type, value) when is_list(value) do
    lists = Enum.map(value, fn({atom, sub}) -> {atom, to_charlist(sub)} end)
    :eldap.substrings(to_charlist(type), lists)
  end

  @doc """
  """
  def substrings(type, {atom, sub})  do
    substrings(type, [{atom, sub}])
  end

  @doc """
  """
  def with_and(filters) do
    :eldap.and(filters)
  end

  @doc """
  """
  def with_or(filters) do
    :eldap.or(filters)
  end

  @doc """
  """
  def with_not(filters) do
    :eldap.not(filters)
  end

  @doc """
  """
  def search(handle, base, scope, filter, deref, types_only \\ false, timeout \\ 0)
  def search(handle, base, scope, filter, deref, types_only, timeout) when is_list(base) do
    if is_tuple(List.first(base)) do
        search(handle, [
          base: to_charlist(to_listchar_atom_key(base)),
          scope: scope,
          filter: filter,
          deref: deref,
          types_only: types_only,
          timeout: timeout
        ])
      else
        search(handle, [
          base: to_charlist(base),
          scope: scope,
          filter: filter,
          deref: deref,
          types_only: types_only,
          timeout: timeout
        ])
    end
  end
  def search(handle, base, scope, filter, deref, types_only, timeout) do
    search(handle, [
      base: to_charlist(base),
      scope: scope,
      filter: filter,
      deref: deref,
      types_only: types_only,
      timeout: timeout
    ])
  end
  def search(handle, options) when is_list(options) do
    case :eldap.search(handle, options) do
      {:ok, result} -> 
        result = ElixirLdap.SearchResult.from_record(result)
        {:ok, result.entries |> Enum.map(fn(x) -> ElixirLdap.Entry.from_record(x) end)}
      {_, message} ->
        {:error, message}
    end
  end
end
