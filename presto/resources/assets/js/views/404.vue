<template>
    <main  class="mt-5 grey-background">
        <section class="container mt-5 pt-5 d-flex justify-content-center">

            <div class="align-self-center">
                <div>
                    <h1 class="display-1">4<small>
                        <i class="far fa-frown" data-fa-transform="up-1"></i>
                        </i></small>4</h1>
                    <h2>
                        <small>The page you were looking for was not found.</small>
                    </h2>
                </div>
            </div>
        </section>
    </main>
</template>

<script>
    export default {

        name: '404',

        created() {
            document.title = "404 | Presto";
        },

        data() {
            return {}
        }
    }
</script>
