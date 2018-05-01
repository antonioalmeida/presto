<?php

return [
    // Pools are what you reference on the front-end
    // They contain the model that will be mentioned
    'pools' => [
        'users' => [
            // Model that will be mentioned
            'model' => 'App\Member',

            // Resource class that provides the JSON
            'resource' => null, //TODO: Figure out what is this

            // Filter class that alters the query
            'filter' => null, //TODO: Figure out what is this

            // The column that will be used to search the model
            'column' => 'username',

            // Notification class to use when this model is mentioned
            'notification' => 'App\Notifications\UserMentioned', //TODO: Update when notifications are done

            // Automatically notify upon mentions
            'auto_notify' => false
        ]
    ]
];
