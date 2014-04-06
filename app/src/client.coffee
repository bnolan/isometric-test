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

      # create a canvas 2D point for pixel view world
      point = new obelisk.Point(200, 200)

      # create view instance to nest everything
      # canvas could be either DOM or jQuery element
      @pixelView = new obelisk.PixelView(@canvas, point)

      @nodes = []

      # create cube dimension and color instance
      dimension = new obelisk.CubeDimension(20, 20, 20)
      color = new obelisk.CubeColor().getByHorizontalColor(obelisk.ColorPattern.PURPLE)

      for i in [0..10]
        @nodes.push {
          x : Math.random()
          y : Math.random()
          t : Math.random() * 0xFFFF
          cube : new obelisk.Cube(dimension, color, true)
        }

      color = new obelisk.SideColor(0x66666677, 0x66666677)
      dimension = new obelisk.CubeDimension(20, 40, 0)
      @shadow = new obelisk.Brick(dimension, color)

      @tick()

    renderGrid: ->
      # render the grid
      WIDTH = 10
      HEIGHT = 10
      SIZE = 20

      colorBG = new obelisk.SideColor().getByInnerColor(obelisk.ColorPattern.GRAY)
      dimension = new obelisk.CubeDimension(20, 20, 0)

      for i in [0..WIDTH]
        for j in [0..HEIGHT]
          point = new obelisk.Point3D(i * SIZE, j * SIZE, 0)
          brick = new obelisk.Brick(dimension, colorBG)
          @pixelView.renderObject(brick, point)

    tick: =>
      @stats.begin()

      @ctx.clearRect(0,0,@width,@height)

      for node in @nodes
        t = (node.t + new Date().getTime()) / 1000.0

        x = Math.sin(t * node.x) * @width / 4 + 400
        y = Math.sin(t * node.y) * @height / 4

        # Location
        point = new obelisk.Point3D(x, y, 0)

        # Draw the shadow
        @pixelView.renderObject(@shadow, point)

        # render cube primitive into view
        @pixelView.renderObject(node.cube, point)

      @stats.end()

      requestAnimationFrame @tick

  $ -> new Renderer
