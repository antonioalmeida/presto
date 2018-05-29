<template>
    <main class="grey-background mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <img class="profile-pic img-fluid rounded-circle m-2" :src="topic.picture"/>
                            <span class="fa-layers fa-fw fa-2x">
                                 <i class="fas fa-circle text-shadow" style="color:white"></i>
                                <a href="" data-toggle="modal" data-target="#editPicture"><i
                                        class="fa-inverse fa-fw fas fa-pencil-alt text-muted"
                                        data-fa-transform="shrink-8"></i></a>
								</span>
                        </div>

                        <div class="col-md-6 mobile-center text-shadow edit-profile">

                            <input v-model="nameInput" type="text" class="form-control input-h2"
                                   pattern="^[a-zA-Z\s]{1,35}$"
                                   title="Name can only contain letters. 35 characters max allowed"
                                   placeholder="Topic name..."
                                   required>

                            <div class="mt-3">
                                <input v-model="descriptionInput" type="text" class="form-control input-h6 lead-adapt mt-2"
                                       placeholder="Small topic description...">

                                <div class="ml-1 mt-3">
                                    <button @click="onSubmit" class="btn btn-light">Save</button>
                                    <router-link :to="'/topic/' + topic.name" class="btn btn-danger">Cancel
                                    </router-link>
                                </div>

                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </section>
        <!-- edit picture modal -->
        <div class="modal fade" id="editPicture" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
             aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div>
                        <div class="modal-body">
                            <div>
                                <h6><label for="profilePicture">Change the topic's picture</label></h6>
                                <div class="input-group">
                                    <input type="text" v-model="picture" class="form-control"
                                           placeholder="New URL"
                                           aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                            <button @click="onPicSubmit" type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

</template>

<script>
    export default {

        props: ['name'],

        name: 'EditTopic',

        data() {
            return {
                topic: {},
                nameInput: '',
                descriptionInput: '',
                picture: '',
            }
        },

        created() {
            document.title = "Edit Topic | Presto";
            this.loader = this.$loading.show();
            this.getTopic();
        },

        methods: {
            getTopic: function () {
                console.log(this.topicName);
                axios.get('/api/topic/' + this.name)
                    .then(({data}) => {
                        this.topic = data;
                        this.nameInput = data.name;
                        this.descriptionInput = data.description;
                        this.picture = data.picture;

                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onSubmit: function () {
                this.loader = this.$loading.show();
                axios.post('/api/topic/' + this.name, {
                    'name': this.nameInput,
                    'description': this.descriptionInput,
                })
                    .then(({data}) => {
                        this.loader.hide();
                        this.$router.push({path: '/topic/' + data.name});
                        this.$alerts.addSuccess('Topic successfully updated!');
                        location.reload();
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                        this.$alerts.addError(response.data.errors.name[0]);
                    });

            },

            onPicSubmit: function () {
                axios.patch('/api/topic/' + this.name + '/edit-pic', {
                    'pic-url': this.picture
                })
                    .then(({data}) => {
                        $('#editPicture').modal('toggle');
                        this.topic.picture = this.picture;
                        this.$alerts.addSuccess('Picture successfully updated!');
                        location.reload();
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                        this.$alerts.addError(response.data.errors.name[0]);
                    });
            },
        }
    }
</script>
