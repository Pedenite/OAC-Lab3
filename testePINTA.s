.eqv A 0x0c0		#cor da linha
.eqv C 0x03f		#cor a pintar

.data

.include "exemplos/engrenagem.data"
frequencia:	.string "Frequencia ="		# 13*8 = 104
ciclos:		.string "Ciclos ="		# 9*8 = 72
instrucoes:	.string "Instrucoes ="		# 13*8 = 104
tempoM:		.string "Tempo Medido ="	# 15*8 = 120
cpi:		.string "CPI media ="		# 12*8 = 96
tempoC:		.string "Tempo Calculado ="	# 18*8 = 144

.text

MAIN:
la tp,exceptionHandling	# carrega em tp o endereï¿½o base das rotinas do sistema ECALL
csrrw zero,5,tp 	# seta utvec (reg 5) para o endereï¿½o tp
csrrsi zero,0,1 	# seta o bit de habilitaï¿½ï¿½o de interrupï¿½ï¿½o em ustatus (reg 0)

# Carrega a imagem1
FORA:	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,engrenagem		# endereï¿½o dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informaï¿½ï¿½es de nlin ncol
LOOP1: 	beq t1,t2,FORA1		# Se for o ï¿½ltimo endereï¿½o entï¿½o sai do loop
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na memï¿½ria VGA
	addi t1,t1,4		# soma 4 ao endereï¿½o
	addi s1,s1,4
	j LOOP1			# volta a verificar
FORA1:

li a0, 160		#x
li a1, 30		#y
li a2, C		#cor a pintar
li a3, A		#cor da linha
jal PREENCHE

csrrci s0, 3072, 0	#cycle
csrrci s2, 3073, 0	#time
csrrci s1, 3074, 0	#instret
addi s1, s1, -2		#para pegar o valor de instruções no momento em que a função preenche acaba

la a0, frequencia
li a1, 0
li a2, 0
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

la a0, ciclos
li a1, 0
li a2, 12
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

mv a0, s0
li a1, 72
li a2, 12
li a3, 0x0ff
li a4, 1
li a7, 101
ecall

la a0, instrucoes
li a1, 0
li a2, 24
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

mv a0, s1
li a1, 104
li a2, 24
li a3, 0x0ff
li a4, 1
li a7, 101
ecall

la a0, tempoM
li a1, 0
li a2, 36
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

mv a0, s2
li a1, 120
li a2, 36
li a3, 0x0ff
li a4, 1
li a7, 101
ecall

la a0, cpi
li a1, 0
li a2, 48
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

la a0, tempoC
li a1, 0
li a2, 60
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

li a7, 10
ecall

.include "SYSTEMv17.s"
.include "preenche.asm"
