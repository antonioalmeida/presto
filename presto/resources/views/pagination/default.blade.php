<div class="col-md-6 offset-md-3 d-flex justify-content-center pt-4">
    <nav aria-label="Page navigation example">
        @if ($paginator->lastPage() > 1)
            <ul class="pagination ml-auto">
                <li class="{{ ($paginator->currentPage() == 1) ? ' disabled' : '' }} page-item">
                    <a class=" page-link " href="{{ $paginator->url(1) }}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                        <span class="sr-only">Previous</span>
                    </a>
                </li>
                @for ($i = 1; $i <= $paginator->lastPage(); $i++)
                    <li class="{{ ($paginator->currentPage() == $i) ? ' active' : '' }} page-item">
                        <a class=" page-link " href="{{ $paginator->url($i) }}">{{ $i }}</a>
                    </li>
                @endfor
                <li class="{{ ($paginator->currentPage() == $paginator->lastPage()) ? ' disabled' : '' }} page-item">
                    <a href="{{ $paginator->url($paginator->currentPage()+1) }}" class="page-link" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                        <span class="sr-only">Next</span>
                    </a>
                </li>
            </ul>
        @endif
    </nav>
</div>