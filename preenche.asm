PREENCHE:
li t0, 320
mul t0, a1, t0
add a0, t0, a0
li t0, 0xff000000
add a0, a0, t0
#mv gp, sp			#para comparacao
mv t2, sp			#endereço da pilha inicial
li t3, 150000
sub t3, sp, t3			#pega quase o ultimo endereço da fgpa

RECURSIVO:
	addi sp, sp, -8	
	#bgt sp, gp, PULA
	#mv gp, sp		#pega o menor valor de sp utilizado
PULA:	sw ra, 4(sp) 	#Guarda ra
	sw a0, 0(sp)	#Guarda coordenada
	esquerda:	lbu t0, -1(a0)		#Carrega cor da coordenada a esquerda
			beq t0, a3, abaixo 	#Verifica se Ã© linha
			beq t0, a2, abaixo	#Verifica se Ã© jÃ¡ foi pintado
			addi a0, a0, -1		#Vai para esquerda 
			sb a2, 0(a0)		#Pinta de vermelho
			jal RECURSIVO
		
	abaixo:		lbu t0, 320(a0)
			beq t0, a3, voltar
			beq t0, a2, direita
			addi a0, a0, 320
			sb a2, 0(a0)
			jal RECURSIVO
		
	direita:	lbu t0, 1(a0)
			beq t0, a3, voltar
			beq t0, a2, acima
			addi a0, a0, 1	
			sb a2, 0(a0)
			jal RECURSIVO
		 
	acima:		lbu t0, -320(a0)
			beq t0, a3, voltar
			beq t0, a2, voltar
			addi a0, a0, -320
			sb a2, 0(a0)
			jal RECURSIVO
		
	voltar:		ble sp, t3, voltarTudo
			lw a0, 0(sp)		# devolve o valor da coordenada
			lw ra, 4(sp)		# devolve o valor de ra
			addi sp, sp, 8		
			ret
			
	voltarTudo:	addi sp, t2, -8
			lw a0, 0(sp)
			lw ra, -4(sp)
			addi a0, a0, -320
			ret
