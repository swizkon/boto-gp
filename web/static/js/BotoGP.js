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
        $.ajax({
            type: "PUT",
            url: "http://localhost:4000/api/circuits/" + id,
            contentType: "application/json",
            data: JSON.stringify({
                "circuit": {
                    "name": name
                }
            })
        });
    }
};


var scale = 5;
var circuitWidth = 150 / scale, circuitHeight = 100 / scale;

$(document).ready(function () {
    // alert(circuitHeight);

    $('#circuit, #preview').attr('width', 150);
    $('#circuit, #preview').attr('height', 100);

    Rx.Observable.fromEvent($('canvas#preview'), 'mousemove').subscribe(function (e) {

        var x = e.offsetX, y = e.offsetY;
        $('#circle1').attr('cy', y);
        $('#circle1').attr('cx', x);

        var inpath = e.target.getContext("2d").isPointInStroke(x, y);
        $('#circle1').attr('stroke', inpath ? '#00ff00' : '#ff0000');
    });

    // Update the name of the circuit
    Rx.Observable.fromEvent($('h2 input.circuit-name'), 'keyup')
        .debounce(() => Rx.Observable.timer(500))
        .subscribe(function (e) {
            $('h1.circuit-name').text(e.target.value);
            BotoGP.repo.changeName($(e.target).data("circuit-id"), e.target.value);
        });
});

export default BotoGP;