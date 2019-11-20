.text
	la tp,exceptionHandling	# carrega em tp o endere�o base das rotinas do sistema ECALL
 	csrrw zero,5,tp 	# seta utvec (reg 5) para o endere�o tp
 	csrrsi zero,0,1 	# seta o bit de habilita��o de interrup��o em ustatus (reg 0)	

# Obs: A rotina Print Int Unsigned est� na linha 1525 do SYSTEMv17.s

li a0, 0xffffffff
li a1, 0
li a2, 0
li a3, 0x0ff
li a4, 0
li a7, 136
ecall

li a7, 10
ecall

.include "SYSTEMv17.s"
