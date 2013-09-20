var debug = (location.hash == "#debug");
var jumpPoints = [
    { x: 274, y: 166, mx: 274, my: 167, name: "Berlin" },
    { x: 269, y: 147, mx: 269, my: 148, name: "Oslo" },
    { x: 308, y: 161, mx: 308, my: 162, name: "Moscow" },
    { x: 297, y: 210, mx: 297, my: 211, name: "Alexandria" },
    { x: 281, y: 306, mx: 283, my: 306, name: "Cape Town" },
    { x: 354, y: 203, mx: 354, my: 204, name: "Kabul" },
    { x: 420, y: 194, mx: 420, my: 195, name: "Beijing" },
    { x:  92, y: 164, mx:  92, my: 165, name: "Edmonton" },
    { x: 115, y: 226, mx: 115, my: 227, name: "Mexico City" }
];

function initialize() {
    new GameManager();
}

/**** GameManager ****/
function GameManager() {
    var x = 258, y = 170;
    this.map = new Map(document.getElementById("map_canvas"), 5);
    this.mainCharacter = new MainCharacter(this.map, x, y);
    this.checkPoint = new CheckPoint();
    this.controller = new Controller(this.mainCharacter);
    this.commandUI = new CommandUI(this.checkPoint);

    var self = this;
    $(this.commandUI).
	bind("jump", function(e, x, y){self.onJumpExecuted(e, x, y)}).
	bind("rainbow", function(e){self.onRainbow(e);});
    $(this.mainCharacter).bind("move", function(e){self.onMove(e)});
    google.maps.event.addListener(this.map.map, 'projection_changed', function(e) {
	self.initCheckPoints();
    });
}
GameManager.prototype = {
    initCheckPoints: function() {
	this.commandUI.update();
	for (var key in this.checkPoint.points) {
	    var p = this.checkPoint.points[key];
	    this.map.addMarkerToTown(p.x, p.y);
	}
	if (this.checkPoint.rainbowUsed) {
	    this.map.addRoadToAmerica();
	}
    },

    onMove: function(e) {
	var x = this.mainCharacter.x;
	var y = this.mainCharacter.y;
	if (Map.getCell(x, y) == Map.TOWN) {
	    if (this.checkPoint.update(x, y)) {
		var p = this.checkPoint.getNormalizedPosition(x, y);
		this.map.addMarkerToTown(p[0], p[1], true);
		this.commandUI.update();
	    }
	}
    },
    
    onJumpExecuted: function(e, x, y) {
	this.mainCharacter.x = x;
	this.mainCharacter.y = y;
	this.mainCharacter.draw_direction = 2;
	this.map.goto(x + .5, y + .5);
    },

    onRainbow: function(e) {
	if (this.mainCharacter.x != 15 || this.mainCharacter.y != 126) {
	    alert("Nothing happened\nUse Dew at Mys Dezhnjova.");
	    return;
	}
	this.map.addRoadToAmerica(true);
	this.checkPoint.rainbowUsed = true;
	this.checkPoint.save();
	this.commandUI.update();
    }
};

/**** Map ****/
function Map(elm, zoom) {
    this.elm = elm;
    this.init(elm, zoom);
}
$.extend(Map, {
    NORMAL: 0,
    WALL: 1,
    SEA: 2,
    TOWN: 3,
    getCell: function(x, y) {
	if (x < 0 || y < 0 || x >= 512 || y >= 512) {
	    alert("invalid pos: " + x + "," + y);
	    return -1;
	}
	return parseInt(map_data.charAt(x + y * 512), 10);
    }
});
Map.prototype = {
    map: null,

    init: function(elm, zoom) {
	// refered http://blog.bn.ee/2012/03/31/how-to-use-google-maps-8-bit-tiles-in-your-own-project/
	var _8bitTile = {
	    getTileUrl: function(coord, zoom) {
		var t = Math.pow(2, zoom);
		return "http://mt1.google.com/vt/lyrs=8bit,m@174000000&hl=en&src=app&s=Galil&" +
		    "z=" + zoom + "&x=" + ((coord.x + t) % t) + "&y=" + ((coord.y + t) % t);
	    },
	    tileSize: new google.maps.Size(256, 256),
	    isPng: true	
	};
	var _8bitMapType = new google.maps.ImageMapType(_8bitTile);
	var myLatlng = new google.maps.LatLng(50.958426723359935, 1.7578125);
	var myOptions = {
	    zoom: zoom,
	    center: myLatlng,
	    disableDefaultUI: true,
	    keyboardShortcuts: false,
	    scrollwheel: false,
	    disableDoubleClickZoom: true,
	    draggable: false,
	    keyboardShortcuts: false,
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	this.map = new google.maps.Map(elm, myOptions);
	this.map.overlayMapTypes.insertAt(0, _8bitMapType);
    },

    go: function(diff_x, diff_y) {
	this.map.panBy(diff_x * 16, diff_y * 16);
    },

    goto: function(x, y) {
	var p = this.getPositionInfo(x, y);
	this.map.setCenter(p.latlng);
    },

    // coordinate to Point and LatLng
    getPositionInfo: function(x, y) {
	var proj = this.map.getProjection();
	if (this.map.getZoom() != 5) { alert('not implemented'); return; }
	var p = new google.maps.Point(x * 0.5, (y + 1) * 0.5);
	var latlng = proj.fromPointToLatLng(p);
	return {
	    game: [x, y],
	    point: p,
	    latlng: latlng
	};
    },

    addMarkerToTown: function(x, y, animation) {
	this.addMarker(x + 2.5, y + 1.0, animation);
    },

    // add marker to specified point (view coordinate)
    addMarker: function(x, y, animation) {
	var pos = this.getPositionInfo(x, y);
	new google.maps.Marker({
	    position: pos.latlng,
	    clickable: false,
	    map: this.map,
	    animation: animation ? google.maps.Animation.DROP : null,
	    flat: true
	});
    },

    addRoadToAmerica: function(animation) {
	var image = new google.maps.MarkerImage(
	    "http://mt1.google.com/vt/lyrs=8bit,m@174000000&hl=en&src=app&s=Galil&z=5&x=0&y=7",
	    new google.maps.Size(16, 16),
	    new google.maps.Point(240, 240),
	    new google.maps.Point(0, 0));
	var self = this;
	var n = 1;

	// add ground
	var f = function(i) {
	    var pos = self.getPositionInfo(16 + i, 126);
	    new google.maps.Marker({
		position: pos.latlng,
		icon: image,
		clickable: false,
		animation: animation ? google.maps.Animation.DROP : null,
		map: self.map,
		flat: true
	    });
	};

	// animation tick
	function tick() {
	    var xx = Math.random() * 8 - 4;
	    var yy = Math.random() * 8 - 4;
	    $(self.elm).css({left: xx + "px", top: yy + "px"});
	    if (n % 50 == 0) {
		f(n / 50 - 1);
	    }
	    if (n == 299) {
		$(self.elm).css({left: 0, top: 0});
		modifyMapData();
		return;
	    }
	    n++;
	    setTimeout(tick, 16);
	}

	// modify map_data
	function modifyMapData() {
	    var i = 126 * 512 + 16;
	    map_data = map_data.substr(0, i) + "00000" + map_data.substr(i + 5);
	}

	if (!animation) {
	    f(0); f(1); f(2); f(3); f(4);
	    modifyMapData();
	} else {
	    tick();
	}
    }
};

/**** Controller ****/
function Controller(mainCharacter){
    this.mainCharacter = mainCharacter;
    this.init();
}
Controller.prototype = {
    INTERVAL: debug ? 150 : 250,
    pressing: false,
    prev_move_time: 0,
    update_flag: false,
    timer: undefined,

    init: function() {
	var self = this;
	$(document).
	    keydown(function(e){return self.keyHandler(e, true);}).
	    keyup(function(e){return self.keyHandler(e, false);});
	$("#game_control button").
	    bind("mousedown touchstart", function(e){self.clickHandler(e, true);});
	this.resetTimer();
	this.draw();
    },

    updateIfTimeout: function() {
	if(new Date().getTime() - this.prev_move_time > this.INTERVAL){
	    this.update();
	}
    },

    resetTimer: function() {
	if (this.timer != undefined) { clearTimeout(this.timer); }
	var self = this;
	this.timer = setTimeout(function(){self.update()}, this.INTERVAL);
    },

    update: function() {
	this.resetTimer();

	if (this.pressing) {
	    this.mainCharacter.go(this.direction);
	    this.prev_move_time = new Date().getTime();
	}
	this.draw();
    },

    draw: function() {
	this.mainCharacter.draw();
    },

    keyHandler: function(e, flag){
	// check keycode
	var keyCode = e.keyCode ? e.keyCode : e.which;
	if (keyCode < 37 || keyCode > 40 || e.ctrlKey || e.shiftKey || e.altKey) {
	    this.pressing = false;
	    return true;
	}

	// update state
	this.direction = (keyCode - 38 + 4) % 4;
	this.pressing = flag;
	this.updateIfTimeout();

	return false;
    },

    clickHandler: function(e, down){
	e.preventDefault();
	var val = $(e.target).closest("button").val();
	switch (val){
	case "u": this.direction = 0; break;
	case "l": this.direction = 3; break;
	case "r": this.direction = 1; break;
	case "d": this.direction = 2; break;
	default: return;
	}
	this.pressing = down;
	this.updateIfTimeout();

	// event for mouseup
	if (down) {
	    var self = this;
	    $(document).bind("mouseup touchend", function(e){self.clickHandler(e, false);});
	} else {
	    $(document).unbind("mouseup touchend");
	}
    }
};

/**** CommandUI ****/
function CommandUI(checkPoint) {
    this.elm = $("#game_command");
    this.mode = 0;
    this.checkPoint = checkPoint;
    this.prevVisited = checkPoint.visited;
}
$.extend(CommandUI, {
    TOP: 0,
    RETURN: 1
});
CommandUI.prototype = {
    update: function() {
	this.elm.children().remove();

	if (this.mode == CommandUI.TOP) {
	    this.updateTop();
	} else if (this.mode == CommandUI.RETURN) {
	    this.updateReturn();
	}
    },
    updateTop: function() {
	if (this.checkPoint.visited >= 10) {
	    this.addButton("Return", this.returnClicked);
	    if (this.prevVisited == 9) {
		alert("Now you can use 'return' spell");
	    }
	}
	if (this.checkPoint.visited >= 70 && !this.checkPoint.rainbowUsed) {
	    this.addButton("Rainbow Dew", this.rainbowClicked);
	    if (this.prevVisited == 69) {
		alert("Now you can go to America by using Rainbow Dew.\n" +
		      "Use Rainbow Dew at Mys Dezhnjova.");
	    }
	}
	if (debug) {
	    this.addButton("Jump to", function(e) {
		var input = window.prompt("Jump to...");
		var m = input.match(/^(\d+),(\d+)$/);
		if (m) {
		    $(this).trigger("jump", [parseInt(m[1], 10), parseInt(m[2], 10)]);
		}
	    });
	}
	this.prevVisited = this.checkPoint.visited;
    },
    updateReturn: function() {
	this.elm.children().remove();
	this.addButton("Cancel", this.cancelClicked);
	for (var i = 0; i < jumpPoints.length; i++) {
	    var p = jumpPoints[i];
	    if (!this.checkPoint.isVisited(p.x, p.y)) { continue; }
	    this.addButton(p.name, this.jumpClicked);
	}
    },

    addButton: function(name, handler) {
	var self = this;
	$("<button>").
	    val(name).
	    text(name).
	    click(function(e){handler.call(self, e);}).
	    appendTo(this.elm);
    },

    cancelClicked: function(e) {
	this.mode = CommandUI.TOP;
	this.update();
    },
    
    returnClicked: function(e) {
	this.mode = CommandUI.RETURN;
	this.update();
    },

    rainbowClicked: function(e) {
	$(this).trigger("rainbow");
    },
   
    jumpClicked: function(e) {
	var value = e.target.value;
	for (var i = 0; i < jumpPoints.length; i++) {
	    var p = jumpPoints[i];
	    if (p.name == value) {
		$(this).trigger("jump", [p.mx, p.my]);
	    }
	}
	
	this.mode = CommandUI.TOP;
	this.update();
    }
};

/**** MainCharacter ****/
function MainCharacter(map, x, y){
    this.map = map;
    this.x = x;
    this.y = y;
    this.draw_direction = 2;
    this.init();
}
MainCharacter.prototype = {
    init: function() {
	this.draw();

	if (debug) {
	    this.debugElm = $("<pre>").appendTo(document.body);
	}
    },

    // direction: 0=up, 1=left, 2=down, 3=right
    go: function(direction){
	this.draw_direction = direction;
	this.update_flag = !this.update_flag;

	var diff_x = (direction % 2 == 1 ? -(direction - 2) : 0);
	var diff_y = (direction % 2 == 0 ?  (direction - 1) : 0);
	var new_x = (diff_x + this.x + 512) % 512;
	var new_y = (diff_y + this.y + 512) % 512;

	var c = Map.getCell(new_x, new_y);
	if (c == Map.SEA || c == Map.WALL){
	    new_x = this.x;
	    new_y = this.y;
	    diff_x = diff_y = 0;
	    this.draw(); // for change direction
	    return false;
	}

	this.map.go(diff_x, diff_y);
	this.draw_direction = direction;
	this.x = new_x;
	this.y = new_y;
	this.draw();
	$(this).trigger("move");

	this.outputDebugInfo();
    },

    draw: function() {
	this.update_flag = !this.update_flag;
	var index = this.draw_direction * 2 + (this.update_flag ? 1 : 0);
	$("#character img").css("top", (-index * 16) + "px");
    },

    outputDebugInfo: function() {
	if (debug) {
	    var p = this.map.getPositionInfo(this.x, this.y);
	    this.debugElm.text(
		"map: (" + this.x + "," + this.y +")\n" +
		    "image: (" + Math.floor(this.y / 16) + "," + Math.floor(this.x / 16) + ")\n" + 
		    "latlng: (" + p.latlng.lat() + "," + p.latlng.lng() + ")\n");
	}
    }
}


/**** CheckPoint ****/
function CheckPoint() {
    this.visited = 0;
    this.total = 185;
    this.points = {};

    this.load();
    this.draw();
}
CheckPoint.prototype = {
    getNormalizedPosition: function(x, y) {
	var c1 = Map.getCell(x, y);
	if (c1 != Map.TOWN) return null;
	if (x > 0) {
	    if (Map.getCell(x - 1, y) == Map.TOWN) return [x - 1, y];
	}
	return [x, y];
    },

    isVisited: function(x, y) {
	var key = x + "," + y;
	return key in this.points;
    },
    
    update: function(x, y) {
	// check visited
	var p = this.getNormalizedPosition(x, y);
	if (!p) return false;

	x = p[0]; y = p[1];
	if (!this.isVisited(x, y)) {
	    this.add(x, y);
	    this.draw();
	    this.save();
	    return true;
	}
	return false;
    },

    add: function(x, y) {
	var p = this.getNormalizedPosition(x, y);
	if (!p) return false;
	x = p[0]; y = p[1];
	
	var key = x + "," + y;
	this.points[key] = { x: x, y: y	};
	this.visited++;
	return true;
    },

    draw: function() {
	$("#check_points").text(this.visited + "/" + this.total);
    },

    save: function() {
	var str = "";
	for (var key in this.points) {
	    var p = this.points[key];
	    var n = p.x + p.y * 512;
	    n = n.toString(36);
	    while (n.length < 4) n = "0" + n;
	    str += n;
	}

	if (this.rainbowUsed) {
	    str += "\n1";
	}
	
	if (window.localStorage) {
	    localStorage.setItem('8bitMapsRpg', str);
	}
    },

    load: function() {
	if (!window.localStorage) return;
	this.points = {};
	this.visited = 0;

	var value = localStorage.getItem('8bitMapsRpg');
	if (!value) return;
	lines = value.split(/\r?\n/);

	var str = lines[0];
	for (var i = 0; i < str.length; i += 4) {
	    var n = parseInt(str.substr(i, 4), 36);
	    var x = n % 512;
	    var y = Math.floor(n / 512);
	    this.add(x, y);
	}

	if (lines.length > 1 && lines[1] == "1") {
	    this.rainbowUsed = true;
	}
    }
};
