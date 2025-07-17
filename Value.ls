
  do ->

    { value-type-tag, value-type-name } = dependency 'reflection.TypeName'
    { single-quotes, angle-brackets, curly-brackets, square-brackets, round-brackets, circumfix } = dependency 'unsafe.Circumfix'
    { map-array-items: map, array-size } = dependency 'unsafe.Array'
    { object-member-pairs } = dependency 'unsafe.Object'
    { kebab-case } = dependency 'unsafe.StringCase'
    { function-parameter-names } = dependency 'unsafe.Function'

    pad-with-space = -> circumfix it, [ ' ' ]

    type-as-string = -> angle-brackets " #it "

    members-as-string = -> curly-brackets pad-with-space it * ', '

    member-as-string = (key, value) -> [ key, value ] * ': '

    items-as-string = -> square-brackets it * ', '

    array-as-string = (array) -> map array, value-as-string |> items-as-string

    pair-as-member-string = ([ key, value ]) -> "#{ kebab-case key }: #{ value-as-string value }"

    object-as-string = (object) -> object |> object-member-pairs |> map _ , pair-as-member-string |> members-as-string

    parameters-as-string = (fn) -> function-parameter-names fn => return if (array-size ..) > 1 then (round-brackets .. * ', ') else ''

    function-as-string = (fn) -> "#{ parameters-as-string fn }->"

    any-value-as-string = (value) ->

      switch value-type-tag value.to-string

        | 'Function' => single-quotes value.to-string!

        else "#value"

    #

    value-as-string = (value) ->

      switch value-type-tag value

        | 'Undefined' => 'void'
        | 'Null' => 'null'

        | 'String' => single-quotes value
        | 'Array'  => array-as-string value
        | 'Object' => object-as-string value

        | 'Function' => function-as-string value

        else any-value-as-string value

    #

    typed-array-as-string = (array) -> [ (typed-value-as-string item) for item in array ] |> items-as-string

    pair-as-typed-member-string = ([ key, value ]) -> "#{ kebab-case key }: #{ typed-value-as-string value }"

    typed-object-as-string = (object) ->

      object |> object-member-pairs |> map _ , pair-as-typed-member-string |> members-as-string

    #

    typed-value-as-string = (value) ->

      type-name = value-type-name value

      value-string = switch type-name

        | 'Array'  => typed-array-as-string value
        | 'Object' => typed-object-as-string value

        else value-as-string value

      type-string = type-as-string type-name

      "#type-string #value-string"

    {
      typed-value-as-string, value-as-string
    }