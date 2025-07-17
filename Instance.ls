
  do ->

    { camel-case, capital-case } = dependency 'unsafe.StringCase'
    { type } = dependency 'reflection.Type'

    create-instance = (member-descriptors) ->

      type '< Object >' member-descriptors

      notifiers = {} ; instance = {}

      for name, member-descriptor of member-descriptors

        { member, getter, setter, notifier } = member-descriptor

        match member-descriptor

          | (.notifier isnt void) =>

            notification-types = notifier
            type '[ *:String ]' notification-types

            do ->

              subscriptions = {}

              for type in types

                event-name = camel-case type
                subscriptions[event-name] = {}

              instance[name] := (notification-names, notification) ->

              for name in notification-names

                subs = subscriptions[name]

                if subs?

                  for id, sub of subs

                    if sub.enabled

                      sub.handler notification

              for type in types

                event-name = camel-case type

                do ->

                  instance[event] = (handler) ->

                    id = "sub#{new Date!get-time!}#{Math.random!}"

                    enabled = yes

                    subscriptions[event-name][id] = { handler, enabled: -> enabled }

                    #

                    unsubscribe: !-> delete subscriptions[event-name][id]
                    enable: !-> enabled := yes
                    disable: !-> enabled := no

          | (.member isnt void) =>

            instance[name] := member

          | (.getter isnt void) or (.setter isnt void) =>

            if getter isnt void

              type '< Function >' getter

              instance[name] := -> getter instance

            if setter isnt void

              type '< Function >' setter

              do ->

                setter-name = "set#{ capital-case name }"

                instance[setter-name] := (value) -> setter.call instance, value

      instance

    {
      create-instance
    }