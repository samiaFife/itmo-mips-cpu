
## [`bobble.dat`](./bobble.dat)

На вход подаётся массив [10, 9, 8, 7, 6, 5, 4, 3, 2, 1], который сортируется с помощью сортировки пузырьком. Лучше сделать не менее 1000 тактов.
 
```
addi $t8 $0 0 
addi $t2 $0 10 
addi $t4 $0 -1 
addi $t5 $0 10  
addi $t6 $0 1 
for_loop_0:
    addi $t4 $t4 1 
    beq $t4 $t2 end_0 (9) 
    addi $s3 $0 0 
    add $s3 $s3 $t4 
    add $s3 $s3 $t4 
    add $s3 $s3 $t4 
    add $s3 $s3 $t4  
    sw $t5 0($s3) 
    sw $t5 48($s3) 
    sub $t5 $t5 $t6 
    j for_loop_0 (5)
end_0:
	addi $t2 $t2 -1 
    addi $t0 $0 -1 
for_loop_1:
    addi $t0 $t0 1
    beq $t0 $t2 end (22)
    addi $t1 $0 -1
	addi $s2 $0 9 
    sub $s2 $s2 $t0
for_loop_2:
    addi $t1 $t1 1
    beq $t1 $s2 for_loop_1 (16)
    addi $s3 $0 0
    add $s3 $s3 $t1
    add $s3 $s3 $t1
    add $s3 $s3 $t1
    add $s3 $s3 $t1
    add $s4 $0 $s3
    addi $s4 $s4 4
    lw $s0 48($s3)
    lw $s1 48($s4)
    slt $s5 $s1 $s0
    beq $s5 $t8 swap (1)
    j for_loop_2 (23)
swap:
    add $t9 $0 $s0
    sw $s1 48($s3)
    sw $t9 48($s4)
    j for_loop_2 (23)
	j for_loop_1 (18)
end:
    addi $t0 $t0 0
```
Ожидаемый результат:
```
Register:          8, value:          9
Register:          9, value:          1
Register:         10, value:          9
Register:         11, value:          0
Register:         12, value:         10
Register:         13, value:          0
Register:         14, value:          1
Register:         15, value:          0
Register:         16, value:          2
Register:         17, value:          1
Register:         18, value:          1
Register:         19, value:          0
Register:         20, value:          4
Register:         21, value:          1
Register:         22, value:          0
Register:         23, value:          0
Register:         24, value:          1
Register:         25, value:          2
...
Addr:          0, value:         10
Addr:          4, value:          9
Addr:          8, value:          8
Addr:         12, value:          7
Addr:         16, value:          6
Addr:         20, value:          5
Addr:         24, value:          4
Addr:         28, value:          3
Addr:         32, value:          2
Addr:         36, value:          1
Addr:         40, value:          0
Addr:         44, value:          0
Addr:         48, value:          1
Addr:         52, value:          2
Addr:         56, value:          3
Addr:         60, value:          4
Addr:         64, value:          5
Addr:         68, value:          6
Addr:         72, value:          7
Addr:         76, value:          8
Addr:         80, value:          9
Addr:         84, value:         10
```
