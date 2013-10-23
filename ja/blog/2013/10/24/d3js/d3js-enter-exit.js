d3.select("svg#sample2")
  .attr('width', 300).attr('height', 300)
  .style('display', 'block')
  .append('polyline')
  .attr('stroke', 'red')
  .attr('stroke-width', '1')
  .attr('fill', 'transparent');

var values = [];
for (var i = 0; i < 10; i++) {
  values.push(Math.random());
}

function update() {
  // 配列の個数を n に代入
  var n = values.length;

  // <svg> の中の <circle> を列挙して、values を割り当てる
  var circles = d3.select("svg#sample2")
    .selectAll('circle').data(values);

  // 作成: 足りない <circle> を追加する
  circles.enter()
    .append('circle')
    .attr('fill', 'red')
    .attr('cx', function(d, i) { return i * 280 / n + 10; })
    .attr('cy', 0).attr('r', 0);

  // 削除: 余分な <circle> はアニメーションつきで削除
  circles.exit()
    .transition()
    .duration(300)
    .attr('cy', 0).attr('r', 0)
    .remove();

  // 更新: アニメーションで正しい位置とサイズに移動
  circles
    .transition()
    .duration(300)
    .attr('cx', function(d, i) { return i * 280 / n + 10; })
    .attr('cy', function(d, i) { return d * 280 + 10; })
    .attr('r', 6);

  // 線の位置も調整する
  d3.select('svg#sample2 polyline')
    .transition()
    .duration(300)
    .attr('points', values.map(function(d, i) {
      return (i * 280 / n + 10) + ' ' + (d * 280 + 10);
    }).join(','));
}

function update2() {
  var n = values.length;

  var circles = d3.select("svg#sample1")
    .selectAll('circle').data(values);
  circles.enter()
    .append('circle')
    .attr('cx', function(d, i) { return (i + 1) * 300 / (n + 1); })
    .attr('cy', 0).attr('r', 0);
  circles.exit()
    .transition()
    .duration(300)
    .attr('cy', 0).attr('r', 0)
    .remove();
  circles
    .attr('fill', 'red')
    .transition()
    .duration(300)
    .attr('cx', function(d, i) { return (i + 1) * 300 / (n + 1); })
    .attr('cy', function(d, i) { return d * 280 + 10; })
    .attr('r', 6);
  polyline
    .transition()
    .duration(300)
    .attr('points', values.map(function(d, i) {
      return ((i + 1) * 300 / (n + 1)) + ' ' + (d * 280 + 10);
    }).join(','));
}

function change() {
  var n = values.length;
  for (var i = 0; i < n; i++) {
    values[i] = Math.random();
  }
  update();
}

function add() {
  values.push(Math.random());
  update();
}

function del() {
  values.pop();
  update();
}

update();
