
  do ->

    to-string = (value) -> {} |> (.to-string) |> (.call value)

    get-type-tag = (value) -> value |> to-string |> (.slice 8, -1)

    #

    get-type-name = (value) ->

      tag = get-type-tag value

      switch tag

        | 'Object' =>

          switch value

            | void => 'void'
            | null => 'null'

            else tag

        | 'Number' =>

          match value

            | isNaN => 'NaN'
            | isInfinity => 'Infinity'

            else tag

        else tag

    #

    # https://developer.mozilla.org/en-US/docs/Glossary/Primitive

    is-primitive = (value) -> if value? then (typeof value) isnt 'object' else yes

    is-object = (value) -> if value? then (typeof value) is 'object' else no

    #

    is-infinity = (value) ->

      switch value
        | Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY => yes
        else no

    #

    constructor-candidate = (value) ->

      candidate = null

      if is-primitive value

        candidate = switch get-type-name value

          | 'void' => void
          | 'null' => null

          | 'String' => String
          | 'Number' => Number
          | 'BigInt' => BigInt
          | 'Boolean' => Boolean
          | 'Symbol' => Symbol

      candidate

    #

    reflection-of = (value) ->

      get-constructor: ->

        constructor = null
        try { constructor } = value
        constructor

      has-constructor: -> @get-constructor!?

      constructor-is: (constructor) -> (@get-constructor!) is constructor

      get-constructor-name: ->

        name = null

        constructor = @get-constructor!

        if constructor?

          string = constructor.to-string!

          name = if string |> (.index-of '(') |> (== 9)
            ''
          else
            string |> (.slice (it.index-of ' ') + 1, it.index-of '(')

        name

      constructor-name-is: -> @get-constructor-name! is it

      has-anonymous-constructor: -> @get-constructor-name! is ''

      matches: (constructor) ->

        if is-primitive value

          (constructor-candidate value) is constructor

        else

          @instance-of constructor

      get-type-tag: -> get-type-tag value

      type-tag-is: (tag) -> @get-type-tag! is tag

      instance-of: (ancestor) -> value instanceof ancestor

      is-object: -> is-object value

      is-plain-object: -> (@is-object!) and (@get-constructor-name! is 'Object') and (@get-type-tag! is 'Object')

    {
      get-type-tag, get-type-name,
      reflection-of
    }