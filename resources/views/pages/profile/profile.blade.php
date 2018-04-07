<section>
    <div class="jumbotron profile-jumbotron">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <img class="profile-pic img-fluid rounded-circle m-2" src="assets/img/portrait-man.jpeg"/>
                </div>

                <div class="col-md-6 text-shadow mobile-center">
                    <h2 class="h2-adapt">António Almeida</h2>
                    <h4 class="h4-adapt">@antonioalmeida</h4>

                    <!-- bio -->
                    <div class="bio mt-3">
                        <div class="d-flex justify-content-sm-start justify-content-around">
                            <a href="{{Route('followers', 'antonioalmeida')}}"><h5 class="p-2 h5-adapt">632 <small>followers</small></h5></a>
                            <a href="{{Route('following', 'antonioalmeida')}}"><h5 class="p-2 h5-adapt">190 <small>following</small></h5></a>
                        </div>
                        <p class="lead lead-adapt">
                            This platform is awesome, the best I've ever seen.
                        </p>
                        @auth
                        <a href="{{Route('edit', 'antonioalmeida')}}" class="btn btn-outline-light">Edit Profile</a>
                        @endauth
                    </div>

                </div>

                <div class="col-md-3 mt-3">
                    <div class="card card-body">
                        <h5 class="text-dark">Stats</h5>
                        <div class="dropdown-divider"></div>
                        <div class="d-flex flex-column justify-content-around flex-wrap">
                            <div class="d-flex p-1">
                                <div class="mx-2">
                                    <a href="#"><i class="fa fa-gem"></i></a>
                                </div>
                                <h6>1.6k <small class="text-muted">points</small></h6>
                            </div>
                            <div class="d-flex p-1">
                                <div class="mx-2">
                                    <i class="far fa-fw fa-eye"></i>
                                </div>
                                <h6>23k <small class="text-muted">answer views</small></h6>
                            </div>
                            <div class="d-flex p-1">
                                <div class="mx-2">
                                    <i class="far fa-fw fa-question"></i>
                                </div>
                                <h6>55 <small class="text-muted">questions</small></h6>
                            </div>
                            <div class="d-flex p-1">
                                <div class="mx-2">
                                    <i class="far fa-fw fa-book"></i>
                                </div>
                                <h6>63 <small class="text-muted">answers</small></h6>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>