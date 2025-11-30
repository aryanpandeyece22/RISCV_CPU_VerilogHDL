
/*
* EcoMender Bot (EB): Task 2B Example 2
*
* This program generates simple arithmetic progression.
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef __linux__ // for host pc

    #include <stdio.h>

    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }

        // print the characters in reverse order (from right to left)
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint8_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint8_t val) { }
    void _put_str(char *str) { }

#endif

// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__ // for simulation

        const uint8_t A    = 5;
        const uint8_t D    = 6;
        const uint8_t N    = atoi(argv[1]);
        uint8_t CPU_DATA   = 0;
        uint8_t CPU_DONE   = 0;

    #else // for hardware implementation

        // define variable with an address to load/store
        #define A              (* (volatile uint8_t * ) 0x02000000)
        #define D              (* (volatile uint8_t * ) 0x02000004)
        #define N              (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DATA       (* (volatile uint8_t * ) 0x0200000c)
        #define CPU_DONE       (* (volatile uint8_t * ) 0x02000010)

    #endif

    /*
    * Function Name : generate_ap_series
    * Description   : Generate an Arithmetic Progression series
    * Arguments     : a - first term
                      d - common difference
                      n - no of terms
    */
    void generate_ap_series(uint8_t a, uint8_t d, uint8_t n) {
        // iterate for n-terms
        for (uint8_t i = 0; i < n; i++) {
            // result is stored in CPU_DATA
            CPU_DATA = a + i * d;
            // print in c simulation on linux, do nothing in hardware
            _put_value(CPU_DATA);
        }
        // for c simulation
        _put_str("\n");
    }

    // function call
    generate_ap_series(A, D, N);

    // flag indicating program execution is complete
    CPU_DONE = 1;

    return 0;
}