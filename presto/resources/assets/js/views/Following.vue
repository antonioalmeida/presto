<template>
    <div v-infinite-scroll="loadMore" infinite-scroll-disabled="busy" infinite-scroll-distance="0">
        <section class="container">
            <div class="offset-md-3 col-md-7 mb-4">
                <h4 class="mb-4">{{ username }} is following</h4>

                <div class="list-group">

                    <member-card :key="user.id" :member="user" v-for="user in following">
                    </member-card>

                </div>
            </div>
        </section>
    </div>
</template>

<script>
    export default {

        props: ['username'],

        name: 'Following',

        components: {
            MemberCard: require('../components/MemberCard'),
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getFollowing();
        },

        data() {
            return {
                following: [],
                busy: true,
                currDataChunk: 1,
                allData: false,
            }
        },

        methods: {
            getFollowing: function () {
                axios.get('/api/profile/' + this.username + '/following',{
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
                    this.busy = true;
                    return;
                }

                console.log("Loading More");
                this.busy = true;
                this.loader = this.$loading.show();
                this.currDataChunk++;


                this.getFollowing();
            },

            joinArray: function(data){
                for(let key in data){
                    if(data[key] != null)
                        this.following.push(data[key]);
                }
            }
        }
    }
</script>

