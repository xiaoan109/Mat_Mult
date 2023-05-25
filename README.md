### This is a simple implementation of hardware acceleration on matrix multiplication.

#### The working flow:
##### 1. NICE request and instrution decode -> get the configuration information
##### 2. Load RHS
##### 3. Load LHS and start PE to get a 4x16 result 
##### 4. Store the result to main memory
##### 5. Go through the remaining LHS_ROWS(first) and RHS_COLS(second), thus, return to Step 3 or Step 2 respectively.
##### 6. Finish the matrix multiplication
