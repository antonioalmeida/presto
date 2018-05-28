@extends('layouts.master_aux')

@section('title')
    Admin | Presto
@endsection

@include('includes.nav_admin')

@section('content')

    <body class="grey-background">
    <main >
        <div class="container pt-1 mt-2">
            <div class="row">
                <div class="col-md-2 mt-2">
                    <div class="offcanvas-collapse" id="navbarsExampleDefault">
                        <ul class="nav flex-column panel-options">
                            <li><h4 class="pt-4">Users</h4></li>
                            <li class="nav-item">
                                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home"
                                   role="tab" aria-controls="nav-home" aria-selected="true"><i
                                            class="far fa-fw fa-user text-icon"></i> List</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile"
                                   role="tab" aria-controls="nav-profile" aria-selected="false"><i
                                            class="far fa-fw fa-flag text-icon"></i> Flagged</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-item nav-link" id="nav-recommended-tab" data-toggle="tab"
                                   href="#nav-recommended" role="tab" aria-controls="nav-recommended"
                                   aria-selected="false"><i class="far fa-fw fa-ban text-icon"></i> Banned</a>
                            </li>

                            <li><h4 class="pt-4">Others</h4></li>
                            <li class="nav-item">
                                <a class="nav-item nav-link" id="nav-moderators-tab" data-toggle="tab"
                                   href="#nav-moderators" role="tab" aria-controls="nav-moderators"
                                   aria-selected="true"><i class="far fa-fw fa-id-badge text-icon"></i> Moderators</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-item nav-link" id="nav-certified-tab" data-toggle="tab"
                                   href="#nav-certified" role="tab" aria-controls="nav-certified" aria-selected="false"><i
                                            class="far fa-fw fa-flag text-icon"></i> Certified</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-10 tab-content my-5" id="nav-tabContent">
                    <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
                        <section class="pb-3">
                            <div class="d-flex justify-content-center">
                                <div class="">
                                    <div class="input-group">
                                        <label for="userName" class="sr-only">Search Users</label>
                                        <input type="text" id="userName" class="form-control"
                                               placeholder="Search for users" autofocus="">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary" type="button"><i
                                                        class="fas fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-3 table-responsive">
                                <table class="table table-hover admin-table">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th scope="col">Username</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Email</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($members as $member)
                                        <tr>
                                            <td>{{$member->username}}</td>
                                            <td>{{$member->name}}</td>
                                            <td>{{$member->email}}</td>
                                            <td class="admin-actions">
                                                <a href="" class="text-muted">Edit</a> |
                                                <a href="" class="text-danger">Ban</a> |
                                                <a href="" class="text-info">Promote</a>
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                            {{ $members->links('pagination.default') }}
                        </section>
                    </div>
                    <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
                        <section class="pb-3">
                            <div class="d-flex justify-content-center">
                                <div class="">
                                    <div class="input-group">
                                        <label for="userName" class="sr-only">Search Users</label>
                                        <input type="text" id="userName" class="form-control"
                                               placeholder="Search for users" autofocus="">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary" type="button"><i
                                                        class="fas fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-3 table-responsive">
                                <table class="table table-hover admin-table">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th scope="col">Reported username</th>
                                        <th scope="col">Moderator</th>
                                        <th scope="col">Reason</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($flagged as $flag)
                                        <tr>
                                            <td>{{$flag->member->username}}</td>
                                            <td>{{$flag->moderator->username}}</td>
                                            <td>{{$flag->reason}}</td>
                                            <td class="admin-actions">
                                                <a href="" class="text-danger">Ban</a> |
                                                <a href="" class="text-info">Dismiss</a>
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                    <div class="tab-pane fade" id="nav-recommended" role="tabpanel"
                         aria-labelledby="nav-recommended-tab">
                        <section class="pb-3">
                            <div class="d-flex justify-content-center">
                                <div class="">
                                    <div class="input-group">
                                        <label for="userName" class="sr-only">Search Users</label>
                                        <input type="text" id="userName" class="form-control"
                                               placeholder="Search for users" autofocus="">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary" type="button"><i
                                                        class="fas fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-3 table-responsive">
                                <table class="table table-hover admin-table">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th scope="col">Username</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Email</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($banned as $member)
                                        <tr>
                                            <td>{{$member->username}}</td>
                                            <td>{{$member->name}}</td>
                                            <td>{{$member->email}}</td>
                                            <td class="admin-actions">
                                                <a href="" class="text-muted">Edit</a> |
                                                <a href="" class="text-danger">Ban</a> |
                                                <a href="" class="text-info">Promote</a>
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                    <div class="tab-pane fade" id="nav-moderators" role="tabpanel" aria-labelledby="nav-moderators-tab">
                        <section class="pb-3">
                            <div class="d-flex justify-content-center">
                                <div class="">
                                    <div class="input-group">
                                        <label for="userName" class="sr-only">Search Users</label>
                                        <input type="text" id="userName" class="form-control"
                                               placeholder="Search for users" autofocus="">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary" type="button"><i
                                                        class="fas fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-3 table-responsive">
                                <table class="table table-hover admin-table">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th scope="col">Username</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Email</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($moderators as $member)
                                        <tr>
                                            <td>{{$member->username}}</td>
                                            <td>{{$member->name}}</td>
                                            <td>{{$member->email}}</td>
                                            <td class="admin-actions">
                                                <a href="" class="text-danger">Ban</a> |
                                                <a href="" class="text-info">Dismiss</a>
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                    <div class="tab-pane fade" id="nav-certified" role="tabpanel" aria-labelledby="nav-moderators-tab">
                        <section class="pb-3">
                            <div class="d-flex justify-content-center">
                                <div class="">
                                    <div class="input-group">
                                        <label for="userName" class="sr-only">Search Users</label>
                                        <input type="text" id="userName" class="form-control"
                                               placeholder="Search for users" autofocus="">
                                        <div class="input-group-append">
                                            <button class="btn btn-outline-primary" type="button"><i
                                                        class="fas fa-search"></i></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="my-3 table-responsive">
                                <table class="table table-hover admin-table">
                                    <thead class="thead-dark">
                                    <tr>
                                        <th scope="col">Username</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Email</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    @foreach($certified as $member)
                                        <tr>
                                            <td>{{$member->username}}</td>
                                            <td>{{$member->name}}</td>
                                            <td>{{$member->email}}</td>
                                            <td class="admin-actions">
                                                <a href="" class="text-muted">Edit</a> |
                                                <a href="" class="text-danger">Ban</a> |
                                                <a href="" class="text-info">Promote</a>
                                            </td>
                                        </tr>
                                    @endforeach
                                    </tbody>
                                </table>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
    </main>
    </body>

    <!-- /.container -->
    </body>

@endsection

@include('includes.footer')
