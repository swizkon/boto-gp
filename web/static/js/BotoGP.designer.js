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

                var isOfInterest = endurance.designer.isPointOfInterest(context, x, y);
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


$(document).ready(function () {
    // BotoGP.renderPreviews();
    // window.scrollTo(2000);
    // dd

			Rx.Observable.fromEvent($('canvas#preview'), 'mousemove').subscribe(function (e) {

                alert(e);
				var x, y;
				x = e.offsetX;
				y = e.offsetY;

				$('#circle1').attr('cy', y);
				$('#circle1').attr('cx', x);

				var inpath = e.target.getContext("2d").isPointInStroke(x, y);

				$('#circle1').attr('stroke', inpath ? '#00ff00' : '#ff0000');
			});
});

export default BotoGP