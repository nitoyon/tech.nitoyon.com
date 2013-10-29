var svg = d3.select("svg#sample")
  .attr('width', 300).attr('height', 300)
  .style('display', 'block');
var polyline = svg.append('path')
  .attr('stroke', 'red')
  .attr('stroke-width', '1')
  .attr('fill', 'transparent');

var values = [];
for (var i = 0; i < 10; i++) {
  values.push(Math.random());
}
d3.select('#line-interpolate').on('change', update);

function update() {
  var n = values.length;

  var s = d3.select('#line-interpolate')[0][0];
  var interpolate = s.options[s.selectedIndex].value;

  var line = d3.svg.line()
    .x(function(d, i) { return (i + 1) * 300 / (n + 1); })
    .y(function(d, i) { return d * 280 + 10; })
    .interpolate(interpolate);

  var circles = svg.selectAll('circle').data(values);
  circles.enter()
    .append('circle')
    .attr('cx', line.x()).attr('cy', 0).attr('r', 0);
  circles.exit()
    .transition()
    .duration(300)
    .attr('cy', 0).attr('r', 0)
    .remove();
  circles
    .attr('fill', 'red')
    .transition()
    .duration(300)
    .attr('cx', line.x())
    .attr('cy', line.y())
    .attr('r', 6);
  polyline
    .transition()
    .duration(300)
    .attr('d', line(values));
}

function random() {
  var n = values.length;
  for (var i = 0; i < n; i++) {
    values[i] = Math.random();
  }
  update();
}

function push() {
  values.push(Math.random());
  update();
}

function pop() {
  values.pop();
  update();
}

update();
