<template>
    <main class="grey-background mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <b-img class="m-2 force-square" rounded="circle" :src="user.profile_picture"></b-img>
                            
                                <b-btn v-b-modal.editPicture variant="light">
                                    Edit 
                                </b-btn>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-content">

                            <input v-model="nameInput" type="text" class="form-control input-h2"
                                   pattern="^[a-zA-Z\s]{1,35}$"
                                   title="Name can only contain letters. 35 characters max allowed"
                                   placeholder="Your name..."
                                   required>
                            <input v-model="usernameInput" type="text" class="form-control input-h4 mt-2"
                                   pattern="^[a-zA-Z][\w-]{1,18}(?![-_])\w$"
                                   title="2 to 20 characters. Must start with a letter. Can contain alphanumeric characters, - and _ (but not end with the latter two)"
                                   placeholder="Your username..."
                                   required>

                            <div class="mt-3">
                                <input v-model="bioInput" type="text" class="form-control input-h6 lead-adapt mt-2"
                                       placeholder="Your bio...">

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

        <b-modal
            lazy centered
            title="Change Avatar"
            id="editPicture"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Submit"
            cancel-title="Cancel"
            @ok="onPicSubmit">
            <div class="input-group">
                <label for="profilePicture" hidden>Change your photo</label>
                <input type="text" v-model="profilePicture" class="form-control"
                placeholder="New URL"
                aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
            </div> 
        </b-modal>
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
                profilePicture: '',
            }
        },

        created() {
            document.title = "Edit Profile | Presto";
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
                        location.reload();
                        this.$alerts.addSuccess('Profile successfully edited!');
                        this.$router.push({path: '/profile/' + data.username});
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                    });

            },

            onPicSubmit: function () {
                axios.patch('api/member/edit-profile-pic', {
                    'profile-pic-url': this.profilePicture
                })
                    .then(({data}) => {
                        this.user.profile_picture = this.profilePicture;
                        this.$alerts.addSuccess('Photo successfully updated!');
                    })
                    .catch(({response}) => {

                    });
            },
        }
    }
</script>
