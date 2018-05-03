tinymce.init({
  selector: 'textarea#myeditor',
  height: 100,
  theme: 'modern',
  plugins: 'print code preview searchreplace autolink directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists textcolor wordcount imagetools contextmenu colorpicker textpattern',
  toolbar1: 'undo redo | styleselect | bold italic strikethrough underline forecolor | link | alignleft aligncenter alignright alignjustify  | numlist bullist outdent indent  | removeformat',
  element_format : 'xhtml', //Although xhtml is default, can never be too careful. Guarantee that document output is in XHTML (to make sure all tags are closed)
  image_advtab: true, //TODO: What is this????
  branding: false, //Don't want that "Powered by TinyMCE" branding
  style_formats_merge: false,
  style_formats: [
    { title: 'Headers', items: [
      { title: 'Header 1', block: 'h1' },
      { title: 'Header 2', block: 'h2' },
      { title: 'Header 3', block: 'h3' },
      { title: 'Header 4', block: 'h4' },
      { title: 'Header 5', block: 'h5' },
      { title: 'Header 6', block: 'h6' }
    ] },

    { title: 'Blocks', items: [
      { title: 'Paragraph', block: 'p' },
      { title: 'div', block: 'div' },
      { title: 'Preformatted', block: 'pre' }
    ] },

    { title: 'Containers', items: [
      { title: 'section', block: 'section', wrapper: true, merge_siblings: false },
      { title: 'article', block: 'article', wrapper: true, merge_siblings: false },
      { title: 'blockquote', block: 'blockquote', wrapper: true },
      { title: 'hgroup', block: 'hgroup', wrapper: true },
      { title: 'aside', block: 'aside', wrapper: true },
      { title: 'figure', block: 'figure', wrapper: true }
    ] }
  ],
  content_css: [
    '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
    '//www.tinymce.com/css/codepen.min.css'
  ],

  //Local image uploading settings
  file_picker_types: 'image',
  automatic_uploads: true,
  //images_upload_url: '...', //TODO: PHP Script. Must return JSON {'location': 'image_url_on_server'}


  // Custom image picker (TODO: Understand this properly)
  file_picker_callback: function(cb, value, meta) {
    var input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');

    // Note: In modern browsers input[type="file"] is functional without
    // even adding it to the DOM, but that might not be the case in some older
    // or quirky browsers like IE, so you might want to add it to the DOM
    // just in case, and visually hide it. And do not forget do remove it
    // once you do not need it anymore.

    input.onchange = function() {
      var file = this.files[0];

      var reader = new FileReader();
      reader.onload = function () {
        // Note: Now we need to register the blob in TinyMCEs image blob
        // registry. In the next release this part hopefully won't be
        // necessary, as we are looking to handle it internally.
        var id = 'blobid' + (new Date()).getTime();
        var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
        var base64 = reader.result.split(',')[1];
        var blobInfo = blobCache.create(id, file, base64);
        blobCache.add(blobInfo);

        // call the callback and populate the Title field with the file name
        cb(blobInfo.blobUri(), { title: file.name });
      };
      reader.readAsDataURL(file);
    };

    input.click();
  }
 });
