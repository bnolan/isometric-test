define [], () ->
  class Scene
    constructor: ->
      @elements = {}
    
    getElementById: (id) ->
      @elements[id]
    
    appendChild: (element) ->
      @elements[element.id] = element
    
    removeChild: (element) ->
      @elements[element.id] = null
    
  Scene
