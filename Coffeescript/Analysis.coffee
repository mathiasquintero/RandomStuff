
# This File contains small functions that will approximate the values
# of differentiation and integration of functions to the x
#
# In case your functions has more than one argument, create an Adapter function
# for the variable you Want to calculate for. e.g:
#
# f = (a,b) -> ...
#
# And you want to differentiate in accordance to b
#
# fDB = (b) ->
#  fun = (x) -> f(0,x)
#  differentiate(fun , b)
#
# Which would equal f'
#
# Since a won't matter after differentiation.
#
#

sizeForDiff = 1e-10

sizeForInt = 1e-5

sum = (a,b,f) -> [a..b].map((x) -> f x).reduce((y,z) -> y + z)

c = (x) -> if x == 0 then 1 else sum(0,x-1,(a) -> c a * c (x-1-a))

sum = (arr) -> arr.reduce( (r,i) -> r + i)

evaluate = (f,x) -> f x

avg = (x) -> x.reduce((r,n) -> r+n) / x.length

range = (a,b,i) -> [0..(b-a)/i].map((x) -> x * i + a)

differentiate = (f,x) -> (evaluate(f,x+sizeForDiff) - evaluate(f,x)) / sizeForDiff

differential = (f) -> ((x) -> differentiate(f,x))

# Warning! Integration won't work well with infinite values.
# Ergo don't feed it the dirac impulse. It will hand over the 0 function

integrate = (f,a,b) ->
  res = 0
  for x in [a..b] by sizeForInt
    res += sizeForInt * avg [evaluate(f,x),evaluate(f,x+sizeForInt)]
  res

convolution = (f,g,t) ->
  h = (x) -> (f x) * (g (t-x))
  integrate(h,Number.MIN_Value,Number.MAX_Value)

convolute = (f,g) -> ((x) -> convolution(f,g,x))

h = (t) -> if t == 0 then Number.POSITIVE_INFINITY else 0
