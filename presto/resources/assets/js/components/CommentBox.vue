<template>
    <div class="card-footer">
        <vue-tribute :options="options">
            <b-form-textarea
                    class="commentBox"
                    v-model="commentText"
                    placeholder="Leave a comment..."
                    :rows="2"
                    :max-rows="6"
                    :state="showError ? !showError : null" @input="showError = false; showSuccess = false;">
            </b-form-textarea>
        </vue-tribute>

        <span v-if="showError" class="text-danger"><small>You can't submit an empty comment.</small></span>
        <span v-if="showSuccess" class="text-primary"><small>Comment successfully added.</small></span>


        <div class="mt-2">
            <button @click="onCommentSubmit" class="btn btn-sm btn-primary">Submit</button>
            <button v-if="this.parentType=='question'" v-b-toggle.accordion2 class="btn btn-sm btn-link">Cancel</button>
        </div>
    </div>
</template>

<script>
    import VueTribute from 'vue-tribute';

    export default {

        props: ['parentType', 'parent'],

        name: 'CommentBox',

        components: {
            'VueTribute': VueTribute
        },

        mounted() {
            let allBoxes = document.querySelectorAll('.commentBox');
            allBoxes.forEach((item, index) => {
                item.addEventListener('tribute-replaced', e => {
                    this.commentText = this.commentText.replace(/@\w+\W?(?!.*@\w+\W?)/, '@' + e.detail.item.original.username + ' ');
                });
            });
        },

        data() {
            return {
                commentText: '',
                showError: false,
                showSuccess: false,

                //vue-tribute mentions options
                options: {
                    menuItemTemplate: function (item) {
                        return '<strong>' + item.string + '</strong>';
                    },
                    values: function (text, cb) {
                        if (text == '') {
                            cb([]);
                            return;
                        }
                        axios.get('/api/search/' + text, {
                            params: {
                                type: 'members'
                            }
                        })
                            .then(({data}) => {
                                cb(data.data.slice(0, 6));
                            })
                            .catch((error) => {
                                cb([]);
                            });
                    },
                    lookup: 'name',
                    fillAttr: 'username'
                }
            }
        },

        methods: {
            append: function () {
                let kv = Math.random()
                    .toString(36)
                    .slice(2)
                this.options.values.push({
                    key: kv,
                    value: kv
                })
            },
            onCommentSubmit: function () {
                if (this.commentText == '') {
                    this.showError = true;
                    return;
                }
                else
                    this.showError = false;

                //Extract mentions from comment
                let currentMention;
                let mentions = [];
                var regex = /@(\w+)\W?/g;

                while ((currentMention = regex.exec(this.commentText)) !== null)
                    mentions.push(currentMention[1]);

                axios.post('/api/comments/' + this.parentType + '/' + this.parent.id, {
                    'content': this.commentText,
                    'mentions': mentions
                })
                    .then(({data}) => {
                        this.parent.comments.unshift(data);
                        this.commentText = '';
                        this.showSuccess = true;
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }
        }

    }
</script>
