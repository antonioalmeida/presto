$.ajaxSetup({
    headers: {
        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
});

$('#question-add-comment').submit(function(event) {
	event.preventDefault();

	let questionID = parseInt(event.target.getAttribute('data-question-id'));
	let content = event.target.querySelector('textarea[name="content"]').value;

	console.log(questionID);
	console.log(content);

	$.post('/api/comments/question', {'question_id': questionID, 'content': content})
	.done(function(response) {
		console.log(response);
		let parent = document.getElementById('questionComments');
		let html = document.createRange().createContextualFragment(response.data);
		parent.prepend(html);
	})
	.fail(function() {
		console.log("error");
	});

});
