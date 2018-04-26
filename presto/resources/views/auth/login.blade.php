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
              <h1 class="text-center">Welcome back.</h1>
              <p class="lead">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras et nibh ac massa tristique semper.</p>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6 offset-lg-2 col-lg-4 d-flex flex-column align-items-center">
            <form method="POST" action="/login">
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
          <div class="col-md-6 col-lg-4 d-flex flex-column align-items-center mb-5">
            <div class="m-2 g-signin2" data-width="254" data-height="40" data-longtitle="true"></div>
            <div class="fb-login-button m-2" data-max-rows="1" data-size="large" data-button-type="continue_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="false"></div>
          </div>
        </div>
      </div>
    </section>
  </main>
  <!-- /.container -->
  </body>

@endsection
