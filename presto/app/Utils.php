<?php

function print_number_count($number) {
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