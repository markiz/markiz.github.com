---
layout: post
title: Church numerals
---

It is often interesting and useful to redesign the basics using some predefined set of primitives.

For example, prove every mathematical fact using [ZFC axioms].
Or define arithmetics in terms of [cardinal numbers].

As I've recently started achieving satori with [SICP], I've found an interesting mention of [Church numerals] in ex. 2.6.

Here is definition of Church numerals in scheme:

{% highlight scheme %}
(define zero (lambda (f) (lambda (x) x)))
(define (add-one n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
{% endhighlight %}

It's not immediately obvious, but `i`-th Church Numeral applies given function to
the argument exactly `i` times.

Example:

{% highlight scheme %}
(define one (add-one zero))
(define two (add-one one))
(define (inc x) (+ x 1))
((two inc) 4) ;; 6
{% endhighlight %}

Addition and multiplication on Church numerals are not too difficult:

{% highlight scheme %}
(define (church-add n k)
  (lambda (f) (lambda (x) ((n f) ((k f) x)))))
(define (church-mul n k)
  (lambda (f) (lambda (x) ((n (k f)) x))))
{% endhighlight %}

However, I can't figure a way to define subtraction and division programmatically.
The best idea I could come up with is to store numerals in form of pairs `(n, l)`,
with `n` standing for "absolute value of the numeral" and `l` standing for "lambda corresponding to the numeral". Then you perform subtraction and division on integer
numbers and build resulting church numeral from the resulting integer.

You could also avoid having support structures using a simple `church-abs` procedure:

{% highlight scheme %}
(define (church-abs n) ((n inc) 0))
{% endhighlight %}

But it feels like cheating to me. If you have any ideas on how to properly do
subtraction and division, your comments are very welcome.

[ZFC axioms]: http://en.wikipedia.org/wiki/Zermelo%E2%80%93Fraenkel_set_theory#The_axioms
[cardinal numbers]: http://en.wikipedia.org/wiki/Cardinal_number#Cardinal_arithmetic
[SICP]: http://mitpress.mit.edu/sicp/
[Church numerals]: http://en.wikipedia.org/wiki/Church_encoding#Church_numerals
