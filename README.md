angular-beacon
==============

![Lighthouse](https://raw.github.com/develersrl/angular-beacon/master/lighthouse.png)

In Angular there's no way to know when it has finished *rendering* items on the screen. Controllers
emit `$viewContentLoaded` and directives call `postLink()` when Angular has finished *cloning* the
template, but that doesn't mean that DOM nodes were created yet, not that the page has been fully
rendered.

Wouldn't it be nice to be told when the page has been fully rendered? Unfortunately, Angular doesn't
yet provide us a way to know that.

Some people suggest to wrap your DOM-interacting code inside a couple of nested `$timeout` calls.
Others suggest to check the `$digest` loop and do your stuff when the queue is empty. The former
solution doesn't always work and the latter may suffer from starvation in case you have a constant
stream of events coming from another source.

We know this is not the Angular way of doing things but, sometimes, it's unavoidable (additionally,
we had to go this route in a couple of projects already).

Angular-Beacon repeatedly checks the DOM until all the elements you need become available (it will
try for up to five seconds), then it invokes a callback function (which must have been defined in
your scope) in which you can do all the DOM manipulation you want.

# How to use

Add `angular-beacon` to the list of dependencies in your Angular.JS application:

```javascript
    angular.module('myapp', [
        'ngRoute',
        // ...
        'angular-beacon'
    ]);
```

Create a callback function in your controller's or directive's scope. As a bonus, all elements found
are passed to your callback within an object (see below for details).

```javascript
    angular.module('myapp').controller('MyController', function ($scope) {
        scope.myCallback = function(cache) {
            console.log('DOM Ready!');
        };
    });
```

In your view or template, add a reference to the `beacon` directive, towards the
end of it:

```html
    <div class="my-panel">
        ...
    </div>
    <button>Push button</button>
    <beacon waitfor=".my-panel, button" onready="myCallback"></beacon>
```

`myCallback` will be called as soon as `.my-panel` and `button` appear on the page (as DOM nodes at
least).

That is: each `beacon` directive instances expects two attributes:

* `onready` is the name of callback function defined inside the current Angular.JS scope which will
  be called when the DOM is ready.
* `waitfor`: A comma-separated list of CSS selectors, the same you would use with jQuery. The
  selector is normalized, replacing all non-alphanumeric characters with underscores and used as the
  property name holding the cached value in the cache object passed to your callback.
