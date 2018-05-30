<template>

    <main class="mt-5 grey-background">

        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center">
                            <img class="profile-pic img-fluid rounded-circle m-2" :src="user.profile_picture"/>
                        </div>

                        <div class="col-md-6 text-shadow mobile-center">
                            <h2 class="h2-adapt">{{ user.name }}
                                <template v-if="user.is_moderator">
                                    <span id="modTag" class="fa-layers fa-fw">
                                        <i class="fas fa-certificate" data-fa-transform="up-2 grow-2"></i>
                                        <i class="fas fa-certificate text-info" data-fa-transform="up-2"></i>
                                        <i class="far fa-user-shield" data-fa-transform="up-2 shrink-10"></i>
                                    </span>
                                    <b-tooltip target="modTag" :title="user.name + ' is a Moderator'"></b-tooltip>
                                </template>
                            </h2>
                            <router-link class="white-url" :to="/profile/ + username">
                                <h4 class="h4-adapt">&#64;{{ user.username}} </h4>
                            </router-link>

                            <!-- bio -->

                            <div class="bio mt-3">
                                <div class="d-flex justify-content-sm-start justify-content-around">
                                    <router-link class="white-url" :to="'/profile/' + username + '/followers'">
                                        <h5 class="p-2 h5-adapt"> {{ this.user.nrFollowers }}
                                            <small>followers</small>
                                        </h5>
                                    </router-link>

                                    <router-link class="white-url" :to="'/profile/' + username + '/following'">
                                        <h5 class="p-2 h5-adapt"> {{ this.user.nrFollowing }}
                                            <small>following</small>
                                        </h5>
                                    </router-link>

                                </div>

                                <p class="lead lead-adapt">
                                    {{user.bio}}
                                </p>

                                <router-link v-if="user.isOwner" :to="'/edit-profile'" class="btn btn-outline-light">
                                    Edit Profile
                                </router-link>

                                <router-link v-if="user.isOwner && logged.is_moderator" :to="'/reports'" class="btn btn-outline-light">
                                    Edit Profile
                                </router-link>

                                <b-btn v-if="!user.isOwner && logged.is_moderator" variant="outline-light" v-b-modal.flagModal>Flag member</b-btn>
                            </div>
                        </div>

                        <div class="col-md-3 mt-3">
                            <div class="card card-body">
                                <h5 class="text-dark">Stats</h5>
                                <div class="dropdown-divider"></div>
                                <div class="d-flex flex-column justify-content-around flex-wrap">
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="text-primary fa fa-gem"></i>
                                        </div>
                                        <h6>{{user.score}}
                                            <a href=""><small class="text-muted">points</small></a>
                                        </h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-question"></i>
                                        </div>
                                        <h6>{{ user.nr_questions }}
                                            <small class="text-muted">questions</small>
                                        </h6>
                                    </div>
                                    <div class="d-flex p-1">
                                        <div class="mx-2">
                                            <i class="far fa-fw fa-book"></i>
                                        </div>
                                        <h6>{{user.nr_answers}}
                                            <small class="text-muted">answers</small>
                                        </h6>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <router-view :data="followData" @update:data="value => user.nrFollowing = value.no_follow"></router-view>

        <!-- flag member modal -->
        <b-modal lazy centered
            title="Flag Member"
            id="flagModal"
            ok-variant="primary"
            cancel-variant="link"
            ok-title="Submit"
            cancel-title="Cancel"
            @ok="onFlagSubmit"
        >
        <div class="input-group">
            <input v-model="flagReason" type="text"
            class="form-control" placeholder="Why is this member being flagged?"
            aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
        </div>
    </b-modal>

    </main>

</template>

<script>
    import QuestionCard from '../components/QuestionCard';
    import bTooltip from 'bootstrap-vue/es/components/tooltip/tooltip';

    export default {

        props: ['username'],

        created() {
            document.title = this.username + "'s Profile | Presto";
        },

        components: {
            'QuestionCard': QuestionCard,
            'bTooltip': bTooltip
        },

        data() {
            return {
                user: {},
                logged: {},
                followData: null,
                flagReason: ''
            }
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getData(this.username);
            this.getLogged();
        },

        watch: {
            '$route'(to, from) {
                this.loader = this.$loading.show();
                this.getData(to.params.username);
            }
        },

        methods: {
            getData: function (username) {
                this.getUser(username);
            },

            getUser: function (username) {
                axios.get('/api/profile/' + (username || ''))
                    .then(({data}) => {
                        this.user = data;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            getLogged: function () {
              axios.get('/api/profile/')
                  .then(({data}) => {
                      this.logged = data;
                  })
                  .catch((error) => {
                      this.logged.is_moderator = false; //In case not logged in
                  });
            },

            onFlagSubmit: function() {
              axios.post('/api/profile/' + this.username + '/flag', {
                'reason': this.flagReason
              })
                  .then(({data}) => {
                    this.$alerts.addSuccess('Member successfully flagged!');
                  })
                  .catch((error) => {
                      console.log(error);
                  });
            }
        }

    }
</script>
