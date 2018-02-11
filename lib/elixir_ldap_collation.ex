defmodule ElixirLdap.Collation do
  @boolean_match "booleanMatch"
  @case_exact_match "caseExactMatch"
  @case_ignore_match "caseIgnoreMatch"
  @distinguished_name_match "distinguishedNameMatch"
  @integer_match "integerMatch"
  @numeric_string_match "numericStringMatch"
  @octet_string_match "octetStringMatch"
  @object_identifer_match "objectIdentiferMatch"
  @case_exact_ordering_match "caseExactOrderingMatch"
  @integer_ordering_match "integerOrderingMatch"
  @numeric_string_ordering_match "numericStringOrderingMatch"
  @case_exact_substrings_match "caseExactSubstringsMatch"
  @case_ignore_substrings_match "caseIgnoreSubstringsMatch"
  @numeric_string_substrings_match "numericStringSubstringsMatch"

  @collation_rules [
    @boolean_match,
    @case_exact_match,
    @case_ignore_match,
    @distinguished_name_match,
    @integer_match,
    @numeric_string_match,
    @octet_string_match,
    @object_identifer_match,
    @case_exact_ordering_match,
    @integer_ordering_match,
    @numeric_string_ordering_match,
    @case_exact_substrings_match,
    @case_ignore_substrings_match,
    @numeric_string_substrings_match
  ]

  defmacro collation_define do
    for rule <- @collation_rules do
      quote do
        def unquote(:"#{Macro.underscore(rule)}")() do
          unquote(rule)
        end
      end
    end
  end

  def collation_rules do
    @collation_rules
  end
end
