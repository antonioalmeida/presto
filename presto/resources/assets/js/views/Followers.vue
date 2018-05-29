<template>
    <div v-infinite-scroll="loadMore" infinite-scroll-disabled="busy" infinite-scroll-distance="0">
        <section class="container">
            <div class="offset-md-3 col-md-7 mb-4">
                <h4 class="mb-4">{{ username }}'s followers</h4>

                <div class="list-group">

                    <member-card :key="follower.id" :member="follower" v-for="follower in followers">
                    </member-card>

                </div>
            </div>
        </section>
    </div>
</template>

<script>

    export default {

        props: ['username'],

        name: 'Followers',

        components: {
            MemberCard: require('../components/MemberCard'),
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getFollowers();
        },

        data() {
            return {
                followers: [],
                busy: true,
                currDataChunk: 1,
                allData: false,
            }
        },

        methods: {
            getFollowers: function () {
                axios.get('/api/profile/' + this.username + '/followers', {
                    params: {
                        chunk: this.currDataChunk
                    }
                })
                    .then(({data}) => {
                        this.joinArray(data.data);
                        this.allData = data.last;
                        this.busy = false;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            },


            loadMore: function(){
                if(this.allData){
                    console.log("No more");
                    this.busy = true;
                    return;
                }

                console.log("Loading More");
                this.busy = true;
                this.loader = this.$loading.show();
                this.currDataChunk++;


                this.getFollowers();
            },

            joinArray: function(data){
                for(let key in data){
                    if(data[key] != null)
                        this.followers.push(data[key]);
                }
            }
        }
    }
</script>

