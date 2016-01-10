# This is a small set of Classes that will allow fast
# differentiation and calculation of Mathematical functions
#
# TODO: Write a regular text Parser
#

class Item
  constructor: () ->
  evaluate: (vars) -> 0
  differential: (d) -> this
  isZero: () -> true
  isOne: () -> false
  simplify: () -> this

class Number extends Item
  constructor: (@value) ->
  evaluate: (vars) -> value
  differential: (d) -> new Number(0)
  isZero: () -> value == 0
  isOne: () -> value == 1
  simplify: () -> this

class Variable extends Item
  constructor: (@name) ->
  evaluate: (vars) -> vars[name] | 0
  differential: (d) -> if d == name then new Number(1) else new Number(0)
  isZero: () -> false
  isOne: () -> false
  simplify: () -> this

class Sum extends Item
  constructor: (@items) ->
  evaluate: (vars) -> items.reduce((r,i) -> r + i.evaluate(vars))
  differential: (d) -> (new Sum(items.map((x) -> x.differential(d)))).simplify()
  isZero: () -> items.reduce(true, (a,x) -> a and x.isZero())
  isOne: () -> false
  simplify: () ->
    newItems = items.map((x) -> x.simplify()).filter((x) -> x != null and !x.isZero())
    numbers = newItems.filter((x) -> x.constructor == Number)
    otherSums = newItems.filter((x) -> x.constructor == Sum)
    rest = newItems.filter((x) -> x.constructor != Number and x.constructor != Sum)
    newItems = otherSums.reduce([], (r,x) -> r.concat(x))
    number = numbers.reduce((a,b) -> a + b)
    newItems.push(number)
    for item in rest
      newItems.push(item)
    if newItems.length == 0
      new Number(0)
    else if newItems.length == 1
      newItems[0]
    else
      new Sum(newItems)

class Multiplication extends Item
  constructor: (@firstInput, @secondInput) ->
  evaluate: (vars) -> firstInput.evaluate(vars) * secondInput.evaluate(vars)
  differential: (d) -> (new Sum([new Multiplication(firstInput.differential(d), secondInput), new Multiplication(firstInput, secondInput.differential(d))])).simplify()
  isZero: () -> firstInput.isZero() or secondInput.isZero()
  isOne: () -> false
  simplify: () ->
    first = firstInput.simplify()
    second = secondInput.simplify()
    if first.isZero() or second.isZero()
      new Number(0)
    else if first.isOne()
      second
    else if second.isOne()
      first
    else
      new Multiplication(first,second)

class PolynomialOp extends Item
  constructor: (@var, @pow) ->
  evaluation: (vars) -> this.var.evaluate(vars) ** pow
  isZero: () -> this.var.isZero()
  isOne: () -> pow == 0
  differential: (d) -> (new Multiplication(new Multiplication(this.var.differential(d), pow),new PolynomialOp(this.var, pow - 1))).simplify()
  simplify: () ->
    if pow == 0
      new Number(1)
    else
      this

class VarUnderOne extends item
  constructor: (@var) ->
  evaluation: (vars) -> 1 / this.var.evaluate(vars)
  differential: (d) -> (new Multiplication(new Multiplication(new Item(-1), this.var.differential(d)),new PolynomialOp(this.var, new Number(-2)))).simplify()
  isOne() -> this.var.isOne()
  isZero() -> false
  simplify: () ->
    if this.var.constructor == Number
      new Number(1/this.var.value)
    else
      this

class Log extends Item
  constructor: (@var) ->
  evaluation: (vars) -> Math.log(this.var.evaluate(vars))
  isOne: () -> this.var.constructor == Number and this.var.value == Math.E
  isZero: () -> this.var.isOne()
  differential: (d) -> (new Multiplication(new VarUnderOne(this.var), this.var.differential(d))).simplify()
  simplify: () -> this

class ExponentialOp extends Item ->
  constructor: (@var, @exp) ->
  evaluation: (vars) -> (exp ** this.var.evaluate(vars))
  isZero: () -> exp.isZero()
  isOne: () -> exp.isOne() or this.var.isZero()

class Function extends Item
  constructor: (@name, @vars, @item) ->
  evaluate: (vars) -> item.evaluate(vars)
  differential: (d) -> new Function(name + "'",vars,item.differential(d))

class Graph
  constructor: (@name, @f) ->
  dimensions: () -> f.vars.length + 1
  axis: (i) -> if i == 0 then f.name else f.vars[i-1]
