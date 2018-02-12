# ElixirLdap

This module LDAP Client for Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_ldap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_ldap, "~> 0.1.0"}
  ]
end
```

## Online documentation

[Hex docuemtn](https://hexdocs.pm/elixir_ldap/api-reference.html)

## Usage

```elixir
handle = ElixirLdap.connect("192.168.11.101")
#=> #PID<0.212.0>
ElixirLdap.Search.search_single_level_all(handle)
#=> {:ok,
#=>  [%ElixirLdap.Entry{attributes: [{'objectClass', ['dcObject', 'organization']},
#=>     {'dc', ['corporation']}, {'o', ['Corporation Inc']}],
#=>    object_name: 'dc=corporation,dc=home,dc=local'}]}

ElixirLdap.Search.search_subtree(handle, [filter: :equal, field: "cn", name: "user01"])
#=> {:ok,
#=>  [%ElixirLdap.Entry{attributes: [{'objectClass', ['person']},
#=>     {'sn', ['Valentine']}, {'telephoneNumber', ['041 000 000']},
#=>     {'cn', ['user01']}],
#=>    object_name: 'cn=user01,ou=People,dc=corporation,dc=home,dc=local'}]}
```

