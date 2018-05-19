<!-- add question modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="POST" action="{{ Route('question-add')}}">
                {{ csrf_field() }}
                <div class="modal-body">
                    <div>
                        <input name="title" placeholder="Write your question" type="text" class="main-question">
                        <input name="tags" type="text" value="Science,Physics" data-role="tagsinput">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </div>
            </form>
        </div>
    </div>
</div> 