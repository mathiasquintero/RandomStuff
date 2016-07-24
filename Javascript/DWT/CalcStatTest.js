var mean = function(array) {
  return array.reduce(function(r, i) {
    return r + i;
  }, 0) / array.length;
};

var varSquared = function(array) {
  var me = mean(array);
  return array.reduce(function(r, i) {
    return r + Math.pow(i - me, 2);
  }, 0) / (array.length - 1);
};

var t = function(x, y) {
  var a = Math.sqrt((x.length + y.length - 2)/(1/x.length + 1/y.length));
  var b = mean(x) - mean(y);
  var c = Math.sqrt((x.length - 1) * varSquared(x) + (y.length - 1) * varSquared(y));
  return a * b / c;
};

var X = [-1, 0, 1, 1, 2, -1, 4, 3, -1, -2, 1, 3, 2, -1, 4, 1];

var Y = [-4, -3, -2, 0, -2, -2, 3, 0, 0, -3, -3, 0, -1, -1, 0, 2];

console.log("XMean=", mean(X));

console.log("YMean=", mean(Y));

console.log("S_X^2*15=", (X.length-1) * varSquared(X));

console.log("S_Y^2*15=", (Y.length-1) * varSquared(Y));

console.log("T:", t(X, Y));
