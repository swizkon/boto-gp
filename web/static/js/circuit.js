import $ from "jquery"
import Rx from "rxjs/Rx"

let circuit = {
    
    renderPreviews: function () {
        $('canvas.circuit-preview').each((i, m) => {
            var points = $(m).data('checkpoints');
            var scale = parseInt($(m).data('scale'));
            points = $.map(points, (o, i) => {
                    return {
                        x: o[0] * scale,
                        y: o[1] * scale
                    }
            });
            circuit.drawPreview(m, points, scale);
        });
    },

    drawPreview: function (canvas, points, scale) {
        var context = canvas.getContext("2d");
        context.clearRect(0, 0, canvas.width, canvas.height);
        context.translate(0.0, 0.0);
        
        circuit.drawPath(context, 15 * scale, "#ddd", points);
        circuit.drawPath(context, 20 * scale, "rgba(200,200,200,0.5)", points);
    },

    drawPath: function(context, lineWidth, color, points){
        context.lineWidth = lineWidth;
        context.strokeStyle = color;
        context.beginPath();
        context.moveTo(points[0].x, points[0].y);
        var pointIndex;
        for (pointIndex = 0; pointIndex < points.length; pointIndex++) {
            context.lineTo(points[pointIndex].x, points[pointIndex].y);
        }
        context.closePath();
        context.lineJoin = 'round';
        context.stroke();
    }
}

$(document).ready(function () {
    // circuit.renderPreviews();
});

export default circuit