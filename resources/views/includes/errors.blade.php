@if(count($errors))
	<div class="alert alert-danger alert-bottom alert-dismissible fade show" role="alert">
		<div class="alert-message">
			<strong>Oh no!</strong> 
			@foreach($errors->all() as $error)
			@if ($loop->first)
					{{ trim($error) }}
				@else 
					Also, Illuminate\Support\Str::lower($error)
				@endif
			@endforeach
		</div>

		<button type="button" class="close" data-dismiss="alert" aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
	</div>
@endif
