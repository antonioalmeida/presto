@extends('layouts.master_aux')

@section('title')
    Presto
@endsection

@section('content')

<body class="">

<main role="main" class="mt-5">

  <section class="container mt-5 pt-5 d-flex justify-content-center">

    <div class="align-self-center">
          <div>
            <h1 class="display-1">404</h1>
            <h2><small>The page you were looking for was not found.</small></h2>
              <a href="{{route('index')}}"><button class="m-2 btn  btn-primary">Home</button></a>
      </div>
    </div>
  </section>

</main><!-- /.container -->

</body>

@endsection
