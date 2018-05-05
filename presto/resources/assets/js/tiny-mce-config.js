export default {
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
    ] }]
};

