<header>
    <nav class="navbar navbar-expand fixed-top navbar-light bg-light">
        <div class="container">
            <router-link class="navbar-brand" :to="'/'">
                <h4>Presto</h4>
            </router-link>
            <button class="navbar-toggler p-0 border-0" type="button" data-toggle="offcanvas">
                <span class="navbar-toggler-icon"></span>
            </button>
            @guest
                <div class="navbar-collapse navbar-collapse" id="navbarsExampleDefault">
                    <ul class="navbar-nav mr-auto ">

                    </ul>

                    <ul class="navbar-nav align-items-end">
                        <li class="nav-item pr-2">
                            <search-bar></search-bar>
                        </li>
                    </ul>
                    <div>
                        <a href="{{Route('login')}}"
                           class="btn btn-link">Login
                        </a>
                        <a href="{{Route('signup')}}" class="btn btn-primary">Sign Up
                        </a>
                    </div>
                </div>
            @else
                <div class="navbar-collapse" id="navbarsExampleDefault">
                    <ul class="navbar-nav ml-auto align-items-end">
                        <li class="nav-item pr-2">
                            <b-btn variant="primary" v-b-modal.modal>
                                <i class="far fa-plus"></i> <span class="text-collapse">Add Question</span>
                            </b-btn>
                        </li>
                    </ul>
                    <ul class="navbar-nav align-items-end">
                        <li class="nav-item pr-2">
                            <search-bar></search-bar>
                        </li>

                        <li class="nav-item pr-2 dropdown">
                            <a class="nav-link" href="#" id="notificationsDropdown" role="button" data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false"><i class="far fa-bell"></i></a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="notificationsDropdown">
                                <div id="notificationsMenu">
                                    <!-- <a class="dropdown-item" href="#"><span class="text-muted">No Unread Notifications</span></a> -->
                                </div>
                                <div class="dropdown-divider"></div>
                                <router-link to="/notifications" class="text-center dropdown-item">See All Notifications
                                </router-link>
                            </div>
                        </li>

                        <li class="nav-item dropdown">
                            <a class="" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                               aria-haspopup="true" aria-expanded="false">
                                <img src="{{Auth::user()->profile_picture}}" alt="Your profile picture" class="rounded-circle border border-primary profile-photo">
                            </a>
                            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                                <router-link class="dropdown-item" to="/profile/{{Auth::user()->username}}"><i
                                            class="far text-muted fa-fw fa-user"></i> Profile
                                </router-link>
                                <router-link class="dropdown-item" to="/settings"><i
                                            class="far text-muted fa-fw fa-cog"></i> Settings
                                </router-link>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="{{Route('logout')}}"><i
                                            class="far text-muted fa-fw fa-sign-out"></i> Logout</a>
                            </div>
                        </li>
                    </ul>
                </div>
            @endguest
        </div>
    </nav>
</header>
