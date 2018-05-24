<template>
   
    <main class="grey-background" role="main">
    <div class="container pt-4 mt-4">
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
                    <input v-on:keyup="filterBarAllUsers" type="text" id="userName" class="form-control" placeholder="Search for users" autofocus="">
                    <div class="input-group-append">
                      <button v-on:click="filterButtonAllUsers" class="btn btn-outline-primary" type="button"><i class="fas fa-search"></i></button>
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
                    <tr v-for="user in users.data">
                      <td>{{user.username}}</td>
                      <td>{{user.name}}</td>
                      <td>{{user.email}}</td>
                      <td class="admin-actions">
                        <a v-on:click="banUser(user,$event)" href="" class="text-danger">Ban</a> |
                        <a v-if="user.is_moderator == true" v-on:click="toggleModerator(user,$event)" href="" class="text-info">Demote</a>
                        <a v-else v-on:click="toggleModerator(user,$event)" href="" class="text-info">Promote</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="col-md-6 offset-md-3 d-flex justify-content-center pt-4">
                <pagination :data="users" @pagination-change-page="getUsers"></pagination>
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
                        <a v-on:click="banFlagged(flag, $event)" href="" class="text-danger">Ban</a> |
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
                        <a v-on:click="banUser(user,$event)" href="" class="text-danger">Ban</a> |
                        <a v-on:click="toggleModerator(user,$event)" href="" class="text-info">Demote</a>
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
                        <a v-on:click="banUser(user,$event)" href="" lass="text-danger">Ban</a> |
                        <a v-on:click="toggleModerator(user,$event)" href="" class="text-info">Promote</a>
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
</template>

<script>
export default {

  data () {
    return {
      users: {},
      flagged: {},
      banned: {},
      moderators: {},
      certified: {},
      query: ""
    }
  },

  components: {
    'pagination': require('laravel-vue-pagination')
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

    getUsers: function(page = 1){
      console.log("Getting users");

      axios.get('/api/admin/get-users?query='+this.query+'&page='+page)
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
            console.log("Done getting buttonanned");
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

    findUser(list, userName){
      for(let i=0;i<list.length;i++){
        if(list[i].username == userName)
          return {'user': list[i], 'pos': i};
      }

      return {'user': null, 'pos': -1};
    },

    ban(userName){
      let index, user, res;

      //Remove from all users
      res = this.findUser(this.users.data,userName);
      console.log(res.pos);
      if(res.pos != -1){
        user = res.user;
        this.getUsers(1);
      }

      //Remove related flags
      for(let i=0;i<this.flagged.length;i++){
        if(this.flagged[i].member.username === userName){
          this.dismiss(this.flagged[i]);
          this.flagged.splice(i,1);
          i--;
        }
      }

      //Remove from moderators
      res = this.findUser(this.moderators,userName);
      if(res.pos != -1){
        user = res.user;
        this.moderators.splice(index,1);
      }
      console.log(res.pos);

      //Remove from certified
      res = this.findUser(this.moderators,userName);
      if(res.pos != -1){
        user = res.user;
        this.certified.splice(index,1);
      }
      console.log(res.pos);

      if(user == null)
        this.getBanned();
      else
        this.banned.splice(this.banned.length,0,user);
    },

    //When user is banned from all_users/moderators/certified tabs
    banUser(user,e){
      e.preventDefault();
      console.log("Banning user");
      console.log(user.username);

      axios.post('/api/members/'+user.username+'/ban')
        .then(() => {
          this.ban(user.username);
        })
        .catch((error) => {
            console.log(error);
        });
    },

    //When user is banned from the flagged tab
    banFlagged(flag,e){
      e.preventDefault();
      console.log("Banning flagged user");
      console.log(flag.member.username);

      axios.post('/api/members/'+flag.member.username+'/ban')
        .then(({data}) => {
          console.log(data);
          this.ban(flag.member.username);
        })
        .catch((error) => {
            console.log(error);
        });
    },

    toggle_moderator(userName,modStatus){
      let index, res;
      console.log(modStatus);

      //Update user in all users
      res = this.findUser(this.users.data,userName);
      if(res.pos != -1){
        res.user.is_moderator = modStatus;
      }

      //Update moderators
      if(modStatus == true){
        //Add to moderators
        this.moderators.splice(this.moderators.length,0,res.user);
      }
      else{

        //Remove from moderators
        if((index = this.findUser(this.moderators,userName).pos) != -1)
          this.moderators.splice(index,1);
      }

      //Update certified if exists
      res = this.findUser(this.certified,userName);
      if(res.pos != -1){
        res.user.is_moderator = modStatus;
      }
    },

    toggleModerator(user,e){
      e.preventDefault();
      console.log("Toggle Mod");
      console.log(user.username);

      axios.post('/api/members/'+user.username+'/toggle-moderator')
        .then(({data}) => {
          this.toggle_moderator(user.username,!!+data);
        })
        .catch((error) => {
            console.log(error);
        });
    },

    dismiss(flag){
      axios.delete('/api/flags/'+flag.member['id']+'/'+flag.moderator['id']+'/dismiss') 
        .catch((error) => {
            console.log(error);
        });
    },

    dismissFlag(flag,e){
      e.preventDefault();

      console.log(flag.member['id']+"  "+flag.moderator['id']);
      this.dismiss(flag);
      this.flagged.splice(this.flagged.indexOf(flag),1);
    },

    filterAllUsers(filter){
      this.query = filter;
      this.getUsers(1);
    },

    filter(searchField){
      let section = searchField.closest("section");
      let tr = section.querySelectorAll("tbody > tr");
      
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


    filterBarAllUsers(e){
      if(e.keyCode === 13){
        this.filterAllUsers(e.target.value);
      }
    },


    filterButtonAllUsers(e){
      let searchBar = e.target.closest(".input-group").children[1];
      this.filterAllUsers(searchBar.value);
    },


    filterBar(e){
      if(e.keyCode === 13){
        this.filter(e.target);
      }
    },

    filterButton(e){
      let searchBar = e.target.closest(".input-group").children[1];
      this.filter(searchBar);
    }
  }
}

</script>
