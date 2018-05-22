<template>
    <main role="main" class="grey-background mt-5 mb-2">
        <section class="container wrapper mt-5">
            <div class="row">
                <div class="col-md-3 mt-2">
                    <div class="offcanvas-collapse" :class="{ open: isOffcanvasOpen }">
                        <div>
                            <h4 class="pt-4">Type</h4>
                            <div class="dropdown-divider"></div>

                            <b-form-radio-group class="text-muted" v-model="type"
                                                :options="typeOptions"
                                                stacked
                                                name="typeRadio">
                            </b-form-radio-group>

                        </div>

                        <div>
                            <h4 class="pt-4">Time</h4>
                            <div class="dropdown-divider"></div>

                            <b-form-radio-group class="text-muted" v-model="time"
                                                :options="timeOptions"
                                                stacked
                                                name="timeRadio"
                                                :disabled="!showSorting">
                            </b-form-radio-group>

                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="d-flex justify-content-between flex-wrap">
                        <h3>
                            <small class="text-muted">Results for</small>
                            {{ query }}
                        </h3>
                        <button @click="isOffcanvasOpen = !isOffcanvasOpen" class="btn btn-link text-mobile">
                            <i class="far fa-fw fa-filter"></i> Filter
                        </button>
                    </div>

                    <template v-if="results == null">
                    </template>

                    <h5 v-else-if="sortedResults.length === 0">
                        <small> No results.</small>
                    </h5>

                    <template v-else>

                        <nav v-if="showSorting">
                            <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                <a class="nav-item nav-link active" data-toggle="tab" role="tab" href=""
                                   @click="sortOrder = 'newest'" aria-controls="nav-newest"
                                   aria-selected="true">Newest</a>

                                <a class="nav-item nav-link" id="nav-oldest-tab" href="" @click="sortOrder = 'oldest'"
                                   data-toggle="tab" role="tab" aria-controls="nav-oldest"
                                   aria-selected="false">Oldest</a>

                                <a class="nav-item nav-link" id="nav-rating-tab" href="" @click="sortOrder = 'rating'"
                                   data-toggle="tab" role="tab" aria-controls="nav-rating"
                                   aria-selected="false">Rating</a>
                            </div>
                        </nav>

                        <div class="list-group">

                            <template v-if="type == 'questions'">
                                <question-card :key="question.id" v-for="question in sortedResults"
                                               :question="question"></question-card>
                            </template>

                            <template v-if="type == 'answers'">
                                <answer-card :key="answer.id" v-for="answer in sortedResults"
                                             :answer="answer"></answer-card>
                            </template>

                            <template v-if="type == 'members'">
                                <member-card :key="member.id" v-for="member in sortedResults"
                                             :member="member"></member-card>
                            </template>

                            <template v-if="type == 'topics'">
                                <topic-card :key="topic.id" v-for="topic in sortedResults" :topic="topic"></topic-card>
                            </template>

                        </div>

                    </template>

                </div>
            </div>
        </section>
    </main>

</template>

<script>
    export default {

        props: ['query'],

        name: 'Search',

        created() {
            document.title = "Search | Presto";
        },

        components: {
            QuestionCard: require('../components/QuestionCard'),
            AnswerCard: require('../components/AnswerCard'),
            MemberCard: require('../components/MemberCard'),
            TopicCard: require('../components/TopicCard')
        },

        mounted() {
            this.loader = this.$loading.show();
            this.getResults(this.query);
        },

        watch: {
            type: function () {
                this.results = null;
                this.loader = this.$loading.show();
                this.getResults(this.query);
            },

            query: function () {
                this.results = null;
                this.loader = this.$loading.show();
                this.getResults(this.query);
            }
        },

        data() {
            return {
                results: null,

                // Active filters
                type: 'questions',
                time: 'all',

                isOffcanvasOpen: false,

                typeOptions: [
                    {text: 'Questions', value: 'questions'},
                    {text: 'Answers', value: 'answers'},
                    {text: 'Members', value: 'members'},
                    {text: 'Topics', value: 'topics'}
                ],

                timeOptions: [
                    {text: 'All Time', value: 'all'},
                    {text: 'Past Day', value: 'day'},
                    {text: 'Past Week', value: 'week'},
                    {text: 'Past Month', value: 'month'},
                    {text: 'Past Year', value: 'year'}
                ],

                sortOrder: 'newest'
            }
        },

        methods: {
            getData: function (id) {
                this.getQuestion(id);
                this.getAnswers(id);
            },

            getResults: function (query) {
                let request = '/api/search/' + query;

                axios.get(request, {
                    params: {
                        type: this.type
                    }
                })
                    .then(({data}) => {
                        this.results = data;
                        this.loader.hide();
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }
        },

        computed: {
            sortedResults: function () {

                if (this.type == 'members' || this.type == 'topics')
                    return this.filteredResults;

                if (!this.results)
                    return null;

                let comparator;

                switch (this.sortOrder) {
                    case 'newest':
                        comparator = (a, b) => {
                            return a.date < b.date
                        };
                        break;

                    case 'oldest':
                        comparator = (a, b) => {
                            return a.date > b.date
                        };
                        break;

                    case 'rating':
                        comparator = (a, b) => {
                            return a.rating < b.rating
                        };
                        break;
                }

                return this.filteredResults.sort(comparator);
            },

            filteredResults: function () {
                if (this.type == 'members' || this.type == 'topics')
                    return this.results;

                if (!this.results)
                    return null;

                let limitDate;

                switch (this.time) {
                    case 'all':
                        limitDate = this.$moment('1970-01-01');
                        break;

                    case 'day':
                        limitDate = this.$moment().subtract(1, 'day');
                        break;

                    case 'week':
                        limitDate = this.$moment().subtract(1, 'week');
                        break;

                    case 'month':
                        limitDate = this.$moment().subtract(1, 'month');
                        break;

                    case 'year':
                        limitDate = this.$moment().subtract(1, 'year');
                        break;
                }

                return this.results.filter((entry) => this.$moment(entry.date) > limitDate);
            },

            showSorting: function () {
                if (this.type == 'members' || this.type == 'topics')
                    return false;

                return true;
            },

        }

    }
</script>

<style lang="css">
    @media (max-width: 767.98px) {
        .offcanvas-collapse {
            position: fixed;
            top: 56px; /* Height of navbar */
            bottom: 0;
            left: 0;
            width: 16.5rem;
            padding-right: 1rem;
            padding-left: 3.5rem;
            overflow-y: auto;
            background-color: white;
            transition: -webkit-transform .3s ease-in-out;
            transition: transform .3s ease-in-out;
            transition: transform .3s ease-in-out, -webkit-transform .3s ease-in-out;
            -webkit-transform: translateX(-150%);
            transform: translateX(-150%);
            z-index: 1030;
        }

        .offcanvas-collapse.open {
            -webkit-transform: translateX(-2rem);
            transform: translateX(-2rem); /* Account for horizontal padding on navbar */
        }
    }
</style>

