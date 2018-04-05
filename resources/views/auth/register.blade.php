@extends('layouts.master_aux')

@section('title')
Sign up | Presto
@endsection

@section('content')

<body class="img-background">
  <main role="main" class="mt-5">
    <section class="container">
      <div class="card my-3 py-3">
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 offset-md-3">
              <h1 class="text-center">Join Presto.</h1>
              <p class="lead">Create an account to access your personalized feed, follow your favorite writers and help contribute to the world's knowledge.</p>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="offset-lg-2 mb-2 col-md-6 col-lg-4 d-flex flex-column align-items-center">
            <form id="signupForm" method="POST" action="/signup">
              {{ csrf_field() }}

              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="far fa-user"></i></div>
                </div>
                <input type="text" class="form-control" id="inlineFormInputGroup" placeholder="Your Nickname">
              </div>
              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="far fa-at"></i></div>
                </div>
                <input type="text" class="form-control" id="inlineFormInputGroup" placeholder="your@email.com">
              </div>
              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="far fa-key"></i></div>
                </div>
                <input type="password" name="password" class="form-control" id="inlineFormInputGroup" placeholder="Password">
              </div>
              <div class="input-group mb-2">
                <div class="input-group-prepend">
                  <div class="input-group-text"><i class="fas fa-key"></i></div>
                </div>
                <input type="password" class="form-control" id="inlineFormInputGroup" placeholder="Confirm Password">
              </div>
              <div class="form-check mb-2 mx-1">
                <input class="form-check-input" type="checkbox" value="" id="defaultCheck1">
                <label class="form-check-label" for="defaultCheck1">
                  <small>I accept Presto's <a href="">Terms and Conditions</a>.</small>
                </label>
              </div>
              <div class="d-flex justify-content-center">
                <button class="btn btn-primary">Sign Up</button>
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
