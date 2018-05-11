<template>
   
    <body class="grey-background">
    <main role="main">
    <div class="container pt-4 mt-2">
      <div class="row">
        <div class="col-md-2 mt-2">
          <div class="offcanvas-collapse" id="navbarsExampleDefault">
            <ul class="nav flex-column panel-options">
              <li><h4 class="pt-4">Users</h4></li>
              <li class="nav-item">
                <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true"><i class="far fa-fw fa-user text-icon"></i> List</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-profile-tab" data-toggle="tab" href="#nav-profile" role="tab" aria-controls="nav-profile" aria-selected="false"><i class="far fa-fw fa-flag text-icon"></i> Flagged</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-recommended-tab" data-toggle="tab" href="#nav-recommended" role="tab" aria-controls="nav-recommended" aria-selected="false"><i class="far fa-fw fa-ban text-icon"></i> Banned</a>
              </li>

              <li><h4 class="pt-4">Others</h4></li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-moderators-tab" data-toggle="tab" href="#nav-moderators" role="tab" aria-controls="nav-moderators" aria-selected="true"><i class="far fa-fw fa-id-badge text-icon"></i> Moderators</a>
              </li>
              <li class="nav-item">
                <a class="nav-item nav-link" id="nav-certified-tab" data-toggle="tab" href="#nav-certified" role="tab" aria-controls="nav-certified" aria-selected="false"><i class="far fa-fw fa-flag text-icon"></i> Certified</a>
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
                    <input v-on:keyup="filterBar" type="text" id="userName" class="form-control" placeholder="Search for users" autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButton" class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="user in users">
                      <td>{{user.username}}</td>
                      <td>{{user.name}}</td>
                      <td>{{user.email}}</td>
                      <td class="admin-actions">
                        <a href="" class="text-muted">Edit</a> |
                        <a v-on:click="banUser(user,$event)" href="" class="text-danger">Ban</a> |
                        <a v-on:click="toggleModerator" href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </section>
          </div>
          <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
            <section class="pb-3">
              <div class="d-flex justify-content-center">
                <div class="">
                  <div class="input-group">
                    <label for="userName" class="sr-only">Search Users</label>
                    <input v-on:keyup="filterBar" type="text" id="userName" class="form-control" placeholder="Search for users" autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButton" class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="flag in flagged">
                      <td>{{flag.member.username}}</td>
                      <td>{{flag.moderator.username}}</td>
                      <td>{{flag.reason}}</td>
                      <td class="admin-actions">
                        <a v-on:click="banUser(flag, $event)" href="" class="text-danger">Ban</a> |
                        <a v-on:click="dismissFlag(flag, $event)" href="" class="text-info">Dismiss</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </section>
          </div>
          <div class="tab-pane fade" id="nav-recommended" role="tabpanel" aria-labelledby="nav-recommended-tab">
            <section class="pb-3">
              <div class="d-flex justify-content-center">
                <div class="">
                  <div class="input-group">
                    <label for="userName" class="sr-only">Search Users</label>
                    <input v-on:keyup="filterBar" type="text" id="userName" class="form-control" placeholder="Search for users" autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButton"  class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="user in banned">
                      <td>{{user.username}}</td>
                      <td>{{user.name}}</td>
                      <td>{{user.email}}</td>
                    </tr>
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
                    <input v-on:keyup="filterBar" type="text" id="userName" class="form-control" placeholder="Search for users"  autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButton" class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="user in moderators">
                      <td>{{user.username}}</td>
                      <td>{{user.name}}</td>
                      <td>{{user.email}}</td>
                      <td class="admin-actions">
                        <a v-on:click="banUser" href="" class="text-danger">Ban</a> |
                        <a v-on:click="toggleModerator" href="" class="text-info">Dismiss</a>
                      </td>
                    </tr>
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
                    <input v-on:keyup="filterBar" type="text" id="userName" class="form-control" placeholder="Search for users" autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButton" class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="user in certified">
                      <td>{{user.username}}</td>
                      <td>{{user.name}}</td>
                      <td>{{user.email}}</td>
                      <td class="admin-actions">ss="admin-actions">
                        <a v-on:click="banUser" href="" lass="text-danger">Ban</a> |
                        <a v-on:click="toggleModerator" href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </section>
          </div>
        </div>
        </div>
      </div>
    </main>
  
    <!-- /.container -->
    </body>
</template>

<script>
export default {

  data () {
    return {
      users: {},
      flagged: {},
      banned: {},
      moderators: {},
      certified: {}
    }
  },

  mounted() {
    this.loader = this.$loading.show();
    this.getData();
  },

  methods: {
    getData: function(){
      this.getUsers();
      this.getFlagged();
      this.getBanned();
      this.getModerators();
      this.getCertified();
    },

    getUsers: function(){
      console.log("Getting users");

      axios.get('/api/admin/get-users')
        .then(({data}) => {
            console.log("Done getting users");
            this.users = data;
        })
        .catch((error) => {
            console.log(error);
        });
    },

    getFlagged: function(){
      console.log("Getting flagged");
      axios.get('/api/admin/get-flagged')
        .then(({data}) => {
            console.log("Done getting flags");
            this.flagged = data;
        })
        .catch((error) => {
            console.log(error);
        });
    },

    getBanned: function(){
      console.log("Getting banned...");
      axios.get('/api/admin/get-banned')
        .then(({data}) => {
            console.log("Done getting banned");
            this.banned = data;
        })
        .catch((error) => {
            console.log(error);
        });
    },

    getModerators: function(){
      console.log("Getting moderators");
      axios.get('/api/admin/get-moderators')
        .then(({data}) => {
            console.log("Done getting moderators");
            this.moderators = data;
        })
        .catch((error) => {
            console.log(error);
        });
    },

    getCertified: function(){
      console.log("Getting certified");
      axios.get('/api/admin/get-certified')
        .then(({data}) => {
            console.log("Done getting certified");
            this.certified = data;
            this.loader.hide();
        })
        .catch((error) => {
            console.log(error);
        });
    },

    banUser(user,e){

      console.log("Banning user");
      e.preventDefault();

      console.log(user);
      console.log(this.users.indexOf(user));
    },

    toggleModerator(e){
      e.preventDefault();
      console.log("Toggle Mod");
      let userName = e.target.closest("tr").children[0].innerHTML;
      console.log(userName);

      /*
      axios.post('/api/members/'+userName+'/promote')
        .then(({data}) => {
          console.log(data);
        })
        .catch((error) => {
            console.log(error);
        });
      */
    },

    dismissFlag(flag,e){
      e.preventDefault();

      console.log(flag.member['id']+"  "+flag.moderator['id']);


      axios.delete('/api/flags/'+flag.member['id']+'/'+flag.moderator['id']+'/dismiss')
        .then(({data}) => {
          console.log(data);
        })
        .catch((error) => {
            console.log(error);
        });     

      this.flagged.splice(this.flagged.indexOf(flag),1);
    },

    filter(searchField){
      let section = searchField.closest("section");
      let tr = section.querySelectorAll("tbody > tr")
      
      let search = new RegExp(searchField.value,'i');

      for(let j=0;j<tr.length;j++){

        if(searchField.value != ""){  
          if(search.test(tr[j].children[0].innerHTML+" "+tr[j].children[1].innerHTML))
            tr[j].style.display="";
          else
              tr[j].style.display="none";
        }
        else{
           tr[j].style.display="";
        }
      }
    },

    filterBar(){
      filter(this);
    },

    filterButton(){
      let searchBar = this.closest(".input-group").children[1];
      filter(searchField);
    }
  }
}

</script>
