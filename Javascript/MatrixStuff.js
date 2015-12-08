function createMatrix(width, height) {
  var array = new Array(width);
  for (var i = 0; i < array.length; i++) {
    array[i] = new Array(height);
  }
  return array;
}

function checkMatrixSyntax(matrix) {
  var length = matrix.lenght !== 0 ? matrix[0].length : 0;
  for (var i = 0; i < matrix.length; i++) {
    if (matrix[i].length != length) return false;
  }
  return true;
}

function canPower(a) {
  return checkMatrixSyntax(a) && a.length === a[0].length;
}

function canMultiply(a, b) {
  if (!(checkMatrixSyntax(a) && checkMatrixSyntax(b))) {
    return false;
  }
  if (a.length === 0) return false;
  return a[0].length === b.length;
}

function multiplyMatrix(a, b) {
  if (!canMultiply(a, b)) throw "Dafuq, dude? Seriously?";
  var result = createMatrix(b[0].length, a.length);
  for (var i = 0; i < result.length; i++) {
    for (var j = 0; j < result[i].length; j++) {
      result[i][j] = 0;
      for (var k = 0; k < a[0].length; k++) {
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return result;
}

function powMatrix(a, n) {
  if (!canPower(a)) throw "Really!!!!";
  var result = createMatrix(a.length, a.length);
  for (var i = 0; i < a.length; i++) {
    for (var j = 0; j < a[0].length; j++) {
      result[i][j] = i === j ? 1 : 0;
    }
  }
  for (var k = 0; k < n; k++) {
    result = multiplyMatrix(result, a);
  }
  return result;
}

function createStochasticRow(row) {
  var links = 0;
  for (var i = 0; i < row.length; i++) {
    links += row[i];
  }
  if (links > 0) {
    for (i = 0; i < row.length; i++) {
      if (row[i] !== 0) row[i] /= links;
    }
  } else {
    for (i = 0; i < row.length; i++) {
      row[i] = 1 / row.length;
    }
  }
  return row;
}

function createStochasticMatrix(a) {
  for (var i = 0; i < a.length; i++) {
    a[i] = createStochasticRow(a[i]);
  }
  return a[i];
}

function createPageRank(a) {
  var g = createStochasticMatrix(a);
  var gToTheT = powMatrix(a, 10000);
  var pageRanking = [];
  for (var i = 0; i < gToTheT.length; i++) {
    var rank = {
      name: i,
      value: 0
    };
    for (var j = 0; j < gToTheT.length; j++) {
      rank.value += gToTheT[j][i];
    }
    pageRanking.push(rank);
  }
  console.log(pageRanking);
  return pageRanking.sort(function(a, b) {
    return a.value < b.value;
  }).map(function(a) {
    return a.name;
  });
}

var a = [
  [0, 1, 0, 0],
  [0, 0, 1, 0],
  [0, 0, 0, 1],
  [1, 0, 1, 0]
];

console.log(createPageRank(a));
