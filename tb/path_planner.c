
/*
* EcoMender Bot (EB): Task 2B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#define V 32

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

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;
         uint32_t graph[V];

    #else
        // Address value of variables for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)
        #define graph          ( (volatile uint32_t * ) 0x02000010)
    #endif

    
    // ############# Add your code here #############
    // prefer declaring variable like this
    #ifdef __linux__
       
         uint8_t path_planned[V];
         uint8_t idx ;
          uint8_t distance[V];
          uint8_t node ;
          uint8_t  weight;
          uint8_t i;
          uint8_t j;
          uint8_t k;
         uint8_t min_node;
         uint8_t min_distance;
         uint32_t current;

    #else




// Allocate 32 bytes for distance (32 elements of uint8_t)
uint8_t *distance = (uint8_t *) 0x02000090;

// Allocate 32 bytes for path_planned (32 elements of uint8_t)
uint8_t *path_planned = (uint8_t *) 0x020000b0;

// Regular variables without volatile
uint8_t idx = (uint8_t )  0x020000d0;
uint8_t node = (uint8_t )  0x020000d1;
uint8_t weight = (uint8_t )  0x020000d2;
uint8_t i =(uint8_t )  0x020000d3;
uint8_t j = (uint8_t )  0x020000d4;
uint8_t k = (uint8_t ) 0x020000d5;
uint8_t min_node =(uint8_t )  0x020000d6;
uint8_t min_distance = (uint8_t ) 0x020000d7;

// Non-volatile for regular data
uint32_t current = (uint32_t ) 0x020000dc;
    #endif
idx = 0;
   

// ############# Add your code here #############
// Initialize graph array with the provided values efficiently
graph[0] = 0x202A2621;
graph[1] = 0x212B2220;
graph[2] = 0x25242321;
graph[3] = 0x23232322;
graph[4] = 0x24242422;
graph[5] = 0x25252522;
graph[6] = 0x29282720;
graph[7] = 0x27272726;
graph[8] = 0x28282826;
graph[9] = 0x29292926;
graph[10] = 0x3A382B20;
graph[11] = 0x332C2A21;
graph[12] = 0x2C2E2D2B;
graph[13] = 0x2D2D2D2C;
graph[14] = 0x2E302F2C;
graph[15] = 0x2F2F2F2E;
graph[16] = 0x3032312E;
graph[17] = 0x31313130;
graph[18] = 0x32353330;
graph[19] = 0x3334322B;
graph[20] = 0x34343433;
graph[21] = 0x35373632;
graph[22] = 0x36363635;
graph[23] = 0x373E3835;
graph[24] = 0x3839372A;
graph[25] = 0x39393938;
graph[26] = 0x3A3C3B2A;
graph[27] = 0x3B3B3B3A;
graph[28] = 0x3C3E3D3A;
graph[29] = 0x3D3D3D3C;
graph[30] = 0x3E3F3C37;
graph[31] = 0x3F3F3F3E;

// Initialize distances
for (i = 0; i < V; i++) {
    distance[i] = 128;
}
distance[END_POINT] = 0;

// Simplified Bellman-Ford
for (i = 0; i < V-1; i++) {
    for (j = 0; j < V; j++) {
        current = graph[j];
        for (k = 0; k < 4; k++) {
            node = (current >> (k * 8)) & 0x1F;
            weight = (current >> (k * 8 + 5)) & 0x7;
            if (distance[node] > distance[j] + weight) {
                distance[node] = distance[j] + weight;
            }
        }
    }
}

// Path reconstruction
min_distance = 255;
for (i = START_POINT; i != END_POINT; ) {
    path_planned[idx] = i;
    idx++;
    min_distance = 255;
    current = graph[i];
    for (j = 0; j < 4; j++) {
        node = (current >> (j * 8)) & 0x1F;
        if (distance[node] < min_distance) {
            min_distance = distance[node];
            min_node = node;
        }
    }
    i = min_node;
}
path_planned[idx++] = END_POINT;


    // ##############################################

    // the node values are written into data memory sequentially.
    for ( i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
        
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}

