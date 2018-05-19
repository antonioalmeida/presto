<template>
    <body class="">

    <main role="main" class="mt-5">

        <section class="container mt-5 pt-5 d-flex justify-content-center">

            <div class="align-self-center">
                <div>
                    <h1 class="display-1">404</h1>
                    <h2>
                        <small>The page you were looking for was not found.</small>
                    </h2>
                    <a href="">
                        <button class="m-2 btn  btn-primary">Home</button>
                    </a>
                </div>
            </div>
        </section>

    </main><!-- /.container -->

    </body>
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
