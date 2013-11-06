var flag = false;
var WIDTH = d3.select("#kmeans")[0][0].offsetWidth - 20;
var HEIGHT = Math.max(300, WIDTH * .7);
var svg = d3.select("#kmeans svg")
  .attr('width', WIDTH)
  .attr('height', HEIGHT)
  .style('padding', '10px')
  .style('background', '#223344')
  .style('cursor', 'pointer')
  .style('-webkit-user-select', 'none')
  .style('-khtml-user-select', 'none')
  .style('-moz-user-select', 'none')
  .style('-ms-user-select', 'none')
  .style('user-select', 'none')
  .on('click', function() {
    d3.event.preventDefault();
    step();
  });

d3.selectAll("#kmeans button")
  .style('padding', '.5em .8em');

d3.selectAll("#kmeans label")
  .style('display', 'inline-block')
  .style('width', '15em');

var lineg = svg.append('g');
var dotg = svg.append('g');
var centerg = svg.append('g');
d3.select("#step")
  .on('click', function() { step(); draw(); });
d3.select("#restart")
  .on('click', function() { restart(); draw(); });
d3.select("#reset")
  .on('click', function() { init(); draw(); });


var groups = [], dots = [];

function step() {
  d3.select("#restart").attr("disabled", null);
  if (flag) {
    moveCenter();
    draw();
  } else {
    updateGroups();
    draw();
  }
  flag = !flag;
}

function init() {
  d3.select("#restart").attr("disabled", "disabled");

  var N = parseInt(d3.select('#N')[0][0].value, 10);
  var K = parseInt(d3.select('#K')[0][0].value, 10);
  groups = [];
  for (var i = 0; i < K; i++) {
    var g = {
      dots: [],
      color: 'hsl(' + (i * 360 / K) + ',100%,50%)',
      center: {
        x: Math.random() * WIDTH,
        y: Math.random() * HEIGHT
      },
      init: {
        center: {}
      }
    };
    g.init.center = {
      x: g.center.x,
      y: g.center.y
    };
    groups.push(g);
  }

  dots = [];
  flag = false;
  for (i = 0; i < N; i++) {
    var dot ={
      x: Math.random() * WIDTH,
      y: Math.random() * HEIGHT,
      group: undefined
    };
    dot.init = {
      x: dot.x,
      y: dot.y,
      group: dot.group
    };
    dots.push(dot);
  }
}

function restart() {
  flag = false;
  d3.select("#restart").attr("disabled", "disabled");

  groups.forEach(function(g) {
    g.dots = [];
    g.center.x = g.init.center.x;
    g.center.y = g.init.center.y;
  });

  for (var i = 0; i < dots.length; i++) {
    var dot = dots[i];
    dots[i] = {
      x: dot.init.x,
      y: dot.init.y,
      group: undefined,
      init: dot.init
    };
  }
}


function draw() {
  var circles = dotg.selectAll('circle')
    .data(dots);
  circles.enter()
    .append('circle');
  circles.exit().remove();
  circles
    .transition()
    .duration(500)
    .attr('cx', function(d) { return d.x; })
    .attr('cy', function(d) { return d.y; })
    .attr('fill', function(d) { return d.group ? d.group.color : '#ffffff'; })
    .attr('r', 5);

  if (dots[0].group) {
    var l = lineg.selectAll('line')
      .data(dots);
    var updateLine = function(lines) {
      lines
        .attr('x1', function(d) { return d.x; })
        .attr('y1', function(d) { return d.y; })
        .attr('x2', function(d) { return d.group.center.x; })
        .attr('y2', function(d) { return d.group.center.y; })
        .attr('stroke', function(d) { return d.group.color; });
    };
    updateLine(l.enter().append('line'));
    updateLine(l.transition().duration(500));
    l.exit().remove();
  } else {
    lineg.selectAll('line').remove();
  }

  var c = centerg.selectAll('path')
    .data(groups);
  var updateCenters = function(centers) {
    centers
      .attr('transform', function(d) { return "translate(" + d.center.x + "," + d.center.y + ") rotate(45)";})
      .attr('fill', function(d,i) { return d.color; })
      .attr('stroke', '#aabbcc');
  };
  c.exit().remove();
  updateCenters(c.enter()
    .append('path')
    .attr('d', d3.svg.symbol().type('cross'))
    .attr('stroke', '#aabbcc'));
  updateCenters(c
    .transition()
    .duration(500));}

function moveCenter() {
  groups.forEach(function(group, i) {
    if (group.dots.length == 0) return;

    // get center of gravity
    var x = 0, y = 0;
    group.dots.forEach(function(dot) {
      x += dot.x;
      y += dot.y;
    });

    group.center = {
      x: x / group.dots.length,
      y: y / group.dots.length
    };
  });
  
}

function updateGroups() {
  groups.forEach(function(g) { g.dots = []; });
  dots.forEach(function(dot) {
    // find the nearest group
    var min = Infinity;
    var group;
    groups.forEach(function(g) {
      var d = Math.pow(g.center.x - dot.x, 2) + Math.pow(g.center.y - dot.y, 2);
      if (d < min) {
        min = d;
        group = g;
      }
    });

    // update group
    group.dots.push(dot);
    dot.group = group;
  });
}

init(); draw();
