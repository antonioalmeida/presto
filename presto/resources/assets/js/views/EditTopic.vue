<template>
    <main class="grey-background mt-5">
        <section>
            <div class="jumbotron profile-jumbotron">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center ">
                            <b-img class="m-2 force-square" rounded="circle" :src="topic.picture"></b-img>
                            
                                <b-btn v-b-modal.editPicture variant="light">
                                    Edit 
                                </b-btn>
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

        <b-modal
        lazy centered
        title="Change Topic Avatar"
        id="editPicture"
        ok-variant="primary"
        cancel-variant="link"
        ok-title="Submit"
        cancel-title="Cancel"
        @ok="onPicSubmit">
        <div class="input-group">
            <label for="profilePicture" hidden>Change the topic's photo</label>
            <input type="text" v-model="picture" class="form-control"
            placeholder="New URL"
            aria-label="Default" aria-describedby="inputGroup-sizing-default" required>
        </div> 
    </b-modal>
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
                        this.topic.picture = this.picture;
                        this.$alerts.addSuccess('Picture successfully updated!');
                    })
                    .catch(({response}) => {
                        this.loader.hide();
                        this.$alerts.addError(response.data.errors.name[0]);
                    });
            },
        }
    }
</script>
