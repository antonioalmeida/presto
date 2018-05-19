<header>
    <nav class="navbar navbar-expand fixed-top navbar-light bg-light">
        <div class="container">
            <ul class="navbar-nav">
                <li class="nav-item pr-2">
                    <a class="nav-link text-mobile" role="button" data-toggle="offcanvas">
                        <i class="far fa-bars"></i>
                    </a>
                </li>
                <a class="navbar-brand" href="admin"><h4>Presto</h4></a>
            </ul>
            <div class="navbar-collapse" id="navbarsExampleDefault">
                <ul class="navbar-nav ml-auto align-items-end">
                </ul>
                <ul class="navbar-nav align-items-end">
                    <li class="nav-item dropdown">
                        <a class="" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                           aria-haspopup="true" aria-expanded="false">
                            <img src="https://imgur.com/97aEK9a.jpeg" width="40px" height="40px"
                                 class="rounded-circle border border-primary profile-photo">
                        </a>
                        <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="profilesettings.html"><i
                                        class="far text-muted fa-fw fa-cog"></i> Settings</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="{{Route('admin.logout')}}"><i
                                        class="far text-muted fa-fw fa-sign-out"></i> Logout</a>
                        </div>
                    </li>

                </ul>
            </div>
        </div>
    </nav>
</header>