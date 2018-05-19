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
                        <a href="" data-toggle="modal" data-target="#editEmail">Change Email</a>
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
                        <span><i class="fab fa-fw fa-facebook text-facebook"
                                 aria-hidden="true"></i> <strong>Facebook</strong></span>
                    </div>
                    <div class="col-md-9 col-sm-6 py-2">
                        <button class="btn btn-facebook"><i class="fab fa-fw fa-facebook-f"></i> Connect Facebook
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main><!-- /.container -->


    <!-- /.container -->
    </body>

    <!-- edit e-mail modal -->
    <div class="modal fade" id="editEmail" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="POST" action="{{ Route('api.edit-email', Auth::User())}}">
                    {{ method_field('PUT') }}
                    {{ csrf_field() }}
                    <div class="modal-body">
                        <div>
                            <h6><label for="email">Change your E-Mail</label></h6>
                            <div class="input-group">
                                <input type="email" name="email" class="form-control" placeholder="New E-Mail"
                                       aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- edit password modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form method="POST" action="{{ Route('api.edit-password', Auth::User())}}">
                    {{ method_field('PUT') }}
                    {{ csrf_field() }}
                    <div class="modal-body">
                        <div>
                            <h6><label for="password">Change your password</label></h6>
                            <div class="input-group">
                                <input type="password" name="password" class="form-control" placeholder="New password"
                                       aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection
