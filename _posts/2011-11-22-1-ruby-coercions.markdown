---
layout: post
title: Little known ruby coercions
---

Ruby *loves* coercions. It's because of this fact we can use `array.map(&:method)` one-liners in our code (`to_proc` coercion).

However, sometimes these coercions aren't obvious enough, and you should be
prepared to this.

### Splat operator (\*)

Splat operator, as seen in `method(*args)` uses `to_a` coercion. Most of the time, it's harmless, but if you ever use splat with a single argument, it might lead to weird results.

Example: `method(*1..10)` will expand the range. Some people think it's clever to use it like this `[*1..10]`. It's not. `(1..10).to_a` is so much clearer.

### Array method

There is a method which comes extremely handy when you need to handle either one argument or an argument which is an array of arguments. It's called `Array(arg_or_array_of_args)`. So it will return `[1,2,3]` when invoked as `Array([1,2,3])` and `[1]` when invoked as `Array(1)`.

However, there is a pitfall: it uses `to_a` too.

Example: `Array(1..10)` -- you might have expected [1..10], but you were wrong.

### String #to_a

In ruby 1.8.7 there is a stupid design decision which will cost you
some sleep. "Multiline\nString" `#to_a` method returns _lines_ `["Multiline\n", "String"]`. Combined with previous bug it can lead to very subtle bugs:

{% highlight ruby %}
def method(string_or_array_of_strings)
  Array(string_or_array_of_strings).each do |string|
    # do something useful
  end
end
{% endhighlight %}

Good news is that this behavior was removed in 1.9. Bad news is that 1.8
ruby is still too popular to not think about.
