# lbaw1725
Repository to host Database and Web Applications Laboratory project. Made  in collaboration with @cyrilico and @diogotorres97.

LBAW is a course given at FEUP in the third year of the MIEIC course.

## The Product
Presto is an online platform where people can ask questions and contribute with answers, developing a community of unique insights on a wide variety of topics.

Members can post questions associated with one or more topics, which other people may answer. Any member can reflect their opinion on the application’s content via commentaries (where it is possible to mention fellow members), ratings or both. Members
are notified of activity that can be of their interest, such as questions from people they follow, upvotes on their content and mentions by other people. There is an advanced search feature where users can search for almost anything, with powerful filters and sorting options to better suit what one seeks. Each member has a score associated, built on his contributions to the community and others’ opinion on it.

More information [here](https://github.com/antonioalmeida/lbaw1725/tree/master/docs/Artifacts).

### Promotion

[Presto promotional video](https://www.youtube.com/watch?v=EEsTcBUwF6o)

## Development

### APIs
* [Google API](https://developers.google.com/identity/protocols/OAuth2)

### Framework/Libraries
* [Laravel](https://laravel.com/)
* [Vue](https://vuejs.org/)
* [Laravel Socialite](https://laravel.com/docs/5.5/socialite)
* [Pusher](https://pusher.com/)
* [TinyMCE](https://www.tinymce.com/)
* Minor Javascript helper libraries

### Technologies 
* PHP
* HTML
* CSS
* JavaScript
* PostgreSQL

## Gallery

A visual prototype is live [here](https://antonioalmeida.me/lbaw1725/).

[<img src="/docs/res/index.png">](/docs/res/index.png)                                                                                                                              
[<img src="/docs/res/profile.png">](/docs/res/profile.png)                                                                                                                              
[<img src="/docs/res/answer.png">](/docs/res/answer.png)                                                                                                                              
 
## How to Run
### Install dependencies and compile assets
``
$ composer install
$ npm install
$ npm run prod
$ php artisan clear-compiled
$ php artisan optimize
``

### Run
``
$ docker-compose up
$ php artisan serve
``

## Team 
  **Name:** GROUP1725

  **Theme:** Collaborative Q&A
  
  **Elements:**
- António Almeida [@antonioalmeida](https://github.com/antonioalmeida), up201505836@fe.up.pt
- Bruno Piedade [@Kubix20](https://github.com/Kubix20), up201505668@fe.up.pt
- Diogo Torres [@diogotorres97](https://github.com/diogotorres97), up201506428@fe.up.pt
- João Damas [@cyrilico](https://github.com/cyrilico), up201504088@fe.up.pt
