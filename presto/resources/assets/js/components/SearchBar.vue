<template>

    <div class="input-group">
        <a @click="onClick" id="nav-search-btn" class="nav-link" role="button"><i class="far fa-search"></i></a>

        <b-form-input
                id="nav-search-bar"
                type="text"
                v-model="query"
                placeholder="Search..."
                :state="showError ? false : null"
                @change="onSubmit"
                @input="showError = false"
                :class="{'open' : isOpen}"
        >
        </b-form-input>
    </div>

</template>

<script>
    export default {

        name: 'SearchBar',

        data() {
            return {
                query: '',
                showError: false,
                isOpen: false
            }
        },

        methods: {
            onClick: function () {
                this.isOpen = !this.isOpen;

                if (this.query.length === 0)
                    this.showError = true;
            },

            onSubmit: function () {
                if (this.query.length === 0) {
                    this.showError = true;
                    return;
                }

                this.$router.push({path: '/search/' + this.query});
            }
        }
    }
</script>

