import $ from "jquery"
import Rx from "rxjs/Rx"

let BotoGP = window['BotoGP'] || {};

BotoGP.designer = {
    isPointOfInterest: function (context, x, y) {
        var inpath = context.isPointInStroke(x, y);

        return inpath != context.isPointInStroke(x - 1, y)
            || inpath != context.isPointInStroke(x + 1, y)
            || inpath != context.isPointInStroke(x, y - 1)
            || inpath != context.isPointInStroke(x, y + 1);
    },
    pointsOfInterest: function (canvas) {
        var context = canvas.getContext("2d");
        var x, y, pointsOfInterest = { "on": [], "off": [], "heat": {} };
        for (y = 0; y < canvas.height; y += 1) {
            for (x = 0; x < canvas.width; x += 1) {

                var inpath = context.isPointInStroke(x, y);

                var type = inpath ? "on" : "off";

                var isOfInterest = BotoGP.designer.isPointOfInterest(context, x, y);
                if (isOfInterest) {
                    pointsOfInterest[type][pointsOfInterest[type].length] = {
                        'x': x,
                        'y': y
                    };
                    var h = pointsOfInterest["heat"][y.toString()] || {};
                    h[x.toString()] = type == "on" ? 1 : 0;
                    pointsOfInterest["heat"][y.toString()] = h;
                }
            }
        }
        // Delete every heat
        return pointsOfInterest;
    }
};


BotoGP.repo = {
    changeName: function (id, name) {
        BotoGP.repo.change(id, { "name": name });
    },
    changeCheckpoints: function (id, checkpoints) {
        BotoGP.repo.change(id, { "checkpoints": checkpoints });
    },
    changeDatamap: function (id, datamap) {
        BotoGP.repo.change(id, { "datamap": datamap });
    },
    change: function (id, changes) {
        $.ajax({
            type: "PUT",
            url: "/api/circuits/" + id,
            contentType: "application/json",
            data: JSON.stringify({
                "circuit": changes
            })
        });
    }
};

var circuitModel = {
    "name": "Default track",
    "width": circuitWidth,
    "height": circuitHeight,
    "scale": scale,
    "checkpoints": [],
    "pointsOfInterest": {}
};


var points = [];

var canvas = document.querySelector("canvas#circuit");
var canvasContext = canvas.getContext("2d");

var previewCanvas = document.querySelector("canvas#preview");
var previewCanvasContext = previewCanvas.getContext("2d");

var clickEvent$ = Rx.Observable.fromEvent($('canvas#circuit'), 'click');

var nameChange$ = Rx.Observable.fromEvent($('h2 input.circuit-name'), 'keyup')
    .debounceTime(500)
    .distinctUntilChanged()
    .map(function (e) {
        return {
            "id": $(e.target).data("circuit-id"),
            "name": e.target.value
        }
    });

nameChange$.subscribe(function (d) {
    $('h1.circuit-name').text(d.name);
    circuitModel.name = d.name;
    BotoGP.repo.changeName(d.id, d.name);
});


    var pointClick$ = clickEvent$.map(function (e) {
        return {
            'x': e.offsetX,
            'y': e.offsetY
        }
    }).startWith({ 'x': circuitWidth / 2, 'y': 20 });

var scale = 3;
var circuitWidth = 150 / scale, circuitHeight = 100 / scale;

$(document).ready(function () {




			pointClick$.subscribe(function (p) {
				points[points.length] = p;
				var context = document.querySelector("canvas#preview").getContext("2d");
				context.clearRect(0, 0, canvas.width, canvas.height);
				context.translate(0.0, 0.0);

				context.lineWidth = 80 / scale;
				context.strokeStyle = "#999";
				context.beginPath();
				context.moveTo(points[0].x, points[0].y);
				var pointIndex;
				for (pointIndex = 0; pointIndex < points.length; pointIndex++) {
					context.lineTo(points[pointIndex].x, points[pointIndex].y);
				}
				context.closePath();
				context.lineJoin = 'round';
				context.stroke();

				context.lineWidth = 60 / scale;
				context.strokeStyle = "#ccc";
				context.beginPath();
				context.moveTo(points[0].x, points[0].y);
				var pointIndex;
				for (pointIndex = 0; pointIndex < points.length; pointIndex++) {
					context.lineTo(points[pointIndex].x, points[pointIndex].y);
				}
				context.closePath();
				context.lineJoin = 'round';
				context.stroke();

			});

			pointClick$.subscribe(function (point) {

				canvasContext.lineTo(point.x, point.y);
				canvasContext.lineWidth = 9 / scale;
				canvasContext.strokeStyle = "#ccc";
				canvasContext.stroke();

				canvasContext.moveTo(point.x, point.y);

				canvasContext.beginPath()
				canvasContext.arc(point.x, point.y, 9 / scale, 0, 2 * Math.PI, false);
				canvasContext.fillStyle = '#ccc';
				canvasContext.fill();
				canvasContext.strokeStyle = "#ccc";
				canvasContext.stroke();

				canvasContext.moveTo(point.x, point.y);
			});

			pointClick$.subscribe(function (p) {
				var context = document.querySelector("canvas#plotter").getContext("2d");
				context.clearRect(0, 0, canvas.width * scale, canvas.height * scale);
				context.translate(0.0, 0.0);

				var radius = 1;

				var pointsOfInterest = BotoGP.designer.pointsOfInterest(previewCanvas);

				context.fillStyle = '#cc0000';
				$.each(pointsOfInterest["off"], function (index, point) {
					context.beginPath();
					context.arc(point.x * scale, point.y * scale, radius, 0, 2 * Math.PI, false);
					context.fill();
				});

				context.fillStyle = '#00ff00';
				$.each(pointsOfInterest["on"], function (index, point) {
					context.beginPath();
					context.arc(point.x * scale, point.y * scale, radius, 0, 2 * Math.PI, false);
					context.fill();
				});

				circuitModel.checkpoints = points.map(function (p) {
					return [p.x, p.y]
				});
				
				circuitModel.heat = pointsOfInterest["heat"];

                 BotoGP.repo.changeDatamap(1,{
								"checkpoints": circuitModel.checkpoints,
								"dimensions": {
									"width": circuitModel.width,
									"height": circuitModel.height,
									"scale": circuitModel.scale
								},
								"heat": circuitModel.heat
							});

				$('#serialized').text(JSON.stringify(circuitModel));
			});



    Rx.Observable.fromEvent($('canvas#preview'), 'mousemove').subscribe(function (e) {
        var x = e.offsetX, y = e.offsetY;
        $('#circle1').attr('cy', y);
        $('#circle1').attr('cx', x);

        var inpath = e.target.getContext("2d").isPointInStroke(x, y);
        $('#circle1').attr('stroke', inpath ? '#00ff00' : '#ff0000');
    });

    Rx.Observable.fromEvent($('h2 input.circuit-checkpoints'), 'change')
        .debounceTime(500)
        .subscribe(function (e) {
            $('h1.circuit-checkpoints').text(e.target.value);
            BotoGP.repo.changeCheckpoints($(e.target).data("circuit-id"), e.target.value);
        });

    Rx.Observable.fromEvent($('canvas#preview'), 'click').subscribe(function (e) {
        var x = e.offsetX, y = e.offsetY;
        $.get("/api/circuits/" + $(e.target).data("circuit-id") + "/tileinfo?x=" + x + "&y=" + y, function (d) {
            $("#hits").text(d);
        }
        );
    });
});

export default BotoGP;