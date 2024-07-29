
/*
* AstroTinker Bot (AB): Task 1B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
* Updated memory addresses for Task 2B
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

/*
Functions Usage

instead of using printf() function for debugging,
use the below function calls to print a number, string or a newline

for newline: _put_byte('\n');
for string:  _put_str("your string here");
for number:  _put_value(your_number_here);

Examples:
        _put_value(START_POINT);
        _put_value(END_POINT);
        _put_str("Hello World!");
        _put_byte('\n');

*/

// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;
    #else
        // Address value of variables are updated for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)
    #endif

    // array to store the planned path

    // index to keep track of the path_planned array
    //uint8_t idx = 0;

    // ############# Add your code here #############
    #ifdef __linux__


        int nodes[30];
        uint8_t dist[30];
        uint8_t parent[32];
        uint8_t path_planned[32];
        uint8_t check,minDist,u,k,idx;
        uint8_t *pointer;
        uint8_t v,count;
    #else
        #define nodes          ( (volatile int * ) 0x02000010)
        #define dist           ( (volatile uint8_t * ) 0x02000088)
        #define parent         ( (volatile uint8_t * ) 0x020000a8)
        #define path_planned   ( (volatile uint8_t * ) 0x020000c8)
        #define minDist          (* (volatile uint8_t * ) 0x020000e8)
        #define u          (* (volatile uint8_t * ) 0x020000e9)
        #define k          (* (volatile uint8_t * ) 0x020000ea)
        #define idx          (* (volatile uint8_t * ) 0x020000eb)
        //#define v          (* (volatile uint8_t * ) 0x020000f0)
        //#define count          (* (volatile uint8_t * ) 0x020000f1)
       //#define pointer           ( (volatile uint8_t * ) 0x020000ec) 
       volatile uint8_t *pointer=(uint8_t*)0x020000ec;
        // int *nodes=(int*)0x02000010;
        // volatile uint8_t *dist=(volatile uint8_t*)0x02000088;
        // volatile uint8_t *parent=(volatile uint8_t*)0x020000a8;
        // volatile uint8_t *path_planned=(volatile uint8_t*)0x020000c8;
    #endif

   {////*idx = *idx + 1;

*(nodes+(0 )) =    1684300801 ;//*idx = *idx + 1;
*(nodes+(1 )) =    1679622656 ;//*idx = *idx + 1; 
*(nodes+(2 )) =    1678246657 ;//*idx = *idx + 1; 
*(nodes+(3)) =    1679557634 ;//*idx = *idx + 1; 
*(nodes+(4 )) =    1678116099 ;//*idx = *idx + 1; 
*(nodes+(5 )) =    1684300804 ;//*idx = *idx + 1; 
*(nodes+(6 )) =    1684276996 ;//*idx = *idx + 1; 
*(nodes+(7 )) =    1684277254 ;//*idx = *idx + 1; 
*(nodes+(8 )) =    201918210  ;//*idx = *idx + 1; 
*(nodes+(9 )) =    1678445064 ;//*idx = *idx + 1; 
*(nodes+(10)) =    1684300809 ;//*idx = *idx + 1; 
*(nodes+(11)) =    1684300809 ;//*idx = *idx + 1; 
*(nodes+(12)) =    1678970120 ;//*idx = *idx + 1; 
*(nodes+(13)) =    1684278796 ;//*idx = *idx + 1; 
*(nodes+(14)) =    1678774029 ;//*idx = *idx + 1; 
*(nodes+(15)) =    1684300814 ;//*idx = *idx + 1; 
*(nodes+(16)) =    1678905614 ;//*idx = *idx + 1; 
*(nodes+(17)) =    1684300816 ;//*idx = *idx + 1; 
*(nodes+(18)) =    1684280080 ;//*idx = *idx + 1; 
*(nodes+(19)) =    1679036940 ;//*idx = *idx + 1; 
*(nodes+(20)) =    488117523  ;//*idx = *idx + 1; 
*(nodes+(21)) =    1679234580 ;//*idx = *idx + 1; 
*(nodes+(22)) =    1684300821 ;//*idx = *idx + 1; 
*(nodes+(23)) =    1684300821 ;//*idx = *idx + 1; 
*(nodes+(24)) =    1684281620 ;//*idx = *idx + 1; 
*(nodes+(25)) =    1684281880 ;//*idx = *idx + 1; 
*(nodes+(26)) =    1679563545 ;//*idx = *idx + 1; 
*(nodes+(27)) =    1684300826 ;//*idx = *idx + 1; 
*(nodes+(28)) =    1679628803 ;//*idx = *idx + 1; 
*(nodes+(29)) =    1679561729 ;//*idx = *idx + 1; 
}

// {
//     //node 0
//     *nodes=1;
//     *(nodes+1)=100;
//     *(nodes+2)=100;
//     *(nodes+3)=100;
//     //node 1
//     *(nodes+4)=0;
//     *(nodes+5)=2;
//     *(nodes+6)=29;
//     *(nodes+7)=100;
//     //node 2
//     *(nodes+8)=1;
//     *(nodes+9)=3;
//     *(nodes+10)=8;
//     *(nodes+11)=100;
//     //node 3
//     *(nodes+12)=2;
//     *(nodes+13)=4;
//     *(nodes+14)=28;
//     *(nodes+15)=100;
//     //node 4
//     *(nodes+16)=3;
//     *(nodes+17)=5;
//     *(nodes+18)=6;
//     *(nodes+19)=100;
//     //node 5
//     *(nodes+20)=4;
//     *(nodes+21)=100;
//     *(nodes+22)=100;
//     *(nodes+23)=100;
//     //node 6
//     *(nodes+24)=4;
//     *(nodes+25)=7;
//     *(nodes+26)=100;
//     *(nodes+27)=100;
//     //node 7
//     *(nodes+28)=6;
//     *(nodes+29)=8;
//     *(nodes+30)=100;
//     *(nodes+31)=100;
//     //node 8
//     *(nodes+32)=2;
//     *(nodes+33)=7;
//     *(nodes+34)=9;
//     *(nodes+35)=12;
//     //node 9
//     *(nodes+36)=8;
//     *(nodes+37)=10;
//     *(nodes+38)=11;
//     *(nodes+39)=100;
//     //node 10
//     *(nodes+40)=9;
//     *(nodes+41)=100;
//     *(nodes+42)=100;
//     *(nodes+43)=100;
//     //node 11
//     *(nodes+44)=9;
//     *(nodes+45)=100;
//     *(nodes+46)=100;
//     *(nodes+47)=100;
//     //node 12
//     *(nodes+48)=8;
//     *(nodes+49)=13;
//     *(nodes+50)=19;
//     *(nodes+51)=100;
//     //node 13
//     *(nodes+52)=12;
//     *(nodes+53)=14;
//     *(nodes+54)=100;
//     *(nodes+55)=100;
//     //node 14
//     *(nodes+56)=13;
//     *(nodes+57)=15;
//     *(nodes+58)=16;
//     *(nodes+59)=100;
//     //node 15
//     *(nodes+60)=14;
//     *(nodes+61)=100;
//     *(nodes+62)=100;
//     *(nodes+63)=100;
//     //node 16
//     *(nodes+64)=14;
//     *(nodes+65)=17;
//     *(nodes+66)=18;
//     *(nodes+67)=100;
//     //node 17
//     *(nodes+68)=16;
//     *(nodes+69)=100;
//     *(nodes+70)=100;
//     *(nodes+71)=100;
//     //node 18
//     *(nodes+72)=16;
//     *(nodes+73)=19;
//     *(nodes+74)=100;
//     *(nodes+75)=100;
//     //node 19
//     *(nodes+76)=12;
//     *(nodes+77)=18;
//     *(nodes+78)=20;
//     *(nodes+79)=100;
//     //node 20
//     *(nodes+80)=19;
//     *(nodes+81)=21;
//     *(nodes+82)=24;
//     *(nodes+83)=29;
//     //node 21
//     *(nodes+84)=20;
//     *(nodes+85)=22;
//     *(nodes+86)=23;
//     *(nodes+87)=100;
//     //node 22
//     *(nodes+88)=21;
//     *(nodes+89)=100;
//     *(nodes+90)=100;
//     *(nodes+91)=100;
//     //node 23
//     *(nodes+92)=21;
//     *(nodes+93)=100;
//     *(nodes+94)=100;
//     *(nodes+95)=100;
//     //node 24
//     *(nodes+96)=20;
//     *(nodes+97)=25;
//     *(nodes+98)=100;
//     *(nodes+99)=100;
//     //node 25
//     *(nodes+100)=24;
//     *(nodes+101)=26;
//     *(nodes+102)=100;
//     *(nodes+103)=100;
//     //node 26
//     *(nodes+104)=25;
//     *(nodes+105)=27;
//     *(nodes+106)=28;
//     *(nodes+107)=100;
//     //node 27
//     *(nodes+108)=26;
//     *(nodes+109)=100;
//     *(nodes+110)=100;
//     *(nodes+111)=100;
//     //node 28
//     *(nodes+112)=3;
//     *(nodes+113)=26;
//     *(nodes+114)=29;
//     *(nodes+115)=100;
//     //node 29
//     *(nodes+116)=1;
//     *(nodes+117)=20;
//     *(nodes+118)=28;
//     *(nodes+119)=100;
//}
   

idx=0;
//uint8_t *pointer;
    // Initialize distances and visited array
    for (int v=0;v<30;v++) {
        dist[v] = 100;
        parent[v] = 100;
        path_planned[v] = 0;
    }
    
    
    //uint8_t visited[30]={0};



   
    dist[START_POINT] = 0;

    
    for (int count = 0; count < 29; count++) {
        //  uint8_t minDist = 32;
        //  uint8_t u=0;
        minDist = 32;
        u =0;
        for (int v = 0; v < 30; v++) {
            if (!path_planned[v] && dist[v] < minDist) {
                minDist = dist[v];
                u = v;
                //check = minDist;
            }
        }

  
        path_planned[u] = 1;
        
      
        for (int v = 0; v < 30; v++) {
            pointer=(uint8_t *)(nodes+u);
            if (!path_planned[v] && ((pointer[0]==v) || (pointer[1]==v) ||(pointer[2]==v) ||(pointer[3]==v)) && dist[u] + 1 < dist[v]) {
                dist[v] = dist[u] + 1;
                parent[v] = u;
            }
        }
        
    }

   
  
k=END_POINT;


while (parent[k] != 100) {
                
                path_planned[(dist[END_POINT]-idx)]=k;
                idx++;
                k = parent[k];
            }
idx=idx+1;            
path_planned[0]=START_POINT;            


NODE_POINT=START_POINT;
    // ##############################################

    // the node values are written into data memory sequentially.
    for (int v=1; v < idx; ++v) {
        NODE_POINT = path_planned[v];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int v=0; v < idx; ++v) {
            _put_value(path_planned[v]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}

