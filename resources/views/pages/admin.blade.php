@extends('layouts.master_aux')

@section('title')
    Admin | Presto
@endsection

@include('includes.nav_admin')

@section('content')

    <body class="grey-background">
     <main role="main">
    <div class="container pt-1 mt-2">
      <div class="row">
        <div class="col-md-2 mt-2">
          <div class="offcanvas-collapse" id="navbarsExampleDefault">
            <h4 class="pt-4">Users</h4>
            <ul class="nav flex-column panel-options">
              <li class="nav-item">
                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true"><i class="far fa-fw fa-user text-icon"></i> List</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false"><i class="far fa-fw fa-flag text-icon"></i> Flagged</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-recommended-tab" data-toggle="tab" href="#nav-recommended" role="tab" aria-controls="nav-recommended" aria-selected="false"><i class="far fa-fw fa-ban text-icon"></i> Banned</a>
              </li>
            </ul>

            <h4 class="pt-4">Others</h4>
            <ul class="nav flex-column panel-options">
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true"><i class="far fa-fw fa-id-badge text-icon"></i> Moderators</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false"><i class="far fa-fw fa-flag text-icon"></i> Certified</a>
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
                    <input type="text" id="userName" class="form-control" placeholder="Search for users" required="" autofocus="">
                    <div class="input-group-append">
                      <button class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a href="" class="text-danger">Ban</a> |
                        <a href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-md-6 offset-md-3 d-flex justify-content-center">
                <nav aria-label="Page navigation example">
                  <ul class="pagination justify-content-center">
                    <li class="page-item disabled">
                      <a class="page-link" href="#" tabindex="-1">Previous</a>
                    </li>
                    <li class="page-item active"><a class="page-link" href="#">1</a></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item">
                      <a class="page-link" href="#">Next</a>
                    </li>
                  </ul>
                </nav>
              </div>
            </section>
          </div>
          <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
            <div class="d-flex justify-content-center">
              <div class="">
                <div class="input-group">
                  <label for="userName" class="sr-only">Search Users</label>
                  <input type="text" id="userName" class="form-control" placeholder="Search for users" required="" autofocus="">
                  <div class="input-group-append">
                    <button class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                  <tr>
                    <td>antonioalmeida</td>
                    <td>António Almeida</td>
                    <td>"Slept too much"</td>
                    <td class="admin-actions">
                      <a href="" class="text-danger">Ban</a> |
                      <a href="" class="text-info">Dismiss</a>
                    </td>
                  </tr>
                </tbody>
              </table>
</div>
</div>
          <div class="tab-pane fade" id="nav-recommended" role="tabpanel" aria-labelledby="nav-recommended-tab">
            <section class="pb-3">
              <div class="d-flex justify-content-center">
                <div class="">
                  <div class="input-group">
                    <label for="userName" class="sr-only">Search Users</label>
                    <input type="text" id="userName" class="form-control" placeholder="Search for users" required="" autofocus="">
                    <div class="input-group-append">
                      <button class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                    <tr>
                      <td>antonioalmeida</td>
                      <td>António Almeida</td>
                      <td>antonio@presto.com</td>
                    </tr>
                  </tbody>
                </table>
              </div>
          </div>
        </div>
      </div>
</main>
</body>

    <!-- /.container -->
    </body>

@endsection

@include('includes.footer')
