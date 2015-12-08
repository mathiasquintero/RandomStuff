
var upArrow = function(arrows, a, b) {
  if (arrows < 1) throw "Your Argument is Invalid";
  if (arrows === 1) return Math.pow(a,b);
  var result = a;
  for (var i = 1; i < b; i++) {
    result = upArrow(arrows-1,a,result);
  }
  return result;
};
