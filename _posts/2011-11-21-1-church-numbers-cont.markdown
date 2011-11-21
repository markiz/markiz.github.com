---
layout: post
title: Church numerals continued
---

Okay, if you have read the [previous post], you know what Church numerals are and
how to perform multiplication and addition on them. But how do we check numerals for
equality without resorting to integers?

Let's start with a simpler check. `church-zero?` procedure will tell us if given
numeral is zero.

{% highlight scheme %}
(define (church-zero? n)
  (define (falsy-lambda x) #f)
  ((n falsy-lambda) #t))
{% endhighlight %}

If numeral is greater than zero, the procedure returns false for any argument,
otherwise it returns true.

Next we need to figure out a way to find a previous numeral. In order to do this,
we will need pairs. SICP shows in paragraph 2.1.3 that you can simulate `cons`, `car`
and `cdr` using only continuations and lambdas, so it can't be considered cheating.

Basic outline for the `church-prev` is as follows: we create a function `next x`
that takes a pair `(x1,x2)` and returns `(x2, (f x1))`. If we apply it n times using
some pair `(x, x)` as initial value, resulting pair will be `(((k f) x), (m f) x)`, where `k` is `n-1`-th Church numeral and `m` is `n`-th. If we use `zero` as initial `x` and `add-one` as `f`, we will get pure numerals as the result.

Resulting code:

{% highlight scheme %}
(define (church-prev n)
  (define (next f) (lambda (x) (cons (cdr x) (f (cdr x)))))
  (car ((n (next add-one)) (cons zero zero))))
{% endhighlight %}

Equality check using `church-prev` is easy:
{% highlight scheme %}
(define (church-equal? n k)
  (church-zero? ((k church-prev) n)))
{% endhighlight %}

Please, note that our `church-equal?` is actually `church-less-or-equal?` as it
will return true for cases when `k` is greater than `n`.

**Sidenote**: *Can you figure a way to __truly__ check for church equality?*

`church-sub` via `church-prev` is trivial:

{% highlight scheme %}
(define (church-sub n k)
  ((k church-prev) n))
{% endhighlight %}

Now, `church-div` may not be the most efficient solution but at least it works:

{% highlight scheme %}
(define (church-div n k)
  (define (iter result multiplied)
    (if (church-equal? n multiplied)
        result
        (iter (add-one result) (church-add multiplied k))))

  (iter zero zero))
{% endhighlight %}

So we have `+`, `-`, `/`, `*`, whole arithmetics package, using only lambdas.
Now I need a proper excuse to use it somewhere...



_I would also like to thank Druu for his help with tricky `church-prev`_.


[previous post]: /2011/11/20/2-church-numbers.html
