define [], ->
  class Uploader
    constructor: ->
      @endpoint = "//localhost:8090/upload"

      @message = $("<div />").addClass("upload-message").html('''
        <h1>Drop a file to upload..</h1

        <p>
          Currently only collada <code>.dae</code> is supported, and materials and textures are discarded.
        </p>
      ''').appendTo 'body'

      @overlay = $("<div />").addClass('upload-overlay').appendTo 'body'

      @form = $("<form method='post' enctype='multipart/form-data' action='#{@endpoint}' />").addClass('upload-form').html('''
        <input type="file" name="upload" />
      ''').appendTo 'body'

      @form.find('input').change =>
        @submit()

        setTimeout( =>     
          @form.hide()
          @overlay.hide()
          @message.hide()
        , 50)

    onSuccess: =>
      alert "file upload complete.."

    submit: ->
      # @form.submit()
      # return

      file = @form.find('input').get(0).files[0]

      unless file.name.match /dae$/i
        alert "Sorry, only files of type .dae (collada) are able to be uploaded..."
        return

      $.ajax {
        type : "post"
        url : @endpoint
        data : new FormData(@form.get(0))
        processData : false
        contentType : false
        success : @onSuccess
        error: ->
          alert "wtf?"
        xhrFields: {
          # add listener to XMLHTTPRequest object directly for progress (not sure if using deferred works)
          onprogress: (progress) ->
            # calculate upload progress
            percentage = Math.floor((progress.total / progress.totalSize) * 100);

            # log upload progress to console
            console.log('progress', percentage);

            if percentage == 100
              console.log('DONE!');
        }
      }

  Uploader