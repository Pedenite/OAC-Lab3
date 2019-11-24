.eqv A 0x038		#cor da linha
.eqv C 0x03f		#cor a pintar

.data
# A retangulo = 0x038
# A circulo = 0x000
# A poligono = 0x007
# A engrenagem = 0x0c0

FLOAT:		.float 	3.14159265659
frequencia:	.string "Frequencia ="		# 13*8 = 104
ciclos:		.string "Ciclos ="		# 9*8 = 72
instrucoes:	.string "Instrucoes ="		# 13*8 = 104
tempoM:		.string "Tempo Medido ="	# 15*8 = 120
cpi:		.string "CPI media ="		# 12*8 = 96
tempoC:		.string "Tempo Calculado ="	# 18*8 = 144
.text

MAIN:
la tp,exceptionHandling	# carrega em tp o endere�o base das rotinas do sistema ECALL
csrrw zero,5,tp 	# seta utvec (reg 5) para o endere�o tp
csrrsi zero,0,1 	# seta o bit de habilita��o de interrup��o em ustatus (reg 0)

li a0, 160		#x
li a1, 30		#y
li a2, C		#cor a pintar
li a3, A		#cor da linha
jal PREENCHE

csrrci s0, 3072, 0	#cycle
csrrci s2, 3073, 0	#time
csrrci s1, 3074, 0	#instret
addi s1, s1, -2		#para pegar o valor de instru��es no momento em que a fun��o preenche acaba

fcvt.s.w ft0, s1		# instret
fcvt.s.w ft1, s0		# ciclos
fdiv.s  ft2, ft1, ft0		# Calcula CPI = Ciclos/I
fcvt.s.w ft6, s2		# texe
fcvt.s.w ft3, zero

li a0, 0
li a1, 1
li a7, 148		# clear screen
ecall

FREQ: 	li t0,0 
	la t1,FLOAT
	flw f0,0(t1)
	fmv.x.s t0,f0
	beq t0,zero,FORAFREQ  # testa para ver se tem a FPU

  	li a7,104
	la a0,frequencia
	li a1,0
	li a2,0
	li a3,0x0ff
	li a4,1
	ecall

	# syscall read freq
	li a7,46
	ecall
	
	fmv.s ft5, fa0	# guarda frequencia em ft5
	
	li a7,102
	li a1,104
	li a2,0
	li a3,0x0ff
	li a4,1
	ecall
FORAFREQ:

la a0, ciclos		# Ciclos
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
li a7, 136
ecall

la a0, instrucoes	# Instru��es
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
li a7, 136
ecall

la a0, tempoM		# Tempo medido
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
li a7, 136
ecall

la a0, cpi		# CPI
li a1, 0
li a2, 48
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

fadd.s fa0, ft2, ft3
li a1, 96
li a2, 48
li a3, 0x0ff
li a4, 1
li a7, 102
ecall

la a0, tempoC		# Tempo calculado
li a1, 0
li a2, 60
li a3, 0x0ff
li a4, 1
li a7, 104
ecall

fmul.s ft4, ft0, ft2
li t0, 1
fcvt.s.w ft7, t0
fdiv.s ft5, ft7, ft5		# T = 1/freq 
fmul.s ft4, ft4, ft5		# Calcula texe = I*CPI*T

fadd.s fa0, ft4, ft3
li a1, 144
li a2, 60
li a3, 0x0ff
li a4, 1
li a7, 102
ecall

li a7, 10
ecall

.include "SYSTEMv17.s"
.include "preenche.asm"
