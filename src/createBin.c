#include <stdio.h> 

createBinary(int *n, int *ml, int *returned)
{
    int counter;
    int num = *n;
    int maskLength = *ml;
    int maskPtr = maskLength-1;
    
    int i;
    for(i=0; i < maskLength; i++)
    	returned[i] = 0;
    
    for (counter=0; counter<=maskLength-1; counter++)
    {
        returned[maskPtr] = ((num >> counter) & 1);
        maskPtr--;
    }
}
