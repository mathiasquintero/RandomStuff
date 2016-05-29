var fac = function(n) {
  if (n === 0) return 1;
  return n * fac(n-1);
};

var smallF = function(x, lambda) {
  var e = Math.E;
  var a = Math.pow(e, -lambda), b = Math.pow(lambda, x), c = fac(x);
  return a * b / c;
};

var bigF = function(n, lambda) {
  if (n === 0) return smallF(n, lambda);
  return smallF(n, lambda) + bigF(n-1, lambda);
};

var calc = function(lambda) {
  var n = 1;
  while (bigF(n, lambda) < 0.5) n++;
  return n;
};

var result = calc(500);
console.log(result);
