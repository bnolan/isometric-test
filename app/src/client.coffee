require.config {
    urlArgs : "nonce=" + (new Date()).getTime()
}

require [
  "/app/src/scene.js",
  "/app/src/connector.js",
  "/app/components/jquery/dist/jquery.js", 
  "/app/components/obelisk.js/build/obelisk.js", 
  "/app/components/stats.js/build/stats.min.js"
], (Scene, Connector, _jquery, _obelisk, _stats) ->
  class Renderer
    constructor: ->
      @scene = new Scene
      @connector = new Connector(@scene)
      
      @width = $(window).width()
      @height = $(window).height()

      @stats = new Stats()
      @stats.setMode(0)

      @stats.domElement.style.position = 'absolute';
      @stats.domElement.style.left = '0px';
      @stats.domElement.style.top = '0px';
      document.body.appendChild(@stats.domElement)

      @canvas = $("<canvas width='#{@width}' height='#{@height}' style='width: #{@width}px; height: #{@height}px' />").appendTo 'body'
      @ctx = @canvas[0].getContext('2d')

      # create view instance to nest everything
      # canvas could be either DOM or jQuery element
      point = new obelisk.Point(200, 200)
      @pixelView = new obelisk.PixelView(@canvas, point)

      # create cube dimension and color instance
      dimension = new obelisk.CubeDimension(20, 20, 20)
      color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.PURPLE)
      @cube = new obelisk.Cube(dimension, color, true)

      # shadow
      dimension = new obelisk.CubeDimension(20, 40, 0)
      color = new obelisk.SideColor(0x66666677, 0x66666677)
      @shadow = new obelisk.Brick(dimension, color)

      @tick()

    tick: =>
      @stats.begin()

      TWEEN.update()
      
      @ctx.clearRect(0,0,@width,@height)

      for key, element of @scene.childNodes
        # t = (node.t + new Date().getTime()) / 1000.0
        # x = Math.sin(t * node.x) * @width / 4 + 400
        # y = Math.sin(t * node.y) * @height / 4

        # Twiddle the position order, since obelisk has it's axis set up for 2d
        point = new obelisk.Point3D(element.position.x, element.position.z, element.position.y)

        # Draw the shadow
        @pixelView.renderObject(@shadow, point)

        # render cube primitive into view
        @pixelView.renderObject(@cube, point)

      @stats.end()

      requestAnimationFrame @tick

  $ -> new Renderer
