define [
  '/app/components/threejs/build/three.js', 
  '/app/src/utils.js',
  '/app/src/elements/box.js'
], (THREE_, utils, Box) ->
	class PacketIntroducing
	  @id: 0x01

	  constructor: (array) ->
      [nil, @xml] = array

    process: (scene) ->
      element = scene.getElementById(@id)

      if element
        # todo - reparse the xml without deleting / creating the element
        scene.removeChild(element)

      dom = $(@xml).first()

      @id = dom.attr('id')

      element = switch dom.get(0).nodeName
        when 'BOX' then new Box @id
        else
          throw "Invalid element introduced"
      
      element.position = utils.attributeToVector(dom.attr('position'))
      element.rotation = utils.attributeToEuler(dom.attr('rotation'))
      element.scale = utils.attributeToVector(dom.attr('scale'))

      scene.appendChild(element)

      true

	class PacketUpdate
	  @id: 0x02

	  constructor: (array) ->
      [nil, @id, @positionX, @positionY, @positionZ, @rotationX, @rotationY, @rotationZ] = array

    _byteToEuler: (byte) ->
      byte / 256.0 * 2 * Math.PI

    process: (scene) ->
      element = scene.getElementById(@id)

      if !element
        debug "Trying to update non-present element #{@id}"

      element.position = new THREE.Vector3 @positionX, @positionY, @positionZ
      element.rotation = new THREE.Euler @_byteToEuler(@rotationX, @rotationY, @rotationZ)

      # Do something...
      element.notify()

      true

	class PacketGone
	  @id: 0x03
	  
	  constructor: (array) ->
      [nil, @id] = array

	  process: (scene) ->
      element = scene.getElementById(@id)

      if !element
        scene.removeChild(element)

      true

  # Construct the exports...
  packets = {
    "Introducing" : PacketIntroducing
    "Update" : PacketUpdate
    "Gone" : PacketGone
  }

  dictionary = {}

  for key, value of packets
    dictionary[value.id] = value

  {
    packets : packets
    dictionary : dictionary
  }
