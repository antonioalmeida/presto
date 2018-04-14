@extends('layouts.master')

@section('title')
    Settings | Presto
@endsection

@section('content')

    <body class="grey-background">

    <main role="main" class="mt-5">
        <div class="container mt-5">

            <!-- account -->
            <div class="mb-5 p-1">
                <h4>Account</h4>
                <hr>
                <div class="row">
                    <div class="col-md-3 col-sm-6 py-2">
                        <h6>Email</h6>
                    </div>
                    <div class="col-md-9 col-sm-6 py-2">
                        <span>{{Auth::User()->email}}</span>
                        <br>
                        <a href="">Change Email</a>
                    </div>
                </div>
                <br>
                <hr>
                <div class="row">
                    <div class="col-md-3 py-2 col-sm-6">
                        <h6>Password</h6>
                    </div>
                    <div class="col-md-9 py-2 col-sm-6">
                        <a href="" data-toggle="modal" data-target="#changePasswordModal"> Change Password</a>
                    </div>
                </div>
            </div>

            <div class="p-1">
                <h4>Connected Accounts</h4>
                <hr>
                <div class="row">
                    <div class="col-md-3 col-sm-6 py-2">
       <span>
        <span class="fa-layers fa-fw">
          <i class="fas fa-square" style="color:#4885ed"></i>
          <i class="fa-inverse fab fa-google" data-fa-transform="shrink-6"></i>
        </span>
        <strong>Google</strong></span>
                    </div>
                    <div class="col-md-9 col-sm-6 py-2">
                        <button class="btn btn-google"><i class="fab fa-fw fa-google"></i> Connect Google</button>
                    </div>
                </div>
                <br>
                <hr>
                <div class="row">
                    <div class="col-md-3 col-sm-6 py-2">
                        <span><i class="fab fa-fw fa-facebook text-facebook" aria-hidden="true"></i> <strong>Facebook</strong></span>
                    </div>
                    <div class="col-md-9 col-sm-6 py-2">
                        <button class="btn btn-facebook"><i class="fab fa-fw fa-facebook-f"></i> Connect Facebook</button>
                    </div>
                </div>
            </div>
        </div>
    </main><!-- /.container -->


    <!-- /.container -->
    </body>

@endsection
