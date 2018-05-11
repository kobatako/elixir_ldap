defmodule ElixirLdap.Search do
  @moduledoc """
  Documentation for ElixirLdap.Search
  """
  import ElixirLdap.Collation
  collation_define

  defp is_collation_rule?(collation_rule) do
    Enum.any?(ElixirLdap.Collation.collation_rules, fn(rule) -> rule == collation_rule end)
  end

  defp to_listchar_atom_key(dn_list) do
    Enum.map_join(dn_list, ",", fn({key, value}) -> to_string(key) <> "=" <> value end)
  end

  defp search_scope(scope) when is_atom(scope) do
    case scope do
      # Search baseobject only.
      :base_object -> 
        :eldap.baseObject()
      # Search the specified level only, i.e. do not recurse
      :single_level -> 
        :eldap.singleLevel()
      # Search the entire subtree.
      :whole_subtree -> 
        :eldap.wholeSubtree()
    end
  end

  defp search_scope(scope) do
    scope
  end

  defp deref_aliases(deref) when is_atom(deref) do
    case deref do
      # Do not refer to alias entries
      :never_deref_aliases ->
        :eldap.neverDerefAliases()
      # If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      :deref_in_searching ->
        :eldap.derefInSearching()
      # If the base DN of the search is an alias entry no search is performed.
      # If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      :deref_finding_baes_obj ->
        :eldap.derefFindingBaseObj()
      # Always refer to alias entries
      :deref_always ->
        :eldap.derefAlways()
    end
  end

  defp deref_aliases(deref) do
    deref
  end

  @doc """
  Search base dn all entry.
  Search by base dn set in config file.

  ## Example

      ElixirLdap.Search.search_base_all(handle)

  """
  def search_base_all(handle) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base_all(handle, base)
  end

  @doc """
  Search base dn all entry.  
  Use the base DN of the argument.
  Argument base dn is list.

  ## Example

      ElixirLdap.Search.search_base_all(handle, "ou=Server,dc=corporation,dc=home,dc=local")

  """
  def search_base_all(handle, base) when is_list(base) do
    if is_tuple(List.first(base)) do
      search_base_all(handle, to_listchar_atom_key(base))
    else
      search_base(handle, base, [filter: :present, type: "objectClass"])
    end
  end

  @doc """
  search base dn all entry.
  DN is argument base search and deref aliase is argument.

  ## Example

      ElixirLdap.Search.search_base_all(handle, "ou=Server,dc=corporation,dc=home,dc=local", :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base_all(handle, base, def) when is_atom(def) do
    search_base(handle, base, [filter: :present, type: "objectClass"], def)
  end

  @doc """
  Search base dn all entry.
  Use the base DN of the argument.

  ## Example

      ElixirLdap.Search.search_base_all(handle, 'ou=Server,dc=corporation,dc=home,dc=local')

  """
  def search_base_all(handle, base) do
    search_base(handle, base, [filter: :present, type: "objectClass"])
  end

  @doc """
  Search single level all entry.
  Use the base DN of config file.

  ## Example

      ElixirLdap.Search.search_single_level_all(handle)

  """
  def search_single_level_all(handle) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level_all(handle, base)
  end

  @doc """
  Search single level all entry.
  Use the base DN of argument and list.

  ## Example

      ElixirLdap.Search.search_single_level_all(handle, [ou: "People", dc: "corporation", dc: "home" ,dc: "local"])
			ElixirLdap.Search.search_single_level_all(handle, [{:ou, "People"}, {:dc, "corporation"}, {:dc, "home"}, {:dc, "local"}])

  """
  def search_single_level_all(handle, base) when is_list(base) do
    if is_tuple(List.first(base)) do
      search_single_level_all(handle, to_listchar_atom_key(base))
    else
      search_single_level(handle, base, [filter: :present, type: "objectClass"])
    end
  end

  @doc """
  Search single level all entry.
  Use the base DN of argument.

  ## Example

      ElixirLdap.Search.search_single_level_all(handle, "ou=Server,dc=corporation,dc=home,dc=local")

  """
  def search_single_level_all(handle, base) do
    search_single_level(handle, base, [filter: :present, type: "objectClass"])
  end

  @doc """
  Search single level all entry.
  Use the base DN of argument.
	deref aliases is argument

  ## Example

      ElixirLdap.Search.search_single_level_all(handle, "ou=Server,dc=corporation,dc=home,dc=local", :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level_all(handle, base, def) when is_atom(def) do
    search_single_level(handle, base, [filter: :present, type: "objectClass"], def)
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
  def search_subtree_all(handle, base, def) do
    search_subtree(handle, base, [filter: :present, type: "objectClass"], def)
  end

  @doc """
  search base dn entry.
  Filter will search for equal.

  ## Exsample

      ElixirLdap.Search.search_base(handle, [filter: :equal, field: 'ou', name: 'Server'])
      ElixirLdap.Search.search_base(handle, [filter: :present, type: 'ou'])
      ElixirLdap.Search.search_base(handle, [filter: :greater, type: 'age', value: "22")
      ElixirLdap.Search.search_base(handle, [filter: :less, type: 'age', value: "22")

  """
  def search_base(handle, options) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_base(handle, base, options)
  end

  def search_base(handle, base, options) do
    search_base(handle, base, options, :deref_always)
  end

  @doc """
  search base dn entry.
  Filter will search for equal.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_base(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :equal, field: 'ou', name: 'Server'], def)


  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base(handle, base, [filter: :equal, field: field, name: name], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, equality_match(field, name), def, false, search_timeout)
  end

  @doc """
  search base dn entry.
  Filter will search on attribute type presence.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_base(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :present, type: 'ou'], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base(handle, base, [filter: :present, type: type], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, present(type), def, false, search_timeout)
  end

  @doc """
  search base dn entry.
  Filter will search greater number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_base(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :greater, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base(handle, base, [filter: :greater, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, greater_or_equal(type, value), def, false, search_timeout)
  end

  @doc """
  search base dn entry.
  Filter will search less number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_base(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :less, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base(handle, base, [filter: :less, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, less_or_equal(type, value), def, false, search_timeout)
  end

  @doc """
  search single level entry.
  Filter approximation match filter.

  ## Example

      ElixirLdap.Search.search_base(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :approx, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_base(handle, base, [filter: :approx, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, approx_match(type, value), def, false, search_timeout)
  end

  def search_base(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, extensible_match(value, type, rule, dn_attribute), def, false, search_timeout)
  end

  def search_base(handle, base, [filter: :strings, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :base_object, substrings(type, value), def, false, search_timeout)
  end

  @doc """
  search single level entry.
  Filter will search for equal.

  ## Exsample

      ElixirLdap.Search.search_single_level(handle, [filter: :equal, field: 'ou', name: 'Server'])
      ElixirLdap.Search.search_single_level(handle, [filter: :present, type: 'ou'])
      ElixirLdap.Search.search_single_level(handle, [filter: :greater, type: 'age', value: "22")
      ElixirLdap.Search.search_single_level(handle, [filter: :less, type: 'age', value: "22")
      ElixirLdap.Search.search_single_level(handle, [filter: :approx, type: 'age', value: "22"])

  """
  def search_single_level(handle, options) when is_list(options) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_single_level(handle, base, options)
  end

  def search_single_level(handle, base, options) do
    search_single_level(handle, base, options, :deref_always)
  end

  @doc """
  search single level entry.
  Filter will search for equal.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_single_level(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :equal, field: 'ou', name: 'Server'], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level(handle, base, [filter: :equal, field: field, name: name], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, equality_match(field, name), def, false, search_timeout)
  end

  @doc """
  search single level entry.
  Filter will search on attribute type presence.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_single_level(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :present, type: 'ou'], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level(handle, base, [filter: :present, type: type], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, present(type), def, false, search_timeout)
  end

  @doc """
  search single level entry.
  Filter will search greater number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_single_level(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :greater, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level(handle, base, [filter: :greater, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, greater_or_equal(type, value), def, false, search_timeout)
  end


  @doc """
  search single level entry.
  Filter will search less number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_single_level(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :less, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level(handle, base, [filter: :less, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, less_or_equal(type, value), def, false, search_timeout)
  end

  @doc """
  search single level entry.
  Filter approximation match filter.

  ## Example

      ElixirLdap.Search.search_single_level(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :approx, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_single_level(handle, base, [filter: :approx, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, approx_match(type, value), def, false, search_timeout)
  end

  def search_single_level(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, extensible_match(value, type, rule, dn_attribute), def, false, search_timeout)
  end

  def search_single_level(handle, base, [filter: :strings, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :single_level, substrings(type, value), def, false, search_timeout)
  end

  @doc """
  search sub tree entry.
  Filter will search for equal.

  ## Exsample

      ElixirLdap.Search.search_subtree(handle, [filter: :equal, field: 'ou', name: 'Server'])
      ElixirLdap.Search.search_subtree(handle, [filter: :present, type: 'ou'])
      ElixirLdap.Search.search_subtree(handle, [filter: :greater, type: 'age', value: "22"])
      ElixirLdap.Search.search_subtree(handle, [filter: :less, type: 'age', value: "22"])

  """
  def search_subtree(handle, options) do
    base = Application.get_env(:elixir_ldap, :settings)
          |> Keyword.get(:base)
    search_subtree(handle, base, options)
  end

  def search_subtree(handle, base, options) do
    search_subtree(handle, base, options, :deref_always)
  end

  @doc """
  search sub tree entry.
  Filter will search for equal.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_subtree(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :equal, field: 'ou', name: 'Server'], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_subtree(handle, base, [filter: :equal, field: field, name: name], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, equality_match(field, name), def, false, search_timeout)
  end

  @doc """
  search sub tree entry.
  Filter will search on attribute type presence.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_subtree(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :present, type: 'ou'], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_subtree(handle, base, [filter: :present, type: type], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, present(type), def, false, search_timeout)
  end

  @doc """
  search sub tree entry.
  Filter will search greater number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_subtree(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :greater, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_subtree(handle, base, [filter: :greater, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, greater_or_equal(type, value), def, false, search_timeout)
  end

  @doc """
  search sub tree entry.
  Filter will search less number.
  Use the base DN of the argument.

  ## Exsample

      ElixirLdap.Search.search_subtree(handle, 'ou=People,dc=corporation,dc=home,dc=local', [filter: :greater, type: 'age', value: "22"], :deref_always)

  the argument def are:

      * never_deref_aliases    - Do not refer to alias entries
      * deref_in_searching     - If the base DN of the search is an alias entry, it refers to it, ignoring the alias entry under it
      * deref_finding_baes_obj - If the base DN of the search is an alias entry no search is performed. If the base DN is not an alias entry, a search is performed, and furthermore, an alias entry under the base DN is referred to
      * deref_always           - Always refer to alias entries

  """
  def search_subtree(handle, base, [filter: :less, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, less_or_equal(type, value), def, false, search_timeout)
  end

  def search_subtree(handle, base, [filter: :approx, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, approx_match(type, value), def, false, search_timeout)
  end

  def search_subtree(handle, base, [filter: :extensible, value: value, type: type, rule: rule, dn_attributes: dn_attribute], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, extensible_match(value, type, rule, dn_attribute), def, false, search_timeout)
  end

  def search_subtree(handle, base, [filter: :strings, type: type, value: value], def) do
    search_timeout = Application.get_env(:elixir_ldap, :settings)
                    |> Keyword.get(:search_time) || 0
    search(handle, base, :whole_subtree, substrings(type, value), def, false, search_timeout)
  end

  @doc """
  search filter equality match

  ## Exsample

      ElixirLdap.Serach.equality_match("cn", "User01")

  """
  def equality_match(field, name) do
    :eldap.equalityMatch(to_charlist(field), to_charlist(name))
  end

  @doc """
  search filter attribute

  ## Exsample

      ElixirLdap.Serach.present("telephoneNumber")

  """
  def present(type) do
    :eldap.present(to_charlist(type))
  end

  @doc """
  search filter greater number

  ## Exsample

      ElixirLdap.Serach.greater_or_equal("age", "22")

  """
  def greater_or_equal(type, value) do
    :eldap.greaterOrEqual(to_charlist(type), to_charlist(value))
  end

  @doc """
  search filter less number

  ## Exsample

      ElixirLdap.Serach.less_or_equal("age", "22")

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
  and search filter
  """
  def with_and(filters) do
    :eldap.and(filters)
  end

  @doc """
  or search filter
  """
  def with_or(filters) do
    :eldap.or(filters)
  end

  @doc """
  not search filter
  """
  def with_not(filters) do
    :eldap.not(filters)
  end

  @doc """
  this function actually search

  """
  def search(handle, base, scope, filter, deref, types_only \\ false, timeout \\ 0)
  def search(handle, base, scope, filter, deref, types_only, timeout) when is_list(base) do
    if is_tuple(List.first(base)) do
        search(handle, [
          base: to_charlist(to_listchar_atom_key(base)),
          scope: search_scope(scope),
          filter: filter,
          deref: deref_aliases(deref),
          types_only: types_only,
          timeout: timeout
        ])
      else
        search(handle, [
          base: to_charlist(base),
          scope: search_scope(scope),
          filter: filter,
          deref: deref_aliases(deref),
          types_only: types_only,
          timeout: timeout
        ])
    end
  end

  def search(handle, base, scope, filter, deref, types_only, timeout) do
    search(handle, [
      base: to_charlist(base),
      scope: search_scope(scope),
      filter: filter,
      deref: deref_aliases(deref),
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

