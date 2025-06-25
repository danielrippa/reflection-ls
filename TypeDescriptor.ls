
  do ->

    { is-string, is-array } = dependency 'unsafe.Type'
    { each-array-item, first-middle-and-last-array-items } = dependency 'unsafe.Array'
    { type-error } = dependency 'reflection.TypeError'
    { typed-value-as-string } = dependency 'reflection.Value'

    string-array = (array) -> each-array-item array, (item, index) -> throw type-error "" unless is-string item

    first-middle-and-last = ->

      result = first-middle-and-last-array-items it

      throw type-error "fiurst middle and last salio como el orto" unless result?

      result

    type-descriptor = (descriptor) ->

      descriptor-tokens = match descriptor

        | is-string => descriptor / ' '
        | is-array  => string-array descriptor

        else throw type-error "Type descriptor #{ typed-value-as-string descriptor } must be either string or stringarray"

      { first, middle: type-tokens, last } = first-middle-and-last descriptor-tokens

      descriptor-kind = match first, last

        | '<', '>' => 'type'
        | '{', '}' => 'object'
        | '[', ']' => 'array'
        | '(', ')' => 'function'

        else throw type-error ""

      { type-tokens, descriptor-kind }

    {
      type-descriptor
    }