angular.module('angular-beacon', []).directive 'beacon', -> {
    restrict: 'E',
    link: (scope, element, attributes) ->
        console.assert attributes.waitfor, "The 'beacon' directive expects the 'waitfor' attribute."
        console.assert attributes.onready, "The 'beacon' directive expects the 'onready' attribute."

        # We will keep checking the DOM until this list is empty.
        missing = (name.trim() for name in attributes.waitfor.split(','))
        cached = []
        elapsedTime = 0

        # DOM checking loop.
        domCheck = () ->
            for selector, i in missing
                found = $(selector)

                if found.length > 0
                    cached[i] = found

                    missing.splice i, 1

            if elapsedTime >= 5000
                console.warn 'Timeout reached. Bailing out.'
            else if missing.length > 0
                elapsedTime += 25

                setTimeout domCheck, 25
            else
                scope[attributes.onready].call null, cached

        do domCheck
}
