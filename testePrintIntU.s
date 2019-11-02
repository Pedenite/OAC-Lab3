.text
	la tp,exceptionHandling	# carrega em tp o endereï¿½o base das rotinas do sistema ECALL
 	csrrw zero,5,tp 	# seta utvec (reg 5) para o endereï¿½o tp
 	csrrsi zero,0,1 	# seta o bit de habilitaï¿½ï¿½o de interrupï¿½ï¿½o em ustatus (reg 0)	

# Obs: A rotina Print Int Unsigned está na linha 1525 do SYSTEMv17.s
# Problema: valores maiores que 0x7fffffff estão bugados (o mesmo acontece para 0x80000000 no Print Int normal)
li a0, 0x80000000
li a1, 0
li a2, 0
li a3, 0x0ff
li a4, 0
li a7, 136
ecall

li a7, 10
ecall

.include "SYSTEMv17.s"
