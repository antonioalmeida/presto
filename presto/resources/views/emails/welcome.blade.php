@component('mail::message')
    # Welcome {{$member->name}}

    Thanks so much for registering!

    @component('mail::button', ['url' => config('app.url')])
        Start Browsing
    @endcomponent

    @component('mail::panel', ['url' => ''])
        The good life is one inspired by love and guided by knowledge
    @endcomponent

    Thanks,<br>
    {{ config('app.name') }}
@endcomponent