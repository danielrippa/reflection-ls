
  do ->

    { is-infinity, is-nan } = dependency 'unsafe.Number'
    { is-function, function-name } = dependency 'unsafe.Function'

    value-type-tag = (value) ->

      type-tag = typeof! value

      switch type-tag

        | 'Object' =>

          switch value

            | void => 'Undefined'
            | null => 'Null'

            else type-tag

        | 'Number' =>

          match value

            | is-infinity => 'Infinity'
            | is-nan => 'NaN'

            else type-tag

        else type-tag

    #

    object-constructor-name = (value) ->

      { constructor } = value

      return null unless is-function constructor

      constructor |> function-name

    #

    value-type-name = (value) ->

      type-tag = value-type-tag value

      switch type-tag

        | 'Object' =>

          constructor-name = object-constructor-name value

          if constructor-name? then constructor-name else type-tag

        | 'Error' => value.name

        else type-tag

    #

    is-a = (value, descriptor) ->

      return yes if (value-type-name value) is descriptor
      return yes if (value-type-tag  value) is descriptor

      no

    {
      value-type-tag, value-type-name,
      is-a
    }