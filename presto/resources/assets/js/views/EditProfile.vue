<template>
    <main  class="grey-background mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" :src="user.profile_picture"/>
                            <span class="fa-layers fa-fw fa-2x">
									<i class="fas fa-circle text-shadow" style="color:white"></i>
									<a><i class="fa-inverse fa-fw fas fa-pencil-alt text-muted"
                                          data-fa-transform="shrink-8"></i></a>
								</span>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-profile">

                            <input v-model="nameInput" type="text" class="form-control input-h2"
                              pattern="^[a-zA-Z\s]{1,35}$"
                              title="Name can only contain letters. 35 characters max allowed"
                            required>
                            <input v-model="usernameInput" type="text" class="form-control input-h4 mt-2"
                              pattern="^[a-zA-Z][\w-]{1,18}(?![-_])\w$"
                              title="2 to 20 characters. Must start with a letter. Can contain alphanumeric characters, - and _ (but not end with the latter two)"
                            required>

                            <div class="mt-3">
                                <input v-model="bioInput" type="text" class="form-control input-h6 lead-adapt mt-2">

                                <div class="ml-1 mt-3">
                                    <button @click="onSubmit" class="btn btn-light">Save</button>
                                    <router-link :to="'/profile/' + user.username" class="btn btn-danger">Cancel
                                    </router-link>
                                </div>

                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </section>
    </main>
</template>

<script>
    export default {

        name: 'EditProfile',

        data() {
            return {
                user: {},
                nameInput: '',
                usernameInput: '',
                bioInput: '',
            }
        },

        created() {
            this.loader = this.$loading.show();
            this.getUser();
        },

        methods: {
            getUser: function () {
                axios.get('/api/profile/')
                    .then(({data}) => {
                        this.user = data;
                        this.nameInput = data.name;
                        this.usernameInput = data.username;
                        this.bioInput = data.bio;

                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onSubmit: function () {
                this.loader = this.$loading.show();
                axios.post('/api/profile/', {
                    'name': this.nameInput,
                    'username': this.usernameInput,
                    'bio': this.bioInput,
                })
                    .then(({data}) => {
                        this.loader.hide();
                        this.$router.push({path: '/profile/' + data.username});
                        this.$alerts.addSuccess('Profile successfully edited!')
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                    });

            }
        }
    }
</script>
