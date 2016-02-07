# This is a small set of Classes that will allow fast
# differentiation and calculation of Mathematical functions
#
# TODO: Write a regular text Parser
#

class Item
  constructor: () ->
  evaluate: (vars) -> 0
  differential: (d) -> this
  integral: (d) -> this
  contains: (d) -> false
  isZero: () -> true
  isOne: () -> false
  simplify: () -> this

class Num extends Item
  constructor: (@value) ->
  evaluate: (vars) -> @value
  differential: (d) -> new Num(0)
  integral: (d) -> (new Multiplication(this,new Variable(d))).simplify()
  isZero: () -> @value == 0
  isOne: () -> @value == 1
  simplify: () -> this

class Variable extends Item
  constructor: (@name) ->
  evaluate: (vars) -> vars[@name] | 0
  differential: (d) -> if d == @name then new Num(1) else new Num(0)
  integral: (d) ->
    if d == @name
      new Multiplication(new Num(0.5), new PolynomialOp(this, 2))
    else
      new Multiplication(this, new Variable(d))
  isZero: () -> false
  contains: (d) -> d == @name
  isOne: () -> false
  simplify: () -> this

class Sum extends Item
  constructor: (@items) ->
  evaluate: (vars) ->
    @items.reduce (r,i) ->
      r + i.evaluate(vars)
    , 0
  differential: (d) -> (new Sum(@items.map((x) -> x.differential(d)))).simplify()
  integral: (d) -> (new Sum(@items.map((x) -> x.integral(d)))).simplify()
  isZero: () ->
    @items.reduce (a,x) ->
      a and x.isZero()
    , true
  isOne: () -> false
  contains: (d) ->
    @items.reduce (a,x) ->
      a or x.contains(d)
    , false
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
  integral: (d) ->
    if @firstInput.contains(d) and !@secondInput.contains(d)
      (new Multiplication(@firstInput.integral(d), @secondInput)).simplify()
    else if !@firstInput.contains(d) and @secondInput.contains(d)
      (new Multiplication(@firstInput, @secondInput.integral(d))).simplify()
    else if !@firstInput.contains(d) and !@secondInput.contains(d)
      this
    else
      intOfFirst = @firstInput.integral(d)
      dOfSecond = @firstInput.differential(d)
      left = new Multiplication(intOfFirst, @secondInput)
      rightMul = new Multiplication(intOfFirst, dOfSecond)
      rightInt = rightMul.integral(d)
      right = new Multiplication(new Num(-1), rightInt)
      sum = new Sum([left,right])
      sum.simplify()
  isZero: () -> @firstInput.isZero() or @secondInput.isZero()
  isOne: () -> false
  contains: (d) ->
    @firstInput.contains(d) or @secondInput.contains(d)
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
  contains: (d) -> @var.contains(d)
  differential: (d) ->
    if @pow == 2
      (new Multiplication(new Multiplication(@var.differential(d), new Num(@pow)),@var)).simplify()
    else
      (new Multiplication(new Multiplication(@var.differential(d), new Num(@pow)),new PolynomialOp(@var, @pow - 1))).simplify()
  integral: (d) ->
    (new Multiplication(new VarUnderOne(new Num(@pow + 1)),new PolynomialOp(@var, @pow + 1))).simplify()
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
  integral: (d) ->
    new Log(@var)
  isOne: () -> @var.isOne()
  isZero: () -> false
  contains: (d) -> @var.contains(d)
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
  contains: (d) -> @var.contains(d)
  differential: (d) -> (new Multiplication(new VarUnderOne(@var), @var.differential(d))).simplify()
  integral: (d) ->
    newVar = new Variable(d)
    new Sum([new Multiplication(newVar, this), new Multiplication(new Num(-1), @var.differential(d))])
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
  contains: () -> @var.contains(d)
  differential: (d) -> (new Multiplication(new Multiplication(new Log(@exp), @var.differential(d)),new ExponentialOp(@var,@exp))).simplify()
  integral: (d) -> (new Multiplication(new VarUnderOne(@var.differential(d)), new Multiplication(new VarUnderOne(new Log(@exp)), this))).simplify()
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
  integral: (d) -> new Function("∫" + @name + "d" + d, @vars, @item.integral(d))
  isZero: () -> @item.isZero()
  isOne: () -> @item.isOne()
  contains: (d) -> @item.contains(d)
  simplify: () -> new Function(@name,@vars,@item.simplify())

class Graph
  constructor: (@name, @f) ->
  dimensions: () -> @f.vars.length + 1
  axis: (i) -> if i == 0 then @f.name else @f.vars[i-1]

x = new Variable("x")

y = new Variable("y")

z = new Variable("z")


f = new Sum([new PolynomialOp(x,3),new Multiplication(x,new PolynomialOp(z,2)),new Multiplication(new Num(-3),new PolynomialOp(x,2)),new PolynomialOp(y,2),new Multiplication(2,new PolynomialOp(z,2))])
