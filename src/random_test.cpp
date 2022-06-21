/****************************************************************************
FILE      : random_test.c
SUBJECT   : Random number generator test program.
PROGRAMMER: (C) Copyright 2012 by Peter C. Chapin

Although there are RNG test suites out there, I thought it would be instructive to write a few
tests "manually".

****************************************************************************/

#include <iostream>
#include <iomanip>
#include "random.h"

int *bucket_array[16];

unsigned current;
const int mask[16] = {
  0x0001, 0x0003, 0x0007, 0x000F, 0x001F, 0x003F, 0x007F, 0x00FF,
  0x01FF, 0x03FF, 0x07FF, 0x0FFF, 0x1FFF, 0x3FFF, 0x7FFF, 0xFFFF
};

int main( )
{
    // Set up the generator.
    rnd::standard_random base_gen;
    base_gen.time_seed( );
    rnd::bit_random gen( base_gen );

    // Allocate the bucket arrays.
    int i, size;
    for( i = 0, size = 2; i < 16; ++i, size *= 2 ) {
        bucket_array[i] = new int[size];
        for( int j = 0; j < size; ++j ) bucket_array[i][j] = 0;
    }

    // Generate random bits and catagorize the results.
    for( i = 0; i < 1000000; ++i ) {
        current = ( current << 1 ) | gen.next( );
        for( int j = 0; j < 16; ++j ) {
            bucket_array[j][current & mask[j]]++;
        }
    }

    // This is just for now. Need to do Chi-squared analysis of results.
    for( i = 0; i < 2; ++i ) {
        std::cout << std::setw( 7 ) << bucket_array[0][i];
    }
    std::cout << "\n";
    for( i = 0; i < 4; ++i ) {
        std::cout << std::setw( 7 ) << bucket_array[1][i];
    }
    std::cout << "\n";
    for(i = 0; i < 8; ++i ) {
        std::cout << std::setw( 7 ) << bucket_array[2][i];
    }
    std::cout << "\n";
    return 0;
}
