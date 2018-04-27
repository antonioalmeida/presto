<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="icon" href="favicon.ico">

  <meta name="google-signin-client_id" content="266862467671-5lbu1466hug0nb8naoqbvo3kq7uj4s1d.apps.googleusercontent.com">
  <!-- google platform -->
  <script src="https://apis.google.com/js/platform.js?onload=renderButton" async defer></script>
  <!-- facebook sdk -->
  <div id="fb-root"></div>

  <!-- CSRF Token -->
  <meta name="csrf-token" content="{{ csrf_token() }}">

  <title>@yield('title')</title>

  <!-- Styles -->
  <link href="{{ asset('css/app.css') }}" rel="stylesheet">
  <script type="text/javascript">
      // Fix for Firefox autofocus CSS bug
      // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951
  </script>

    <!-- bootstrap -->
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"
    integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
    crossorigin="anonymous"></script>
    <script defer src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
    <script defer src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>

    <script defer src="{{ asset('js/tinymce/tinymce.min.js') }}"></script>
    <script defer src="{{ asset('js/app.js') }}"></script>
</head>

@include('includes.errors')

@yield('content')

</html>
