function sort(array) {
  var buckets = [], i = 0;
  var max = array.reduce(function(a,b) { return Math.max(a,b); });
  for (var pow = 10; pow < max * 10; pow *= 10) {
    for (i = 0; i < array.length; i++) {
      var index = Math.floor((array[i] % pow) / (pow / 10));
      if (!buckets[index]) buckets[index] = [];
      buckets[index].push(array[i]);
    }
    var count = 0;
    for (i = 0; i < buckets.length; i++) {
      if (!buckets[i]) continue;
      for (var j = 0; j < buckets[i].length; j++) {
        array[count] = buckets[i][j];
        count++;
      }
      buckets[i] = [];
    }
  }
}

module.exports = sort;
