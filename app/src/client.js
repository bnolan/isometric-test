// Generated by CoffeeScript 1.4.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  require.config({
    urlArgs: "nonce=" + (new Date()).getTime()
  });

  require(["/app/src/scene.js", "/app/src/connector.js", "/app/components/jquery/dist/jquery.js", "/app/components/obelisk.js/build/obelisk.js", "/app/components/stats.js/build/stats.min.js"], function(Scene, Connector, _jquery, _obelisk, _stats) {
    var Renderer;
    Renderer = (function() {

      function Renderer() {
        this.tick = __bind(this.tick, this);

        var color, dimension, point;
        this.scene = new Scene;
        this.connector = new Connector(this.scene);
        this.width = $(window).width();
        this.height = $(window).height();
        this.stats = new Stats();
        this.stats.setMode(0);
        this.stats.domElement.style.position = 'absolute';
        this.stats.domElement.style.left = '0px';
        this.stats.domElement.style.top = '0px';
        document.body.appendChild(this.stats.domElement);
        this.canvas = $("<canvas width='" + this.width + "' height='" + this.height + "' style='width: " + this.width + "px; height: " + this.height + "px' />").appendTo('body');
        this.ctx = this.canvas[0].getContext('2d');
        point = new obelisk.Point(200, 200);
        this.pixelView = new obelisk.PixelView(this.canvas, point);
        dimension = new obelisk.CubeDimension(20, 20, 20);
        color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.PURPLE);
        this.cube = new obelisk.Cube(dimension, color, true);
        dimension = new obelisk.CubeDimension(20, 40, 0);
        color = new obelisk.SideColor(0x66666677, 0x66666677);
        this.shadow = new obelisk.Brick(dimension, color);
        this.tick();
      }

      Renderer.prototype.tick = function() {
        var element, key, point, _ref;
        this.stats.begin();
        TWEEN.update();
        this.ctx.clearRect(0, 0, this.width, this.height);
        _ref = this.scene.childNodes;
        for (key in _ref) {
          element = _ref[key];
          point = new obelisk.Point3D(element.position.x, element.position.z, element.position.y);
          this.pixelView.renderObject(this.shadow, point);
          this.pixelView.renderObject(this.cube, point);
        }
        this.stats.end();
        return requestAnimationFrame(this.tick);
      };

      return Renderer;

    })();
    return $(function() {
      return new Renderer;
    });
  });

}).call(this);
