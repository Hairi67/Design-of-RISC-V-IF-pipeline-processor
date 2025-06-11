.equ GPIO_ADDR_OUT, 0x7004 # GPIO for ROWS
.equ GPIO_ADDR_IN,  0x7810 # GPIO for COLUMNS

jal  x1, power_reset_lcd
jal  x1, init_lcd

##############################################################################################################
start:
    # Initialize GPIO for keypad
	li x24, 0x2010		   # x24 = Stack pointer
    li x6, 0x7004          # GPIO output address (rows)
    li x9, 0x7810          # GPIO input address (columns)
##############################################################################################################
#Phase 1: Input the first number
Phase_I:
# x14 = char counter
# x15 = char counter after "."
# x23 = "." counter
    # Step 1: Scan once
    jal x1, scan_keypad
    mv x11, x8             # Save first scan result

    # Step 2: Wait for stability
    jal x1, debounce_delay

    # Step 3: Scan again
    jal x1, scan_keypad
    mv x12, x8             # Save second scan result

    # Step 4: Compare both scans
    bne x11, x12, Phase_I

    # Step 5: Now x8 holds valid key press (column bits)
    li x10, 1            
    beq x8, x10, handle_key0
    li x10, 2 
    beq x8, x10, handle_key1
    li x10, 3 
    beq x8, x10, handle_key2
    li x10, 10
    beq x8, x10, handle_key3
    li x10, 4 
    beq x8, x10, handle_key4
    li x10, 5 
    beq x8, x10, handle_key5
    li x10, 6 
    beq x8, x10, handle_key6
    li x10, 11 
    beq x8, x10, handle_key7
    li x10, 7 
    beq x8, x10, handle_key8
    li x10, 8 
    beq x8, x10, handle_key9
    li x10, 9 
    beq x8, x10, handle_key10
    li x10, 12 
    beq x8, x10, handle_key11
    li x10, 14 
    beq x8, x10, handle_key12
    li x10, 100 
    beq x8, x10, handle_key13
    li x10, 15 
    beq x8, x10, handle_key14
    li x10, 13
    beq x8, x10, handle_key15


    j Phase_I

#######################################################
# SCAN KEYPAD (scan one row at a time and OR result)
# returns: x8 = result (lower 4 bits)
scan_keypad:
    li x8, 0              # clear result

    # --- Scan Row 0 (R0 low, others high) ---
    li x2, 0x0E           # 1110_0000
    sb x2, 0(x6)

# short_delay_1:
    li x31, 100
delay_loop_1:
    addi x31, x31, -1
    bnez x31, delay_loop_1
    

    lbu x7, 0(x9)
    andi x7, x7, 0x0F
    
    # Check key 1 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_1

finish_key1: 

    # Check key 2 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_2    

finish_key2: 

    # Check key 3 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_3

finish_key3:

    # Check key A press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_A

finish_keyA:

    # --- Scan Row 1 ---
    li x2, 0x0D           # 1101_0000
    sb x2, 0(x6)


#short_delay_2:
    li x31, 100
delay_loop_2:
    addi x31, x31, -1
    bnez x31, delay_loop_2


    lbu x7, 0(x9)
    andi x7, x7, 0x0F

    # Check key 4 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_4

finish_key4:

    # Check key 5 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_5

finish_key5:

    # Check key 6 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_6

finish_key6:

    # Check key B press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_B

finish_keyB:

    # --- Scan Row 2 ---
    li x2, 0x0B           # 1011_0000
    sb x2, 0(x6)
#short_delay_3:
    li x31, 100
delay_loop_3:
    addi x31, x31, -1
    bnez x31, delay_loop_3

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

         # Check key 7 press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_7

finish_key7:

        # Check key 8 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_8
    
finish_key8:

        # Check key 9 press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_9
    
finish_key9:

        # Check key C press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_C  
finish_keyC:

    # --- Scan Row 3 ---
    li x2, 0x07           # 0111_0000
    sb x2, 0(x6)
#short_delay_4:
    li x31, 100
delay_loop_4:
    addi x31, x31, -1
    bnez x31, delay_loop_4

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

           # Check key * press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_sao

finish_keysao:
    
        # Check key 0 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_0

finish_key0:
    
        # Check key # press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_thang
    
finish_keythang:
        # Check key D press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_D

finish_keyD:

ret
#################################################################
return_1:
    li x8, 1      # return_1
    bnez x8, finish_key1

return_2:
    li x8, 2      # return_2
    bnez x8, finish_key2

return_3:
    li x8, 3      # return_3
    bnez x8, finish_key3

return_A:
    li x8, 10     # return_A
    bnez x8, finish_keyA

return_4:
    li x8, 4      # return_4
    bnez x8, finish_key4

return_5:
    li x8, 5      # return_5
    bnez x8, finish_key5

return_6:
    li x8, 6      # return_6
    bnez x8, finish_key6

return_B:
    li x8, 11     # return_B
    bnez x8, finish_keyB

return_7:
    li x8, 7      # return_7
    bnez x8, finish_key7

return_8:
    li x8, 8      # return_8
    bnez x8, finish_key8

return_9:
    li x8, 9      # return_9
    bnez x8, finish_key9

return_C:
    li x8, 12     # return_C
    bnez x8, finish_keyC

return_sao:
    li x8, 14     # return_sao
    bnez x8, finish_keysao

return_0:
    li x8, 100      # return_0
    bnez x8, finish_key0

return_thang:
    li x8, 15     # return_thang
    bnez x8, finish_keythang

return_D:
    li x8, 13     # return_D
    bnez x8, finish_keyD

#######################################################
# DEBOUNCE DELAY ~10–20 ms
debounce_delay:
    li x31, 5000
outer_loop_1:
    li x30, 2000
inner_loop_1:
    addi x30, x30, -1
    bnez x30, inner_loop_1
    addi x31, x31, -1
    bnez x31, outer_loop_1
    ret

###############################################################################################################
   
handle_key0:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_1_I 

1_I:
li   x21, 1 			# Write data RS = 1
li   x20, 49            # Data content: 1  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 1
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_1_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 1_I

handle_key1:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_2_I 

2_I:
li   x21, 1 			# Write data RS = 1
li   x20, 50            # Data content: 2  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 2
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_2_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 2_I

handle_key2:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_3_I 

3_I:
li   x21, 1 			# Write data RS = 1
li   x20, 51            # Data content: 3  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 3
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_3_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 3_I


handle_key3:

beqz x14, Phase_I		#skip if char = 0
li x22, 1
bge x15, x22, Plus_I	#proceed if char after "." >0
beqz x23, Phase_I		#skip if "." = 0
j Phase_I 				#skip if nothing
Plus_I:
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 43            # Data content: +  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 10
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_II


handle_key4:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_4_I 

4_I:
li   x21, 1 			# Write data RS = 1
li   x20, 52            # Data content: 4  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 4
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_4_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 4_I

handle_key5:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_5_I 

5_I:
li   x21, 1 			# Write data RS = 1
li   x20, 53            # Data content: 5  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 5
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_5_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 5_I

handle_key6:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_6_I 

6_I:
li   x21, 1 			# Write data RS = 1
li   x20, 54            # Data content: 6  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 6
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_6_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 6_I

handle_key7:
#B
beqz x14, Phase_I		#skip if char = 0
li x22, 1
bge x15, x22, Subtract_I#proceed if char after "." >0
beqz x23, Phase_I		#skip if "." = 0
j Phase_I 				#skip if nothing
Subtract_I:
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 45            # Data content: -  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 11
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_II


handle_key8:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_7_I 

7_I:
li   x21, 1 			# Write data RS = 1
li   x20, 55            # Data content: 7  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 7
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_7_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 7_I

handle_key9:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_8_I 

8_I:
li   x21, 1 			# Write data RS = 1
li   x20, 56            # Data content: 8  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 8
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_8_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 8_I

handle_key10:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_9_I 

9_I:
li   x21, 1 			# Write data RS = 1
li   x20, 57            # Data content: 9  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 9
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_9_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 9_I

handle_key11:

#C
beqz x14, Phase_I		#skip if char = 0
li x22, 1
bge x15, x22, Multipy_I	#proceed if char after "." >0
beqz x23, Phase_I		#skip if "." = 0
j Phase_I 				#skip if nothing
Multipy_I:
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 42            # Data content: *  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 12
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_II

handle_key12:

#*
beqz x14, Phase_I		#skip if char = 0
addi x23, x23, 1 		#"." counter + 1
li x22, 2				
bge x23, x22, Phase_I	#"." counter = 2 => igonre

li   x21, 1 			# Write data RS = 1
li   x20, 46            # Data content: .  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 15
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

handle_key13:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
beq x14, x22, Phase_I	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
beq x23, x22, Char_after_0_I 

0_I:
li   x21, 1 			# Write data RS = 1
li   x20, 48            # Data content: 0  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 0
sw x22, 0(x24)
addi x24, x24, 4
j wait_release

Char_after_0_I:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 0_I

handle_key14:
#skip if user press # in this phase
j Phase_I

handle_key15:
#D
beqz x14, Phase_I		#skip if char = 0
li x22, 1
bge x15, x22, Divided_I	#proceed if char after "." >0
beqz x23, Phase_I		#skip if "." = 0
j Phase_I 				#skip if nothing
Divided_I:
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 47            # Data content: /  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 13
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_II

    # Wait for key release	
wait_release:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_I         # If all columns are high, jump to start
    j wait_release
	
##############################################################################################################
#Pre Phase 2: for reset stuff 
Pre_Phase_II:
	li x14, 0
	li x15, 0
	li x23, 0
wait_release_Pre_II:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_II         # If all columns are high, jump to start
    j wait_release_Pre_II

##############################################################################################################
#Phase 2: input the operator
Phase_II:
    # Step 1: Scan once
    jal x1, scan_keypad_II
    mv x11, x8             # Save first scan result

    # Step 2: Wait for stability
    jal x1, debounce_delay_II

    # Step 3: Scan again
    jal x1, scan_keypad_II
    mv x12, x8             # Save second scan result

    # Step 4: Compare both scans
    bne x11, x12, Phase_II

    # Step 5: Now x8 holds valid key press (column bits)
    li x10, 1            
    beq x8, x10, handle_key0_II
    li x10, 2 
    beq x8, x10, handle_key1_II
    li x10, 3 
    beq x8, x10, handle_key2_II
    li x10, 10
    beq x8, x10, handle_key3_II
    li x10, 4 
    beq x8, x10, handle_key4_II
    li x10, 5 
    beq x8, x10, handle_key5_II
    li x10, 6 
    beq x8, x10, handle_key6_II
    li x10, 11 
    beq x8, x10, handle_key7_II
    li x10, 7 
    beq x8, x10, handle_key8_II
    li x10, 8 
    beq x8, x10, handle_key9_II
    li x10, 9 
    beq x8, x10, handle_key10_II
    li x10, 12 
    beq x8, x10, handle_key11_II
    li x10, 14 
    beq x8, x10, handle_key12_II
    li x10, 100 
    beq x8, x10, handle_key13_II
    li x10, 15 
    beq x8, x10, handle_key14_II
    li x10, 13
    beq x8, x10, handle_key15_II


    j Phase_II

#######################################################
# SCAN KEYPAD (scan one row at a time and OR result)
# returns: x8 = result (lower 4 bits)
scan_keypad_II:
    li x8, 0              # clear result

    # --- Scan Row 0 (R0 low, others high) ---
    li x2, 0x0E           # 1110_0000
    sb x2, 0(x6)

# short_delay_1:
    li x31, 100
delay_loop_1_II:
    addi x31, x31, -1
    bnez x31, delay_loop_1_II
    
    lbu x7, 0(x9)
    andi x7, x7, 0x0F
    
    # Check key 1 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_1_II

finish_key1_II: 

    # Check key 2 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_2_II    

finish_key2_II: 

    # Check key 3 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_3_II

finish_key3_II:

    # Check key A press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_A_II

finish_keyA_II:
    # --- Scan Row 1 ---
    li x2, 0x0D           # 1101_0000
    sb x2, 0(x6)

#short_delay_2:
    li x31, 100
delay_loop_2_II:
    addi x31, x31, -1
    bnez x31, delay_loop_2_II

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

    # Check key 4 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_4_II

finish_key4_II:

    # Check key 5 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_5_II

finish_key5_II:

    # Check key 6 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_6_II

finish_key6_II:

    # Check key B press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_B_II

finish_keyB_II:

    # --- Scan Row 2 ---
    li x2, 0x0B           # 1011_0000
    sb x2, 0(x6)
#short_delay_3:
    li x31, 100
delay_loop_3_II:
    addi x31, x31, -1
    bnez x31, delay_loop_3_II

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

         # Check key 7 press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_7_II

finish_key7_II:

        # Check key 8 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_8_II
    
finish_key8_II:

        # Check key 9 press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_9_II
    
finish_key9_II:

        # Check key C press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_C_II  
finish_keyC_II:

    # --- Scan Row 3 ---
    li x2, 0x07           # 0111_0000
    sb x2, 0(x6)
#short_delay_4:
    li x31, 100
delay_loop_4_II:
    addi x31, x31, -1
    bnez x31, delay_loop_4_II

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

           # Check key * press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_sao_II

finish_keysao_II:
    
        # Check key 0 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_0_II

finish_key0_II:
    
        # Check key # press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_thang_II
    
finish_keythang_II:
        # Check key D press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_D_II

finish_keyD_II:

ret
#################################################################
return_1_II:
    li x8, 1      # return_1_II
    bnez x8, finish_key1_II

return_2_II:
    li x8, 2      # return_2_II
    bnez x8, finish_key2_II

return_3_II:
    li x8, 3      # return_3_II
    bnez x8, finish_key3_II

return_A_II:
    li x8, 10     # return_A_II
    bnez x8, finish_keyA_II

return_4_II:
    li x8, 4      # return_4_II
    bnez x8, finish_key4_II

return_5_II:
    li x8, 5      # return_5_II
    bnez x8, finish_key5_II

return_6_II:
    li x8, 6      # return_6_II
    bnez x8, finish_key6_II

return_B_II:
    li x8, 11     # return_B_II
    bnez x8, finish_keyB_II

return_7_II:
    li x8, 7      # return_7_II
    bnez x8, finish_key7_II

return_8_II:
    li x8, 8      # return_8_II
    bnez x8, finish_key8_II

return_9_II:
    li x8, 9      # return_9_II
    bnez x8, finish_key9_II

return_C_II:
    li x8, 12     # return_C_II
    bnez x8, finish_keyC_II

return_sao_II:
    li x8, 14     # return_sao_II
    bnez x8, finish_keysao_II

return_0_II:
    li x8, 100      # return_0_II
    bnez x8, finish_key0_II

return_thang_II:
    li x8, 15     # return_thang_II
    bnez x8, finish_keythang_II

return_D_II:
    li x8, 13     # return_D_II
    bnez x8, finish_keyD_II

#######################################################
# DEBOUNCE DELAY ~10–20 ms
debounce_delay_II:
    li x31, 5000
outer_loop_1_II:
    li x30, 2000
inner_loop_1_II:
    addi x30, x30, -1
    bnez x30, inner_loop_1_II
    addi x31, x31, -1
    bnez x31, outer_loop_1_II
    ret

###############################################################################################################
   
handle_key0_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 49            # Data content: 1  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 1
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key1_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 50            # Data content: 2  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 2
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III


handle_key2_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 51            # Data content: 3  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 3
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III



handle_key3_II:

li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 43            # Data content: +  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

addi x24, x24, -4
li x22, 10
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_II


handle_key4_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 52            # Data content: 4  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 4
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key5_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 53            # Data content: 5  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 5
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key6_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 54            # Data content: 6  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 6
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key7_II:

#B
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 45            # Data content: -  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

addi x24, x24, -1
li x22, 11
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_II


handle_key8_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 55            # Data content: 7  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 7
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key9_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 56            # Data content: 8  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 8
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key10_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 57            # Data content: 9  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 9
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key11_II:

#C
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 42            # Data content: *  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

addi x24, x24, -4
li x22, 12
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_II

handle_key12_II:
#skip if user press * in this phase
j Phase_II

handle_key13_II:
addi x14, x14, 1 		#char counter + 1

li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 48            # Data content: 0  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 0
sw x22, 0(x24)
addi x24, x24, 4
j Pre_Phase_III

handle_key14_II:
#skip if user press # in this phase
j Phase_II

handle_key15_II:

#D
li   x21, 0      # RS = 0 for command
li   x20, 0xC0    # Command to set cursor to row 2, col 1
jal  x1, out_lcd # Send command to LCD
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 47            # Data content: /  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

addi x24, x24, -4
li x22, p
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_II

    # Wait for key release	
wait_release_II:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_II         # If all columns are high, jump to start
    j wait_release_II
	
##############################################################################################################
#Just to make sure	
Pre_Phase_III:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_III         # If all columns are high, jump to start
    j Pre_Phase_III
##############################################################################################################
# Phase 3: Input the second number
Phase_III:
    # Step 1: Scan once
    jal x1, scan_keypad_III
    mv x11, x8             # Save first scan result

    # Step 2: Wait for stability
    jal x1, debounce_delay_III

    # Step 3: Scan again
    jal x1, scan_keypad_III
    mv x12, x8             # Save second scan result

    # Step 4: Compare both scans
    bne x11, x12, Phase_III

    # Step 5: Now x8 holds valid key press (column bits)
    li x10, 1            
    beq x8, x10, handle_key0_III
    li x10, 2 
    beq x8, x10, handle_key1_III
    li x10, 3 
    beq x8, x10, handle_key2_III
    li x10, 10
    beq x8, x10, handle_key3_III
    li x10, 4 
    beq x8, x10, handle_key4_III
    li x10, 5 
    beq x8, x10, handle_key5_III
    li x10, 6 
    beq x8, x10, handle_key6_III
    li x10, 11 
    beq x8, x10, handle_key7_III
    li x10, 7 
    beq x8, x10, handle_key8_III
    li x10, 8 
    beq x8, x10, handle_key9_III
    li x10, 9 
    beq x8, x10, handle_key10_III
    li x10, 12 
    beq x8, x10, handle_key11_III
    li x10, 14 
    beq x8, x10, handle_key12_III
    li x10, 100 
    beq x8, x10, handle_key13_III
    li x10, 15 
    beq x8, x10, handle_key14_III
    li x10, 13
    beq x8, x10, handle_key15_III


    j Phase_III

#######################################################
# SCAN KEYPAD (scan one row at a time and OR result)
# returns: x8 = result (lower 4 bits)
scan_keypad_III:
    li x8, 0              # clear result

    # --- Scan Row 0 (R0 low, others high) ---
    li x2, 0x0E           # 1110_0000
    sb x2, 0(x6)

# short_delay_1:
    li x31, 100
delay_loop_1_III:
    addi x31, x31, -1
    bnez x31, delay_loop_1_III
    
    lbu x7, 0(x9)
    andi x7, x7, 0x0F
    
    # Check key 1 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_1_III

finish_key1_III: 

    # Check key 2 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_2_III    

finish_key2_III: 

    # Check key 3 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_3_III

finish_key3_III:

    # Check key A press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_A_III

finish_keyA_III:
    # --- Scan Row 1 ---
    li x2, 0x0D           # 1101_0000
    sb x2, 0(x6)

#short_delay_2:
    li x31, 100
delay_loop_2_III:
    addi x31, x31, -1
    bnez x31, delay_loop_2_III

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

    # Check key 4 press
    li x10, 0x0E                # Column 1 mask (1110)
    beq x7, x10, return_4_III

finish_key4_III:

    # Check key 5 press
    li x10, 0x0D                # Column 2 mask (1101)  
    beq x7, x10, return_5_III

finish_key5_III:

    # Check key 6 press
    li x10, 0x0B                # Column 3 mask (1011)
    beq x7, x10, return_6_III

finish_key6_III:

    # Check key B press
    li x10, 0x07                # Column 4 mask (0111)
    beq x7, x10, return_B_III

finish_keyB_III:

    # --- Scan Row 2 ---
    li x2, 0x0B           # 1011_0000
    sb x2, 0(x6)
#short_delay_3:
    li x31, 100
delay_loop_3_III:
    addi x31, x31, -1
    bnez x31, delay_loop_3_III

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

         # Check key 7 press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_7_III

finish_key7_III:

        # Check key 8 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_8_III
    
finish_key8_III:

        # Check key 9 press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_9_III
    
finish_key9_III:

        # Check key C press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_C_III  
finish_keyC_III:

    # --- Scan Row 3 ---
    li x2, 0x07           # 0111_0000
    sb x2, 0(x6)
#short_delay_4:
    li x31, 100
delay_loop_4_III:
    addi x31, x31, -1
    bnez x31, delay_loop_4_III

    lbu x7, 0(x9)
    andi x7, x7, 0x0F

           # Check key * press
        li x10, 0x0E                # Column 1 mask (1110)
        beq x7, x10, return_sao_III

finish_keysao_III:
    
        # Check key 0 press
        li x10, 0x0D                # Column 2 mask (1101)  
        beq x7, x10, return_0_III

finish_key0_III:
    
        # Check key # press
        li x10, 0x0B                # Column 3 mask (1011)
        beq x7, x10, return_thang_III
    
finish_keythang_III:
        # Check key D press
        li x10, 0x07                # Column 4 mask (0111)
        beq x7, x10, return_D_III

finish_keyD_III:

ret
#################################################################
return_1_III:
    li x8, 1      # return_1_III
    bnez x8, finish_key1_III

return_2_III:
    li x8, 2      # return_2_III
    bnez x8, finish_key2_III

return_3_III:
    li x8, 3      # return_3_III
    bnez x8, finish_key3_III

return_A_III:
    li x8, 10     # return_A_III
    bnez x8, finish_keyA_III

return_4_III:
    li x8, 4      # return_4_III
    bnez x8, finish_key4_III

return_5_III:
    li x8, 5      # return_5_III
    bnez x8, finish_key5_III

return_6_III:
    li x8, 6      # return_6_III
    bnez x8, finish_key6_III

return_B_III:
    li x8, 11     # return_B_III
    bnez x8, finish_keyB_III

return_7_III:
    li x8, 7      # return_7_III
    bnez x8, finish_key7_III

return_8_III:
    li x8, 8      # return_8_III
    bnez x8, finish_key8_III

return_9_III:
    li x8, 9      # return_9_III
    bnez x8, finish_key9_III

return_C_III:
    li x8, 12     # return_C_III
    bnez x8, finish_keyC_III

return_sao_III:
    li x8, 14     # return_sao_III
    bnez x8, finish_keysao_III

return_0_III:
    li x8, 100      # return_0_III
    bnez x8, finish_key0_III

return_thang_III:
    li x8, 15     # return_thang_III
    bnez x8, finish_keythang_III

return_D_III:
    li x8, 13     # return_D_III
    bnez x8, finish_keyD_III

#######################################################
# DEBOUNCE DELAY ~10–20 ms
debounce_delay_III:
    li x31, 5000
outer_loop_1_III:
    li x30, 2000
inner_loop_1_III:
    addi x30, x30, -1
    bnez x30, inner_loop_1_III
    addi x31, x31, -1
    bnez x31, outer_loop_1_III
    ret

###############################################################################################################
   
handle_key0_III:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_1_III 

1_III:
li   x21, 1 			# Write data RS = 1
li   x20, 49            # Data content: 1  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 1
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_1_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 1_III

handle_key1_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_2_III 

2_III:
li   x21, 1 			# Write data RS = 1
li   x20, 50            # Data content: 2  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 2
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_2_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 2_III

handle_key2_III:

addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_3_III 

3_III:
li   x21, 1 			# Write data RS = 1
li   x20, 51            # Data content: 3  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 3
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_3_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 3_III

handle_key3_III:
#skip if user press A in this phase
j Phase_III


handle_key4_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_4_III 

4_III:
li   x21, 1 			# Write data RS = 1
li   x20, 52            # Data content: 4  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 4
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_4_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 4_III

handle_key5_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_5_III 

5_III:
li   x21, 1 			# Write data RS = 1
li   x20, 53            # Data content: 5  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 5
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_5_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 5_III

handle_key6_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_6_III 

6_III:
li   x21, 1 			# Write data RS = 1
li   x20, 54            # Data content: 6  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 6
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_6_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 6_III

handle_key7_III:
#skip if user press B in this phase
j Phase_III


handle_key8_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_7_III 

7_III:
li   x21, 1 			# Write data RS = 1
li   x20, 55            # Data content: 7  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 7
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_7_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 7_III

handle_key9_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_8_III 

8_III:
li   x21, 1 			# Write data RS = 1
li   x20, 56            # Data content: 8  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 8
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_8_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 8_III

handle_key10_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_9_III 

9_III:
li   x21, 1 			# Write data RS = 1
li   x20, 57            # Data content: 9  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 9
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_9_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 9_III

handle_key11_III:
#skip if user press C in this phase
j Phase_III

handle_key12_III:
addi x23, x23, 1 		#"." counter + 1
li x22, 2				
bge x23, x22, Phase_III	#"." counter > 2 => igonre

li   x21, 1 			# Write data RS = 1
li   x20, 46            # Data content: .  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 15
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

handle_key13_III:
addi x14, x14, 1 		#Char counter + 1
li x22, 16				
bge x14, x22, Phase_III	#Char counter = 16 => igonre

li x22, 1				#Begin char counter after "." after "." inputed
bge x23, x22, Char_after_0_III 

0_III:
li   x21, 1 			# Write data RS = 1
li   x20, 48            # Data content: 0  
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li x22, 0
sw x22, 0(x24)
addi x24, x24, 4
j wait_release_III

Char_after_0_III:
addi x15, x15, 1		#char counter after "." + 1
bge x15, x0, 0_III

handle_key14_III:
# "="
beqz x14, Phase_III		#skip char = 0 (probably useless, i know)
li x22, 1
bge x15, x22, Next_III	#proceed if char after "." > 0
beqz x23, Phase_III		#skip if "." = 0
j Phase_I 				#skip if nothing
Next_III:
li   x21, 0             # Write command RS = 0
li   x20, 0x01          # Command content: Clear LCD
jal  x1, out_lcd        # Write to LCD
li   x20, 49996         # Delay 2ms
jal  x1, delay

li   x21, 0      		# RS = 0 for command
li   x20, 0x80    		# Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    		# Short delay (~100us)
jal  x1, delay
addi x24, x24, -4
j Pre_Phase_IV

handle_key15_III:
#skip if user press D in this phase
j Phase_III

    # Wait for key release	
wait_release_III:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_III         # If all columns are high, jump to start
    j wait_release_III
	
##############################################################################################################	
#Just to make absolutely sure
Pre_Phase_IV:
    # Check if key release (all columns HIGH)
    # Read columns
    li x11, 0x7810             # Input - columns address
    lb x12, 0(x11)              # Read GPIO state
    andi x12, x12, 0x0F         # Mask columns (GPIO[7:4])

    li x13, 0x0F                # Column all high mask (1111)
    beq x12, x13, Phase_IV         # If all columns are high, jump to start
    j Pre_Phase_IV
##############################################################################################################
# Phase 4: output the result
Phase_IV:
#x24: stack pointer
calculate: 
    li      x5, 1          # multiplier = 1 (ones place)
    li      x7, 0          # result = 0
loop_pop:
    lw      x6, 0(x24)     # load digit
    addi    x24, x24, -4    # stack decrement

    li x31, 0x2008
    beq     x24, x31, end_calculate # check if digit is 0x2008 (end of calculation)

    li x31, 15       # check if digit is decimal point
    beq     x6, x31, int_fract_to_float 

    li x31, 10       # check if digit is addition
    beq     x6, x31, addition

    li x31, 11       # check if digit is subtraction
    beq     x6, x31, subtraction

    li x31, 12       # c6heck if digit is multiplication
    beq     x6, x31, multiplication

    li x31, 13       # check if digit is division
    beq     x6, x31, division

mv    x8, x6         # use digit as counter
mv    x10, x0        # temp = 0

mult_loop:
    beqz  x8, done_mult
    add   x10, x10, x5     # temp += multiplier
    addi  x8, x8, -1       # digit -= 1
    j     mult_loop
done_mult:
    add x7, x7, x10    # result += digit * multiplier

    # --- Update multiplier: multiplier *= 10 ---
    slli    x11, x5, 3     # tmp1 = x5 × 8
    slli    x12, x5, 1     # tmp2 = x5 × 2
    add     x5, x12, x11   # x5 = x5 × 10

    j       loop_pop

int_fract_to_float: ## After handle, return to calculate
    # lưu dấu chấm vào 1 thanh ghi hoặc địa chỉ nào đó
    li x2, 0
    fcvt.s.wu f1, x7  # Convert integer to float

    li x2, 0x0A
    beq x5, x2, DIV10  

    li x2, 0x64
    beq x5, x2, DIV100

    li x2, 0x3E8
    beq x5, x2, DIV1000
	
    DIV10:
    li x4, 0x2004
    li x3, 0x41200000 # 10.0 in float
    sw x3, 0(x4)
    flw f2, 0(x4) # Load 10.0 into f2

    jal x1, div_fract # Call the division function: Divide f1 by 10.0

    j calculate

    DIV100:
    li x4, 0x2004
    li x3, 0x42c80000   # 100.0 in float
    sw x3, 0(x4)
    flw f2, 0(x4) # Load 100.0 into f2

    jal x1, div_fract # Call the division function: Divide f1 by 100.0

    j calculate

    DIV1000:
    li x4, 0x2004
    li x3, 0x447a0000   # 1000.0 in float
    sw x3, 0(x4)
    flw f2, 0(x4) # Load 1000.0 into f2

    jal x1, div_fract # Call the division function: Divide f1 by 1000.0

    j calculate
	
addition:
    li x30, 10  #further checking
    bnez x30, second_number

subtraction:
    li x30, 11
    bnez x30, second_number

multiplication:
    li x30, 12
    bnez x30, second_number

division:
    li x30, 13
    bnez x30, second_number

second_number:
# have_fract:
    fcvt.s.wu f3, x7  # Convert integer of first half to float
    fadd.s f1, f1, f3 # Add float values
    
    li x28, 0x2100
    fsw f1, 0(x28)
    j calculate

end_calculate: 
    #Check dấu, thực hiện phép tính cuối cùng
    li x8, 10
    beq x30, x8, add_frfr

    li x8, 11
    beq x30, x8, sub_frfr

    li x8, 12
    beq x30, x8, mul_frfr

    li x8, 13
    beq x30, x8, div_frfr
    
add_frfr:
    fcvt.s.wu f4, x7
    fadd.s f1,f1,f4

    flw f2, 0(x28)
	
    fadd.s f1,f1,f2
    j display_LCD

sub_frfr:
    fcvt.s.wu f4, x7
    fadd.s f1,f1,f4

    flw f2, 0(x28)

    fsub.s f1,f1,f2
    j display_LCD
	
mul_frfr:
    fcvt.s.wu f4, x7
    fadd.s f1,f1,f4

    flw f2, 0(x28)

    fmul.s f1,f1,f2
    j display_LCD

div_frfr:
    fcvt.s.wu f4, x7
    fadd.s f1,f1,f4

    flw f2, 0(x28)

    jal x1, div_fract # Call the division function: f1/f2

    j display_LCD
  
###########################################
display_LCD:
#Display to LCD
fcvt.wu.s x5, f1 # float to int (extract the decimal) (f1 still hold full float dec and fract)
fcvt.s.wu f2, x5 # float of decimal part

fsub.s f3, f1, f2 #extract the float of fraction

li x6, 0x2104 #temp address for fraction
li x7, 0x461c4000 # 10000 in float
sw x7, 0(x6)
flw f4, 0(x6)
fmul.s f5, f4, f3 #multiply 10000 to take the integer of fraction

fcvt.wu.s x22, f5 #integer of fraction
fcvt.wu.s x10, f2 #integer of decimal

##########################################################################
#Loop for display the decimal

#sub to get the 10000
add x11 ,x0 ,x0      #x11 will have the value tens of thousands of x10
li x13, 10000
DIV10000_dec:
addi x11, x11, 1
sub x10, x10, x13
bge x10, x0 , DIV10000_dec
addi x11, x11 , -1
add x10, x10, x13

#sub to get the 1000
add x18 ,x0 ,x0     #x18 will have the value thousands of x10
addi x13, x0, 1000  #x13 = 1000
DIV1000_dec:
addi x18, x18, 1
sub x10, x10, x13
bge x10, x0 , DIV1000_dec
addi x18, x18 , -1
add x10, x10, x13

add x14 ,x0 ,x0     #x14 will have the value hundreds of x10
addi x13, x0, 100   #x13 = 100
DIV100_dec:
addi x14, x14, 1
sub x10, x10, x13
bge x10, x0 , DIV100_dec
addi x14, x14 , -1
add x10, x10, x13

add x7 ,x0 ,x0     #x7 will have the value dozens of x10
addi x13, x0, 10    #x13 = 10
DIV10_dec:
addi x7, x7, 1
sub x10, x10, x13
bge x10, x0 , DIV10_dec
addi x7, x7 , -1
add x10, x10, x13  #x10 will have the value digits of sw

li   x21, 0      # RS = 0 for command
li   x20, 0x80    # Row 1, column 1
jal  x1, out_lcd
li   x20, 2496    # Short delay (~100us)
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 48              
add  x20, x11, x20		# Data content: tens of thousands of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496 			# Delay 100us
jal  x1, delay

li   x21, 1 			# Write data RS = 1
li   x20, 48              
add  x20, x18, x20		# Data content: thousands of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x14, x20		# Data content: hundreds of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x7, x20		# Data content: dozens of sw
jal  x1, out_lcd 		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x10, x20		# Data content: digits of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay


##########################################################################

#Loop for display fraction

li   x21, 1				# Write data RS = 1
li   x20, 46              
add  x20, x0, x20		# Data content: dot fraction
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

#sub to get the 1000
add x18 ,x0 ,x0     #x18 will have the value thousands of x22
addi x13, x0, 1000  #x13 = 1000
DIV1000_fract:
addi x18, x18, 1
sub x22, x22, x13
bge x22, x0 , DIV1000_fract
addi x18, x18 , -1
add x22, x22, x13

add x14 ,x0 ,x0     #x14 will have the value hundreds of x22
addi x13, x0, 100   #x13 = 100
DIV100_fract:
addi x14, x14, 1
sub x22, x22, x13
bge x22, x0 , DIV100_fract
addi x14, x14 , -1
add x22, x22, x13

add x7 ,x0 ,x0     #x7 will have the value dozens of x22
addi x13, x0, 10    #x13 = 10
DIV10_fract:
addi x7, x7, 1
sub x22, x22, x13
bge x22, x0 , DIV10_fract
addi x7, x7 , -1
add x22, x22, x13  #x22 will have the value digits of sw



li   x21, 1 			# Write data RS = 1
li   x20, 48              
add  x20, x18, x20		# Data content: thousands of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x14, x20		# Data content: hundreds of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x7, x20		# Data content: dozens of sw
jal  x1, out_lcd 		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay

li   x21, 1				# Write data RS = 1
li   x20, 48              
add  x20, x22, x20		# Data content: digits of sw
jal  x1, out_lcd		# Write to LCD
li   x20, 2496			# Delay 100us
jal  x1, delay



end: j end



div_fract:
#This function using f1, f2, f3, f4, f5, f6, f7, f8, f10, x10, x11, x13, x14, x15, x16, x17, x18, x19, x29
li x29, 0x2108 #temp address

    # |N| → f3, |D| → f4
    fabs.s f3, f1           
    fabs.s f4, f2      
    
    # lấy dấu kết quả → f2 giữ bit sign
    fsgnjx.s f2, f1, f2 

    # --- Trích exponent của D ---
    fsw f4, 0(x29)            # store f4 tại địa chỉ 0
    lw  x13, 0(x29)           # bit pattern of D
    srli x14, x13, 23        
    andi x14, x14, 0xFF      # x14 = exp_D

    # Scale D sao cho exp = 126
    li   x15, 126
    li   x16, 0              # scale counter

    ble  x14, x15, scale_up
scale_down:
    beq  x14, x15, scale_done
    addi x14, x14, -1
    addi x16, x16, 1
    j scale_down
scale_up:
    beq  x14, x15, scale_done
    addi x14, x14, 1
    addi x16, x16, -1
    j scale_up
scale_done:

    # clear exponent + gắn exponent mới
    li   x17, 0x807FFFFF
    and  x13, x13, x17       
    slli x14, x14, 23
    or   x13, x13, x14
    sw   x13, 0(x29)
    flw  f4, 0(x29)           # load lại scaled D

    # --- Scale N bằng counter x16 ---
    fsw  f3, 0(x29)
    lw   x18, 0(x29)
    srli x19, x18, 23
    andi x19, x19, 0xFF        # exp_N
    sub  x19, x19, x16         # chỉnh exponent
    and  x18, x18, x17         # clear exponent cũ
    slli x19, x19, 23
    or   x18, x18, x19
    sw   x18, 0(x29)
    flw  f3, 0(x29)             # load lại scaled N

    # Load f5 = 32/17 = 0x3ff0f0f1
    li   x10, 0x3ff0f0f1
    sw   x10, 0(x29)
    flw  f5, 0(x29)

    # Load f6 = 2.0 = 0x40000000
    li   x11, 0x40000000
    sw   x11, 0(x29)
    flw  f6, 0(x29)

    #Load f10 = 48/17 = 0x4034b4b5
    li x11, 0x4034b4b5
    sw x11, 0(x29)
    flw f10, 0(x29)

    # --- Newton-Raphson: 3 vòng lặp ---
    fmul.s f7, f4, f5         # D × 32/17
    fsub.s f7, f10, f7         # x0 = 2 - D×32/17

    # x1 = x0(2 - D×x0)
    fmul.s f8, f4, f7
    fsub.s f8, f6, f8
    fmul.s f7, f7, f8

    # x2 = x1(2 - D×x1)
    fmul.s f8, f4, f7
    fsub.s f8, f6, f8
    fmul.s f7, f7, f8

    # x3 = x2(2 - D×x2)
    fmul.s f8, f4, f7
    fsub.s f8, f6, f8
    fmul.s f7, f7, f8

    # result = N_scaled × x3
    fmul.s f7, f3, f7

    # apply sign
    fsgnj.s f7, f7, f2

    fsw f7, 0(x29)           # store result tại địa chỉ 0
    flw f1, 0(x29)          # load result vào f1

    ret
	
#---------------------------------------------------------------------------
# Using x19 x20 x21 x18 x16 x17
init_lcd:
    addi x16, x1, 0           # Save return address

    li   x21, 0               # Write command RS = 0
    li   x20, 0x38            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 2496             # Delay 100us
    jal  x1, delay

    li   x21, 0               # Write command RS = 0
    li   x20, 0x01            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 49996           # Delay 2ms
    jal  x1, delay

    li   x21, 0               # Write command RS = 0
    li   x20, 0x0C            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 2496             # Delay 100us
    jal  x1, delay

    li   x21, 0               # Write command RS = 0
    li   x20, 0x06            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 2496             # Delay 100us
    jal  x1, delay

    addi x1, x16, 0           # Restore return address
    jalr x0,x1,0             # Return from the function
#---------------------------------------------------------------------------
# Using x19 x20 x21 x18 x16 x17
power_reset_lcd:
    addi x16, x1, 0          # Save return address

    li   x19, 0x7030      # Address of LCD
    li   x20, 0xC0000000      # Turn on LCD and Backlight
    sw   x20, 0(x19)
    li   x20, 499996          # Delay 20ms
    jal  x1, delay

    li   x21, 0              # Write command RS = 0
    li   x20, 0x30            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 104996           # Delay 4.2ms
    jal  x1, delay

    li   x21, 0              # Write command RS = 0
    li   x20, 0x30            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 49996           # Delay 2ms
    jal  x1, delay

    li   x21, 0              # Write command RS = 0
    li   x20, 0x30            # Command content
    jal  x1, out_lcd         # Write to LCD
    li   x20, 49996           # Delay 2ms
    jal  x1, delay

    addi x1, x16, 0          # Restore return address
    jalr x0,x1,0             # Return from the function
#---------------------------------------------------------------------------
# Using x19 x20 x21 x17
# Input x20 = 8-bit command/data; x21 = RS ( Command = 0, Data = 1 )
out_lcd:
    addi x17, x1, 0           # Save return address
    li   x19, 0x7030          # Address of LCD
    beq  x21, x0, command     # If RS = 0
    addi x20, x20, 1536        # ( RS = 1; EN = 1 ) + Data
    j    send
command:
    addi x20, x20, 1024        # ( RS = 0; EN = 1 ) + Command
send:
    sh   x20, 0(x19)
    li   x20, 2496             # Delay 100us
    jal  x1, delay
    sh   x0, 1(x19)           # Pull EN to low for LCD starts executing
    addi x1, x17, 0           # Restore return address
    jalr x0,x1,0             # Return from the function
#---------------------------------------------------------------------------
# Using x20 x18
#CLOCK = 50 000 000Hz
delay:
    # 20ms  = 249998 – 499996
    # 4.2ms =  52498 – 104996
    # 2ms   =  24998 – 49996
    # 200us =   2498 – 4996
    # 100us =    1248 – 2496
    add  x18, x0, x20
delay_loop:
    addi x18, x18, -1          # Decrement the counter
    bne  x18, x0, delay_loop  # If t0 is not zero, branch back to delay_loop
    jalr x0,x1,0             # Return from the function
#---------------------------------------------------------------------------	