#include <stdio.h>
#include "primes.h"

int main(){
    int prime = isPrime(3);
    printf("isPrime(%d) = %d\n", 3, prime);
    return 0;
}