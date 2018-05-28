<template>

    <main class="mt-5 grey-background">

        <section class="container text-justify">
            <h1 class="mt-5 text-center">About <em>Presto</em></h1>

            <div class="col-md-6 offset-md-3 py-3">
                <p><em>Presto</em> (from the latin <i>Praesto</i>, i.e., 'ready to help') is an online platform where
                    people can ask questions and contribute with answers, developing a community of unique insights on a
                    wide variety of topics. </p>
                <p>In a time where knowledge is of the utmost importance, it can still be hard to find relevant
                    information regarding certain topics.
                    <em>Presto</em> provides a platform where anyone can ask or answer questions of just about anything.
                    One can, then, quickly obtain insightful information from different perspectives on a particular
                    subject.
                </p>
                <p>
                    A variety of other features are available aswell. Members can follow other users, topics or threads
                    of their interest to always be updated.
                    It is also possible to comment and rate all the content, so users can express their opinion on
                    others' messages.
                    Each user has a score derived from these ratings that tells their relevance and contribution to the
                    community.
                </p>

                <p class="mt-5">
                    <strong>The Presto team,</strong><br>
                    <em>António Almeida, Bruno Piedade, Diogo Torres, João Damas.</em>
                </p>
            </div>

        </section>

    </main><!-- /.container -->

</template>

<script>
    export default {

        name: 'About',

        created() {
            document.title = "About | Presto";
        },

        data() {
            return {}
        }
    }
</script>
