# 
# Register  ABI Name  Description                        Saver
# --------  --------  ---------------------------------  ------
#   x0      zero      Hard-wired zero                    —
#   x1      ra        Return address                     Caller
#   x2      sp        Stack pointer                      Callee
#   x3      gp        Global pointer                     —
#   x4      tp        Thread pointer                     —
#   x5      t0        Temporary/alternate link register  Caller
#   x6–7    t1–2      Temporaries                        Caller
#   x8      s0/fp     Saved register/frame pointer       Callee
#   x9      s1        Saved register                     Callee
#   x10–11  a0–1      Function arguments/return values   Caller
#   x12–17  a2–7      Function arguments                 Caller
#   x18–27  s2–11     Saved registers                    Callee
#   x28–31  t3–6      Temporaries                        Caller
#
	.global _start

	.data	
var_a:
	.word 10	# Global variable



	.text
_start:	
	addi t0, zero, 1	# t0 = 1 	#0
	addi t1, zero, -1	# t1 = -1	#4
	add  t0, t0, t0		# t0 = 2	#8
	add  t1, t1, t1		# t1 = -2	#12
	add t2, t1, t0		# t2 = 0	#16
	bne t1, zero, pass				#20
	beq t1, zero, failed			#24
	j failed2						#28
	

pass:
	ble t1, zero, step2				#32
	
	j pass							#36
	
step2:
	ble t2, zero, step3				#40
	
step3:
	ble t2, t1, failed				#44

	
	.org 1024
failed:
	j failed	
failed2:
	j failed2
