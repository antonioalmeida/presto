<template>
    <div>
        <div class='tags-input'>
            <i class="far fa-tags text-primary mr-1"></i> 
            <span class="badge badge-primary"
                v-for="(badge, index) in tagBadges"
                :key="index"
            >
                <span v-html="badge"></span>

                <i href="#" class="tags-input-remove" @click.prevent="removeTag(index)"></i>
            </span>

            <input class="pt-1" type="text"
                :placeholder="placeholder"
                v-model="input"
                @keydown.enter.prevent="tagFromInput"
                @keydown.8="removeLastTag"
                @keydown.right="nextSearchResult"
                @keydown.left="prevSearchResult"
                @keyup.esc="ignoreSearchResults"
                @keyup="searchTag"
                @value="tags">

            <input type="hidden" v-if="elementId" 
                :name="elementId"
                :id="elementId"
                v-model="hiddenInput">
        </div>

        <div class="wrapper">
            <div v-show="searchResults.length" class="typeahead">
                <span v-if="index < 5" v-for="(tag, index) in searchResults"
                :key="index"
                v-text="tag.text"
                @click="tagFromSearch(tag)"
                class="badge"
                v-bind:class="{
                    'badge-dark': index == searchSelection,
                    'badge-light': index != searchSelection
                }"></span>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        elementId: String,

        existingTags: {
            type: Object,
            default: () => {
                return {};
            }
        },

        value: {
            type: [Array, String],
            default: () => {
                return [];
            }
        },
        
        typeahead: {
            type: Boolean,
            default: false
        },

        placeholder: {
            type: String,
            default: 'Add a tag'
        },

        limit: {
            type: Number,
            default: 0
        },

        onlyExistingTags: {
            type: Boolean,
            default: false
        },
        
        deleteOnBackspace: {
            type: Boolean,
            default: true
        },
    },

    data() {
        return {
            badgeId: 0,
            tagBadges: [],
            tags: [],

            input: '',
            oldInput: '',
            hiddenInput: '',
            
            searchResults: [],
            searchSelection: 0,
        };
    },

    created () {
        this.tagsFromValue();
    },

    watch: {
        tags() {
            // Updating the hidden input
            this.hiddenInput = this.tags.join(',');

            // Update the bound v-model value
            this.$emit('input', this.tags);
        },

        value() {
            this.tagsFromValue();
        }
    },

    methods: {
        tagFromInput(e) {
            // If we're choosing a tag from the search results
            if (this.searchResults.length && this.searchSelection >= 0) {
                this.tagFromSearch(this.searchResults[this.searchSelection]);

                this.input = '';
            } else {
                // If we're adding an unexisting tag
                let text = this.input.trim();

                // If the new tag is not an empty string
                if (!this.onlyExistingTags && text.length) {
                    this.input = '';

                    // Determine the tag's slug and text depending on if the tag exists
                    // on the site already or not
                    let slug = this.makeSlug(text);
                    let existingTag = this.existingTags[slug];

                    slug = existingTag ? slug : text;
                    text = existingTag ? existingTag : text;

                    this.addTag(slug, text);
                }
            }
        },

        tagFromSearch(tag) {
            this.searchResults = [];
            this.input = '';
            this.oldInput = '';
            
            this.addTag(tag.slug, tag.text);
        },

        makeSlug(value) {
            return value.toLowerCase().replace(/\s/g, '-');
        },

        addTag(slug, text) {
            // Check if the limit has been reached
            if (this.limit > 0 && this.tags.length >= this.limit) {
                return false;
            }

            // Attach the tag if it hasn't been attached yet
            let searchSlug = this.makeSlug(slug);
            let found = this.tags.find((value) => {
                return searchSlug == this.makeSlug(value);
            });

            if (!found) {
                this.tagBadges.push(text.replace(/\s/g, '&nbsp;'));
                this.tags.push(slug);
            }
        },

        removeLastTag(e) {
            if (!e.target.value.length && this.deleteOnBackspace) {
                this.removeTag(this.tags.length - 1);
            }
        },

        removeTag(index) {
            this.tags.splice(index, 1);
            this.tagBadges.splice(index, 1);
        },

        searchTag(e) {
            if (this.typeahead === true) {
                if (this.oldInput != this.input) {
                    this.searchResults = [];
                    this.searchSelection = 0;
                    let input = this.input.trim();

                    if (input.length) {
                        for (let slug in this.existingTags) {
                            let text = this.existingTags[slug].toLowerCase();

                            if (text.search(input.toLowerCase()) > -1) {
                                this.searchResults.push({ slug, text: this.existingTags[slug] });
                            }
                        }

                        // Sort the search results alphabetically
                        this.searchResults.sort((a, b) => {
                            if (a.text < b.text) return -1;
                            if (a.text > b.text) return 1;

                            return 0;
                        });
                    }

                    this.oldInput = this.input;
                }
            }
        },

        nextSearchResult() {
            if (this.searchSelection + 1 <= this.searchResults.length - 1) {
                this.searchSelection++;
            }
        },

        prevSearchResult() {
            if (this.searchSelection > 0) {
                this.searchSelection--;
            }
        },

        ignoreSearchResults() {
            this.searchResults = [];
            this.searchSelection = 0;
        },

        /**
        * Clear the list of selected tags
        */
        clearTags() {
            this.tags.splice(0, this.tags.length);
            this.tagBadges.splice(0, this.tagBadges.length);
        },

        /**
        * Replace the currently selected tags with the tags from the value
        */
        tagsFromValue() {
            if (this.value && this.value.length) {
                let tags = Array.isArray(this.value)
                    ? this.value
                    : this.value.split(',');

                if (this.tags == tags) {
                    return;
                }

                this.clearTags();

                for (let slug of tags) {
                    let existingTag = this.existingTags[slug];
                    let text = existingTag ? existingTag : slug;

                    this.addTag(slug, text);
                }
            } else {
                if (this.tags.length == 0) {
                    return;
                }

                this.clearTags();
            }
        }
    }
}
</script>

