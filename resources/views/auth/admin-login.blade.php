@extends('layouts.master_aux')

@section('title')
  Login | Presto
@endsection

@section('content')

  <body class="img-background">
  <main role="main" class="mt-5">
    <section class="container">
      <div class="card py-5 my-5">
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 offset-md-3">
              <h1 class="text-center">Welcome Administrator.</h1>
              <p class="lead">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.</p>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6 offset-lg-4 col-lg-4 d-flex flex-column align-items-center">
            <form method="POST" action="{{Route('admin.login.submit')}}">
              {{ csrf_field() }}
              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="far fa-at"></i></div>
                </div>
                <input name="email" type="text" class="form-control" id="inlineFormInputGroup" placeholder="your@email.com" required>
              </div>
              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="far fa-key"></i></div>
                </div>
                <input name="password" type="password" class="form-control" id="inlineFormInputGroup" placeholder="Password" required>
              </div>
              <div class="d-flex justify-content-center">
                <button type="submit" class="btn btn-primary">Login</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </section>
  </main>
  <!-- /.container -->
  </body>

@endsection
