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

class Num extends Item
  constructor: (@value) ->
  evaluate: (vars) -> @value
  differential: (d) -> new Num(0)
  isZero: () -> @value == 0
  isOne: () -> @value == 1
  simplify: () -> this

class Variable extends Item
  constructor: (@name) ->
  evaluate: (vars) -> vars[@name] | 0
  differential: (d) -> if d == @name then new Num(1) else new Num(0)
  isZero: () -> false
  isOne: () -> false
  simplify: () -> this

class Sum extends Item
  constructor: (@items) ->
  evaluate: (vars) ->
    @items.reduce (r,i) ->
      r + i.evaluate(vars)
    , 0
  differential: (d) -> (new Sum(@items.map((x) -> x.differential(d)))).simplify()
  isZero: () ->
    @items.reduce (a,x) ->
      a and x.isZero()
    , true
  isOne: () -> false
  simplify: () ->
    newItems = @items.map((x) -> x.simplify()).filter((x) -> !x.isZero())
    nums = newItems.filter((x) -> x.constructor == Num)
    otherSums = newItems.filter((x) -> x.constructor == Sum)
    rest = newItems.filter((x) -> x.constructor != Num and x.constructor != Sum)
    newItems = []
    if otherSums.length != 0
      newItems = otherSums.reduce (r,x) ->
        r.concat(x)
      , []
    if nums.length != 0
      num = nums.reduce((a,b) -> a + b)
      newItems.push(num)
    for item in rest
      newItems.push(item)
    if newItems.length == 0
      new Num(0)
    else if newItems.length == 1
      newItems[0]
    else
      new Sum(newItems)

class Multiplication extends Item
  constructor: (@firstInput, @secondInput) ->
  evaluate: (vars) -> @firstInput.evaluate(vars) * @secondInput.evaluate(vars)
  differential: (d) -> (new Sum([new Multiplication(@firstInput.differential(d), @secondInput), new Multiplication(@firstInput, @secondInput.differential(d))])).simplify()
  isZero: () -> @firstInput.isZero() or @secondInput.isZero()
  isOne: () -> false
  simplify: () ->
    first = @firstInput.simplify()
    second = @secondInput.simplify()
    if first.isZero() or second.isZero()
      new Num(0)
    else if first.isOne()
      second
    else if second.isOne()
      first
    else if first.constructor == Num and second.constructor == Num
      new Num(first.value * second.value)
    else
      new Multiplication(first,second)

class PolynomialOp extends Item
  constructor: (@var, @pow) ->
  evaluate: (vars) -> @var.evaluate(vars) ** pow
  isZero: () -> @var.isZero()
  isOne: () -> @pow == 0
  differential: (d) ->
    if @pow == 2
      (new Multiplication(new Multiplication(@var.differential(d), new Num(@pow)),@var)).simplify()
    else
      (new Multiplication(new Multiplication(@var.differential(d), new Num(@pow)),new PolynomialOp(@var, @pow - 1))).simplify()
  simplify: () ->
    if @pow == 1
      @var
    else
      this

class VarUnderOne extends Item
  constructor: (@var) ->
  evaluate: (vars) -> 1 / @var.evaluate(vars)
  differential: (d) ->
    (new Multiplication(new Multiplication(new Num(-1), @var.differential(d)), new PolynomialOp(@var, new Num(-2)))).simplify()
  isOne: () -> @var.isOne()
  isZero: () -> false
  simplify: () ->
    if @var.constructor == Num
      new Num(1/@var.value)
    else
      this

class Log extends Item
  constructor: (@var) ->
  evaluate: (vars) -> Math.log(@var.evaluate(vars))
  isOne: () -> @var.constructor == Num and @var.value == Math.E
  isZero: () -> @var.isOne()
  differential: (d) -> (new Multiplication(new VarUnderOne(@var), @var.differential(d))).simplify()
  simplify: () ->
    newVar = @var.simplify()
    if newVar.constructor == Num
      new Num(Math.log(newVar.value))
    else
      new Log(newVar)

class ExponentialOp extends Item
  constructor: (@var, @exp) ->
  evaluate: (vars) -> @exp.evaluate(vars) ** @var.evaluate(vars)
  isZero: () -> @exp.isZero()
  isOne: () -> @exp.isOne() or @var.isZero()
  differential: (d) -> (new Multiplication(new Multiplication(new Log(@exp), @var.differential(d)),new ExponentialOp(@var,@exp))).simplify()
  simplify: () ->
    newVar = @var.simplify()
    newExp = @exp.simplify()
    if newVar.constructor == Num and newExp.constructor == Num
      new Num(newExp.value ** newVar)
    else
      new ExponentialOp(newVar, newExp)

class Function extends Item
  constructor: (@name, @vars, @item) ->
  evaluate: (vars) -> @item.evaluate(vars)
  differential: (d) -> new Function(@name + "'",@vars,@item.differential(d))
  isZero: () -> @item.isZero()
  isOne: () -> @item.isOne()
  simplify: () -> new Function(@name,@vars,@item.simplify())

class Graph
  constructor: (@name, @f) ->
  dimensions: () -> @f.vars.length + 1
  axis: (i) -> if i == 0 then @f.name else @f.vars[i-1]


x = new Variable("x")

g = new Function("f", ["x"], new PolynomialOp(x,2))

f = new Function("f", ["x"], new Multiplication(new ExponentialOp(x,new Num(Math.E)), x))

y = new Multiplication(x,new Log(x))

h = y.differential("x")

fd = f.differential("d")
