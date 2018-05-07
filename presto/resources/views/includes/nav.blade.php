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
          <ul class="navbar-nav mr-auto">

          </ul>
          <div>
            <a href={{Route('login')}}><button class="btn btn-link">Login</button></a>
            <a href={{Route('signup')}}><button class="btn btn-primary">Sign Up</button></a>
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
            <form method="POST" action="">
                    {{ csrf_field() }}
              <div class="input-group">
                <a id="nav-search-btn" class="nav-link" href="#" role="button"><i class="far fa-search"></i></a>
                <input name="text_search" id="nav-search-bar" type="text" class="form-control" placeholder="Search Presto" aria-label="search query" aria-describedby="basic-addon2">
                <input type="hidden" name="limit_date" value="<?=date('Y-m-d H:i:s', strtotime('1 January 1970'))?>" />
                <input type="hidden" name="type" value="questions" />
              </div>
            </form>

            </li>

          <li class="nav-item pr-2 dropdown">
              <a class="nav-link" href="#" id="notificationsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="far fa-bell"></i></a>
              <div class="dropdown-menu dropdown-menu-right" aria-labelledby="notificationsDropdown">
                <div id="notificationsMenu">
                <!-- <a class="dropdown-item" href="#"><span class="text-muted">No Unread Notifications</span></a> -->
                </div>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="{{Route('notifications')}}">See All Notifications</a>
              </div>
          </li>

            <li class="nav-item dropdown">
              <a class="" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <img src="{{Auth::user()->profile_picture}}" width="40px" height="40px" class="rounded-circle border border-primary profile-photo">
              </a>
              <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                <router-link class="dropdown-item" to="/profile/{{Auth::user()->username}}"><i class="far text-muted fa-fw fa-user"></i> Profile</router-link>
                <a class="dropdown-item" href={{Route('settings')}}><i class="far text-muted fa-fw fa-cog"></i> Settings</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="{{Route('logout')}}"><i class="far text-muted fa-fw fa-sign-out"></i> Logout</a>
              </div>
            </li>
          </ul>
        </div>
      @endguest
    </div>
  </nav>
</header>

