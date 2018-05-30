<?php

use Illuminate\Pagination\Paginator;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Database\Eloquent\Collection;

function print_number_count($number)
{
    $precision = 0;

// Setup default $divisors if not provided
    $divisors = array(
        pow(1000, 0) => '', // 1000^0 == 1
        pow(1000, 1) => 'K', // Thousand
        pow(1000, 2) => 'M', // Million
        pow(1000, 3) => 'B', // Billion
        pow(1000, 4) => 'T', // Trillion
        pow(1000, 5) => 'Qa', // Quadrillion
        pow(1000, 6) => 'Qi', // Quintillion
    );

// Loop through each $divisor and find the
// lowest amount that matches
    foreach ($divisors as $divisor => $shorthand) {
        if (abs($number) < ($divisor * 1000)) {
// We found a match!
            break;
        }
    }

// We found our match, or there were no matches.
// Either way, use the last defined value for $divisor.
    return number_format($number / $divisor, $precision) . $shorthand;

}

function paginate($items, $perPage = 15, $page = null, $options = [])
    {
        $page = $page ?: (Paginator::resolveCurrentPage() ?: 1);
        $items = $items instanceof Collection ? $items : Collection::make($items);
        return new LengthAwarePaginator($items->forPage($page, $perPage), $items->count(), $perPage, $page, $options);
    }

function getDataChunk($data,$chunkNr,$maxNr){
    $chunk = $data->forPage($chunkNr,$maxNr);
    $nextChunk = $data->forPage(++$chunkNr,$maxNr);
    if(count($chunk) < $maxNr || count($nextChunk) == 0)
        $last = true;
    else
        $last = false;

    return ['data' => $chunk, 'last' => $last];
}
