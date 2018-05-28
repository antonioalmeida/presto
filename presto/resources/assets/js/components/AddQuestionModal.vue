<template>
    <b-modal centered hide-header id="modal" lazy v-model="showModal">
        <div class="modal-body">
            <div>
                <input v-model="title" placeholder="Write your question" type="text" class="main-question"
                       @input="showError = false">

                <tags-input element-id="tags"
                            v-model="selectedTags"
                            :typeahead="true"
                            :existing-tags="existingTags"
                            :placeholder="'Add topics...'"
                ></tags-input>
            </div>

            <div v-if="showError" class="ml-1">
                <span v-for="error in errors" class="text-danger"><small> {{ error[0] }}<br></small></span>
            </div>
        </div>
        <div slot="modal-footer">
            <b-button variant="link" @click="showModal = false">Cancel</b-button>
            <b-button variant="primary" @click="onSubmit">Submit</b-button>
        </div>
    </b-modal>
</template>

<script>
    import TagsInput from './TagsInput';

    export default {

        name: 'AddQuestionModal',

        components: {
            'tags-input': TagsInput
        },

        data() {
            return {
                title: '',

                selectedTags: [
                    'Science',
                ],

                existingTags: {},

                showError: false,
                errors: [],

                showModal: false,
            }
        },

        mounted() {
            this.getData();
        },

        methods: {
            getData: function (id) {
                this.getTopics();
            },

            getTopics: function () {
                let request = '/api/topic/';

                axios.get(request)
                    .then(({data}) => {
                        this.existingTags = data.reduce(function (result, item, index, array) {
                            result[item] = item;
                            return result;
                        }, {});
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },

            onSubmit: function () {
                axios.post('/api/questions', {
                    'title': this.title,
                    'tags': this.selectedTags
                })
                    .then(({data}) => {
                        this.redirect(data.id);
                        this.$alerts.addSuccess('Question successfully created!')
                    })
                    .catch(({response}) => {
                        this.errors = response.data.errors;
                        this.showError = true;
                    });
            },

            redirect: function (id) {
                this.$router.push({path: '/questions/' + id});
                this.showModal = false;
                this.title = '';
                this.selectedTags = ['Science', 'Physics'];
            }
        },

    }
</script>

