#################################### INDICE ###################################################

# multve Feita			049 - 120
# Medv Feita (Working)		122 - 201
# multvv			204 - 294
# addv 				300 - 436
# addiv				438 - 524
# addvf				532 - 650


#530 - 808  ====== Come�a eu e termina eu (renan)


.data

v: .space 100 #vetor de 50 pos
dimensaoRegistrador: .space 4 #tamanho do reg
ponteiroReg: .space 4  #aponta pra onde vai o proximo verot
$informeDimensao: .asciiz"Informe Dimensao do registrador:\n"
$informeErro: .asciiz"Os vetores tem que ter o mesmo comprimento\n"

vetFloat:.word 3
.float 0.5, 0.5, 0.5

meuVetor: .word 3,4,6,8
meuVetor2: .word 3,1,2,3

informeValores: .asciiz"Informe os valores (separados por ENTER):\n"
.text

## Iniciando valores dos ponteiros dos regVetores

	la $t0, v #carrega em t0 o 1� end de ' v '
	la $t1, ponteiroReg #carrega o end de pReg em $t1
	sw $t0, 0($t1) #guarda o 1� de v em pontReg

## ~~

li $v0,4 #comando de impressão de inteiro na tela
la $a0, $informeDimensao #coloca o texto subtração para ser impresso
syscall # efetua a chamada ao sistema


#ler tamanho do registrador
li  $v0, 5
syscall

la $t0,dimensaoRegistrador
sw $v0,0($t0)



j main
#  DEFINICOES DE FUNCOES

# COLOCA EM V0 O NUMERO DE REGISTRADORES
.macro infv()
	la $t0,dimensaoRegistrador
	lw $v0,0($t0)
#jr $ra
.end_macro

##	Macro LIV	##

.macro liv(%reg1, %n)	# Func que fica perguntando os valores do registrador 'n' vezes

	li %reg1, %n #carrega o valor de 'n' no REG	
	la $t0, ponteiroReg #carrego o endere�o do pReg
	lw $t1, 0($t0) #carrego o valor que ta em pReg
	sw %reg1, 0($t1) #salvo o tamanho do reg no primeiro lugar
	
	add %reg1, $t1, $zero #salvo em %reg1 o ponteiro para o primeiro lugar do vetor
	
	##    Loop :D
	li $t2, 0 #O i do meu for
	
	li $v0,4 #comando de impressão de inteiro na tela
	la $a0, informeValores #coloca o texto subtração para ser impresso
	syscall # efetua a chamada ao sistema
	
	loop_macro_liv:
		
		addi $t1, $t1, 4 #vou pra proxima pos do vetor
		
		bge $t2, %n, end_loopMacroLiv #Se for maior ou igual sai do loop
		
		
		#ler tamanho do registrador
		li  $v0, 5
		syscall

		sw $v0,0($t1)
	
	
		addi $t2, $t2, 1
	
		j loop_macro_liv
	
	end_loopMacroLiv:
	
	sw $t1, 0($t0)
	

.end_macro

##	Macro LV		##
.macro lv (%reg1, %vetor)
	
	la %reg1, %vetor

.end_macro

##	Macro SV		##
.macro sv (%reg1, %reg2)


	la $t3, ponteiroReg #carrego end de pReg pra t3
	lw %reg2, 0($t3)	#carrega em reg2 o end de onde vai guardar o vetor (onde pReg aponta)

	lw $t0, 0(%reg1)
	addi $t0, $t0, 1
	
	add $s7, $t0, $zero
	li $t3, 0
	li $t7, 1
	
	
	loop_addv:
	
	slt $s5, $v0, $t0	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $s5, $zero, L4	# Se igual a 0 loop secundario
	
	while_addv:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t8, sec_addv	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %reg1	# desloca posicao a1 + i*4
	add $s2, $t6, %reg2	# desloca posicao a2 + i*4
	#add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
###### Caracteristica da addv
	sw $s1, 0 ($s2)		# guarda o valor de s1(reg1) em s2(reg2)
	
	addi $t3, $t3, 1	# keep on while
	j while_addv
	
	sec_addv:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t0, $t0, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_addv
	
	L4:
	
	for_addv:
	#lw $t2,-4($a0)

	beq $t3, $s7, end_addv	# Se o i chegou ao tamanho do vet --> sai
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %reg1	# desloca posicao a1 + i*4
	add $s2, $t6, %reg2	# desloca posicao a2 + i*4
	#add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
###### Caracteristica da addv
	sw $s1, 0 ($s2)		# guarda o valor de s1(reg1) em s2(reg2)
	
	addi $t3, $t3, 1	# keep on for
	j for_addv		
		
	end_addv:
#	jr $ra

sll $s7, $s7, 2
la $s6, ponteiroReg
lw $s6, 0($s6)
add $s7, $s6, $s7
la $s6, ponteiroReg
sw $s7, 0($s6)
	

.end_macro




############################################ Multve inicio

#multiplica o vetor contido em $a0 ( tamanho contido em $a1 )pela escalar contida em $a2
#multiplica vetor de a0 com constante em a1
.macro multve(%a0,%a1)
	li $t3,0 #indice do loop
	li $t7,1 # var aux
	#add $t6, $zero, $a1
	lw $t6,0(%a0) #carrega tamanho do vetor
	
	addi $sp, $sp, -4
	sw %a0,0($sp) #empilha a0
	
	addi %a0,%a0,4
	
#	addi $sp, $sp, -4
#	sw $ra,0($sp)
	infv()
		
#	lw $ra, 0 ($sp)
#	addi $sp, $sp, 4
		
	## a1 = tamanho vet // v0 = reg. vet
	loop:		############### LOOP Principal ################
	
	#beq $v0, $a1, while	# se tam vet == Reg. vet go to LOOP SEC
	slt $t1, $v0, $t6	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $t1, $zero, L1	# Se igual a 0 loop secundario
	
	while:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t8, sec	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t2, $t3, 2		# i*4
	add $s0, $t2, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
########## Caracteristica da MultVe
	
	mul $t9, $s1, %a1	# multi o valor em vet[i] por a2
	sw $t9, 0($s0)		# guarda novo valor
#######
	addi $t3, $t3, 1	# keep on while
	j while	
	
	sec:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t6, $t6, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop
	
	L1:
	
	for:
	lw $t2,-4(%a0)
	beq $t3, $t2, end_multve	# Se o i chegou ao tamanho do vet --> sai
	
	sll $t4, $t3, 2		# i*4
	add $s0, $t4, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
########### Caracteristica da MultVe
	mul $t9, $s1, %a1	# multi o valor em vet[i] por a2
	sw $t9, 0($s0)		# guarda novo valor
#######	
	addi $t3, $t3, 1	# keep on for
	j for
	
	end_multve:
lw %a0, 0 ($sp)
addi $sp,$sp,4
#jr $ra
.end_macro
######################################### Fim multve

############################################ Inicio medv
#calcula a media do vetor a0 e coloca em f0
.macro medv(%a0)
	li $t3,0 #indice do loop
	li $t7,1 # var aux
	
	### T9 � o somatorio
	li $t9, 0
	lw $t6,0(%a0) #carrega tamanho do vetor
	
	addi $sp, $sp, -4
	sw %a0,0($sp) #empilha a0
	
	addi %a0,%a0,4
	
#	addi $sp, $sp, -4
#	sw $ra,0($sp)
	infv()
		
#	lw $ra, 0 ($sp)
#	addi $sp, $sp, 4
		
	## a1 = tamanho vet // v0 = reg. vet
	loop_media:		############### LOOP Principal ################
	
	#beq $v0, $a1, while	# se tam vet == Reg. vet go to LOOP SEC
	slt $t1, $v0, $t6	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $t1, $zero, L2	# Se igual a 0 loop secundario
	
	while_media:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t8, sec_media	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t2, $t3, 2		# i*4
	add $s0, $t2, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]

###### Caracteristica da Meedia
	add $t9, $t9, $s1	# t9 = Somatorio
	
	addi $t3, $t3, 1	# keep on while
	j while_media
	
	sec_media:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t6, $t6, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_media
	
	L2:
	
	for_media:
	lw $t2,-4(%a0)
	beq $t3, $t2, end_medv	# Se o i chegou ao tamanho do vet --> sai
	
	sll $t4, $t3, 2		# i*4
	add $s0, $t4, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
###### Caracteristica da Meedia	
	add $t9, $t9, $s1	# 
	
	addi $t3, $t3, 1	# keep on for
	j for_media
	
	end_medv:
	
	addi $sp, $sp, -4
	lw $ra, 0($sp)
	
	jal transcode

	sw $ra, 0($sp)
	addi $sp, $sp, 4
	#li $v0, 2
	#syscall
	
	lw %a0, 0 ($sp)
	addi $sp,$sp,4
#	jr $ra
.end_macro

transcode:
	mtc1 $t9, $f2		# transformar int em Float
	cvt.s.w $f2, $f2
	
	mtc1 $t2, $f1		#transformar int em float
	cvt.s.w $f1, $f1
	
	div.s $f0, $f2, $f1	# f0 eh o retorno nos floats
	
jr $ra
################################################### Fim medv

###################################### inicio da MULTVV ######################################

# a0 Vet1 ------- a1 Vet2
.macro multvv(%a0,%a1)
	li $t3,0 #indice do loop
	li $t7,1 # var aux
	li $t9, 0 #Somatorio
	
	lw $t5, 0(%a1)
	lw $t6, 0(%a0) # carrega tamanho do vetor
	
	addi $sp, $sp, -4
	sw %a0, 0($sp) # empilha a0
	addi $sp, $sp, -4
	sw %a1, 0 ($sp)
	
	addi %a0, %a0, 4
	addi %a1, %a1, 4
	
#	addi $sp, $sp, -4
#	sw $ra,0($sp)
	infv()
		
#	lw $ra, 0 ($sp)
#	addi $sp, $sp, 4
	
	beq $t5, $t6, loop_mult
	
	li $v0,4 #comando de impressão de inteiro na tela
	la %a0, $informeErro #coloca o texto subtração para ser impresso
	syscall # efetua a chamada ao sistema
	
	j end_mult
	
	## a1 = tamanho vet // v0 = reg. vet
	loop_mult:		############### LOOP Principal ################
	
	slt $t1, $v0, $t6	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $t1, $zero, L3	# Se igual a 0 loop secundario
	
	while_mult:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t8, sec_mult	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t2, $t3, 2		# i*4
	add $s0, $t2, %a0	# desloca posicao a0 + i*4
	add $s2, $t2, %a1	# desloca posicao a1 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]

###### Caracteristica da Produto Interno
	mul $s4, $s1, $s3
	add $t9, $t9, $s4	# t9 = Somatorio
	
	addi $t3, $t3, 1	# keep on while
	j while_mult
	
	sec_mult:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t6, $t6, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_mult
	
	L3:
	
	for_mult:
	lw $t2,-4(%a0)
	beq $t3, $t2, end_mult	# Se o i chegou ao tamanho do vet --> sai
	
	sll $t4, $t3, 2		# i*4
	add $s0, $t4, %a0	# desloca posicao a0 + i*4
	add $s2, $t4, %a1	# desloca posicao a1 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]
	
###### Caracteristica da Multvv	
	mul $s4, $s1, $s3
	add $t9, $t9, $s4	# t9 = Somatorio
	
	addi $t3, $t3, 1	# keep on for
	j for_mult
	
	end_mult:
	
	add $v0, $zero, $t9
		
	lw %a1, 0 ($sp)
	addi $sp, $sp, 4
	lw %a0, 0 ($sp)
	addi $sp, $sp, 4
#	jr $ra
.end_macro
################################################### Fim MULTVV



################################# ADDV ######################################

.macro addv(%a0,%a1,%a2)

	#salvar os tamanhos de a1 e a2
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	#empilhar parametros	
	addi $sp, $sp, -4
	sw %a0, 0($sp)
	
	
	#somar 4 para que apartir de a1[0] e a2[0] sejam apenas elementos
	addi %a1, %a1, 4
	addi %a2, %a2, 4
	
	slt $t0, $t2, $t1 		# t1 > t2?
	beq $t0, 1, t1_maior
		sw $t2, 0(%a0) 		#salvar em a0[0] tamanho do vetor resultante
		addi $t0, $t2, 0 	#salvar em t0 o tamanho do vetor
		addi $t9, $t1, 0	#salvar em t0 o tamanho do menor vetor
    	j desce
	t1_maior:	
		sw $t1, 0(%a0) 		#salvar em a0[0] tamanho do vetor resultante	
		addi $t0, $t1, 0	#salvar em t0 o tamanho do vetor
		addi $t9, $t2, 0	#salvar em t0 o tamanho do menor vetor
			
	desce:
	addi %a0, %a0, 4 		#soma 4 para que o resto dos elementos sejam apenas os valores
	
	add $s7, $zero, $t0
	li $t7,1 #contador do loop que pega de R em R
#	addi $sp,$sp,-4
#	sw $ra,0($sp)
	addi $sp,$sp,-4
	sw $t0,0($sp)
	
	infv()
	
	lw $t0,0($sp)
	add $sp,$sp,4	
#	lw $ra,0($sp)
#	add $sp,$sp,4	

	
	loop_addv:
	
	slt $s5, $v0, $t0	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $s5, $zero, L4	# Se igual a 0 loop secundario
	
	while_addv:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t9, replace
	beq $t3, $t8, sec_addv	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]
	#lw $s5, 0($a0)		# carrega pos do vetsoma[i]
	
###### Caracteristica da addv
	add $s4, $s1, $s3	# vetA[i] + vetB[i]
	sw $s4, 0 ($s6)		# load o resultado
	
	addi $t3, $t3, 1	# keep on while
	j while_addv
	
	sec_addv:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t0, $t0, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_addv
	
	L4:
	
	for_addv:
	#lw $t2,-4($a0)

	beq $t3, $s7, end_addv	# Se o i chegou ao tamanho do vet --> sai
	beq $t3, $t9, replace
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]
	
###### Caracteristica da addv
	add $s4, $s1, $s3	# vetA[i] + vetB[i]
	sw $s4, 0 ($s6)		# load o resultado
	
	
	addi $t3, $t3, 1	# keep on for
	j for_addv
	
	replace:
	
	beq $t1, $t2, end_addv
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	loop2_addv:
		beq $s7, $t3, end_addv 	#se t3 == ao que falta pra terminar o maior vetor
			
		sgt $t8, $t2, $t1		#qual vetor tem mais elementos?
		beq $t8, 1, a1_maior_addv
		
		
		sll $t6, $t3, 2			#incrementa endereco de a2
		add $s2, $t6, %a2		# a2 (vet)
		add $s6, $t6, %a0		# vet soma (a0)
		lw $s3, 0($s2)			# carregar vet2[i] (a2)
		
		sw $s3, 0 ($s6)			# load
		j desce_adv
			
		a1_maior_addv:
		sll $t6, $t3, 2 		#se a1 tem mais elementos
		add $s0, $t6, %a1
		add $s6, $t6, %a0
		lw $s1, 0($s0)
		
		sw $s1, 0($s6)			#a0[i] = a1[i]
		
			
		desce_adv:
		addi $t3, $t3, 1		#incrementa endereco de a0
		j loop2_addv
		
		
	end_addv:
		
	lw %a0, 0 ($sp)
	addi $sp,$sp,4
#	jr $ra
.end_macro

################################################## FIm addv ######################################

################################################### inicio do addiv
#soma todos os elementos de a0 pela escalar a1
.macro addiv(%a0,%a1)
	li $t3,0 #indice do loop
	li $t7,1 # var aux
	li $t9, 0
	#add $t6, $zero, $a1
	lw $t6,0(%a0) #carrega tamanho do vetor
	
	addi $sp, $sp, -4
	sw %a0,0($sp) #empilha a0
	
	addi %a0, %a0, 4
	
	#addi $sp, $sp, -4
	#sw $ra,0($sp)
	infv()
		
	#lw $ra, 0 ($sp)
	#addi $sp, $sp, 4
		
	## a1 = tamanho vet // v0 = reg. vet
	loop_addiv:		############### LOOP Principal ################
	
	#beq $v0, $a1, while	# se tam vet == Reg. vet go to LOOP SEC
	slt $t1, $v0, $t6	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $t1, $zero, L5	# Se igual a 0 loop secundario
	
	while_addiv:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t8, sec_addiv	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t2, $t3, 2		# i*4
	add $s0, $t2, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
########## Caracteristica da MultVe
	
	add $t9, $s1, %a1	# add o valor em vet[i] por a1
	sw $t9, 0($s0)		# guarda novo valor
#######
	addi $t3, $t3, 1	# keep on while
	j while_addiv	
	
	sec_addiv:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t6, $t6, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_addiv
	
	L5:
	
	for_addiv:
	lw $t2,-4(%a0)
	beq $t3, $t2, end_addiv	# Se o i chegou ao tamanho do vet --> sai
	
	sll $t4, $t3, 2		# i*4
	add $s0, $t4, %a0	# desloca posicao a0 + i*4
	lw $s1, 0($s0)		# carrega posicao vet[i]
	
########### Caracteristica da addvi
	add $t9, $s1, %a1	# multi o valor em vet[i] por a2
	sw $t9, 0($s0)		# guarda novo valor
#######	
	addi $t3, $t3, 1	# keep on for
	j for_addiv
	
	end_addiv:
lw %a0, 0 ($sp)
addi $sp,$sp,4
#jr $ra

.end_macro
####################### fim addiv ###############################


################################## Come�a eu (Renan) ########################################################

.macro addvf(%a0,%a1,%a2)

	#salvar os tamanhos de a1 e a2
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	#empilhar parametros	
	addi $sp, $sp, -4
	sw %a0, 0($sp)
	
	addi $sp, $sp, -4
	sw %a1, 0($sp)
	
	addi $sp, $sp, -4
	sw %a2, 0($sp)
	
	#somar 4 para que apartir de a1[0] e a2[0] sejam apenas elementos
	addi %a1, %a1, 4
	addi %a2, %a2, 4
	
	slt $t0, $t2, $t1 		# t1 > t2?
	beq $t0, 1, t1_maior_f
		sw $t2, 0(%a0) 		#salvar em a0[0] tamanho do vetor resultante
		addi $t0, $t2, 0 	#salvar em t0 o tamanho do vetor
		addi $t9, $t1, 0	#salvar em t0 o tamanho do menor vetor
    	j desce_f
	t1_maior_f:	
		sw $t1, 0(%a0) 		#salvar em a0[0] tamanho do vetor resultante	
		addi $t0, $t1, 0	#salvar em t0 o tamanho do vetor
		addi $t9, $t2, 0	#salvar em t0 o tamanho do menor vetor
			
	desce_f:
	addi %a0, %a0, 4 		#soma 4 para que o resto dos elementos sejam apenas os valores
	
	add $s7, $zero, $t0
	li $t7,1 #contador do loop que pega de R em R
#	addi $sp,$sp,-4
#	sw $ra,0($sp)
	addi $sp,$sp,-4
	sw $t0,0($sp)
	
	infv()
	
	lw $t0,0($sp)
	add $sp,$sp,4	
#	lw $ra,0($sp)
#	add $sp,$sp,4	


	
	loop_addvf:
	
	slt $s5, $v0, $t0	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $s5, $zero, L6	# Se igual a 0 loop secundario
	
	while_addvf:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t9, replace_f
	beq $t3, $t8, sec_addvf	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal carrega_float_1	# 706

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $t3, $t3, 1	# keep on while
	j while_addvf
	
	sec_addvf:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t0, $t0, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_addvf
	
	L6:
	
	for_addvf:
	#lw $t2,-4($a0)

	beq $t3, $s7, end_addvf	# Se o i chegou ao tamanho do vet --> sai
	beq $t3, $t9, replace_f
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal carrega_float_1

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	
	addi $t3, $t3, 1	# keep on for
	j for_addvf
	
	replace_f:
	
	beq $t1, $t2, end_addvf
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	loop2_addvf:
		beq $s7, $t3, end_addvf 	#se t3 == ao que falta pra terminar o maior vetor
			
		sgt $t8, $t2, $t1		#qual vetor tem mais elementos?
		beq $t8, 1, a1_maior_addvf
		
		
		sll $t6, $t3, 2			#incrementa endereco de a2
		add $s2, $t6, %a2		# a2 (vet)
		add $s6, $t6, %a0		# vet soma (a0)
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)
	
		jal carrega_float_2

		lw $ra, 0($sp)
		addi $sp, $sp, 4

		j desce_addvf
			
		a1_maior_addvf:
		sll $t6, $t3, 2 		#se a1 tem mais elementos
		add $s0, $t6, %a1
		add $s6, $t6, %a0
		
		addi $sp, $sp, -4
		lw $ra, 0($sp)
		
		jal carrega_float_3
		
		sw $ra, 0($sp)
		addi $sp, $sp, 4
			
		desce_addvf:
		addi $t3, $t3, 1		#incrementa endereco de a0
		j loop2_addvf
		
		
	end_addvf:
	
	lw %a2, 0 ($sp)
	addi $sp, $sp, 4
	
	lw %a1, 0($sp)
	addi $sp, $sp, 4
		
	lw %a0, 0 ($sp)
	addi $sp,$sp,4
#	jr $ra
.end_macro

carrega_float_1:

	lwc1 $f1, 0($s0)	# Carrega Float em f1
	lwc1 $f2, 0($s2)	# carrega posicao vet2[i]
	#lw $s5, 0($a0)		# carrega pos do vetsoma[i]
	
###### Caracteristica da addvf
	add.s $f4, $f1, $f2	# vetA[i] + vetB[i]
	swc1 $f4, 0 ($s6)		# load o resultado
	
jr $ra


carrega_float_2:

	lwc1 $f2, 0($s2)			# carregar vet2[i] (a2)
	swc1 $f2, 0 ($s6)			# load
		
jr $ra


carrega_float_3:

	lwc1 $f1, 0($s0)
	swc1 $f1, 0($s6)			#a0[i] = a1[i]

jr $ra
############################################### termina froat ###############################

############################ subv #############################

.macro subv(%a0,%a1,%a2)

	#salvar os tamanhos de a1 e a2
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	#empilhar parametros	
	addi $sp, $sp, -4
	sw %a0, 0($sp)
	
	
	#somar 4 para que apartir de a1[0] e a2[0] sejam apenas elementos
	addi %a1, %a1, 4
	addi %a2, %a2, 4
	
	slt $t0, $t1, $t2		# t1 > t2?
	beq $t0, 1, out1
		sw $t1, 0(%a0) 		#salvar em a0[0] tamanho do vetor resultante
		addi $t0, $t1, 0 	#salvar em t0 o tamanho do vetor
		addi $t9, $t2, 0	#salvar em t0 o tamanho do menor vetor
			
	addi %a0, %a0, 4 		#soma 4 para que o resto dos elementos sejam apenas os valores
	
	add $s7, $zero, $t0
	li $t7,1 #contador do loop que pega de R em R
#	addi $sp,$sp,-4
#	sw $ra,0($sp)
	addi $sp,$sp,-4
	sw $t0,0($sp)
	
	infv()
	
	lw $t0,0($sp)
	add $sp,$sp,4	
#	lw $ra,0($sp)
#	add $sp,$sp,4	

	
	loop_subv:
	
	slt $s5, $v0, $t0	# v0 menor precisa de loop (1) // v0 maior = tamanho do vet menor que dimensaoReg (0)
	
	mul $t8, $v0, $t7	# Por beq do while
	beq $s5, $zero, L7	# Se igual a 0 loop secundario
	
	while_subv:		######## LOOP para quando o tam vet > Reg. Vet ##################
	
	beq $t3, $t9, replace_subv
	beq $t3, $t8, sec_subv	# se i == v0 --> Acabou while, vai sec e depois loop
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]
	#lw $s5, 0($a0)		# carrega pos do vetsoma[i]
	
###### Caracteristica da addv
	sub $s4, $s1, $s3	# vetA[i] + vetB[i]
	sw $s4, 0 ($s6)		# load o resultado
	
	addi $t3, $t3, 1	# keep on while
	j while_subv
	
	sec_subv:			####### "Diminui vet" e registra o numero de loops feito
			
	sub $t0, $t0, $v0	# Diminuindo vet
	addi $t7, $t7, 1	# Numero de interacoes ja feitas (mult o v0)
	j loop_subv
	
	L7:
	
	for_subv:
	#lw $t2,-4($a0)

	beq $t3, $s7, end_subv	# Se o i chegou ao tamanho do vet --> sai
	beq $t3, $t9, replace_subv
	
	sll $t6, $t3, 2		# i*4
	add $s0, $t6, %a1	# desloca posicao a1 + i*4
	add $s2, $t6, %a2	# desloca posicao a2 + i*4
	add $s6, $t6, %a0	# desloca posicao do vet que recebe a soma
	lw $s1, 0($s0)		# carrega posicao vet[i]
	lw $s3, 0($s2)		# carrega posicao vet2[i]
	
###### Caracteristica da addv
	sub $s4, $s1, $s3	# vetA[i] + vetB[i]
	sw $s4, 0 ($s6)		# load o resultado
	
	
	addi $t3, $t3, 1	# keep on for
	j for_subv
	
	replace_subv:
	
	beq $t1, $t2, end_subv
	lw $t1, 0(%a1) 
	lw $t2, 0(%a2)
	
	loop2_subv:
		beq $s7, $t3, end_subv 	#se t3 == ao que falta pra terminar o maior vetor
					
		sll $t6, $t3, 2 		#se a1 tem mais elementos
		add $s0, $t6, %a1
		add $s6, $t6, %a0
		lw $s1, 0($s0)
		
		sw $s1, 0($s6)			#a0[i] = a1[i]
	
		addi $t3, $t3, 1		#incrementa endereco de a0
		j loop2_addv
		
	out1:
		li $v0,4 #comando de impressão de inteiro na tela
		la %a0, $informeErro #coloca o texto subtração para ser impresso
		syscall # efetua a chamada ao sistema
		
	end_addv:
		
	lw %a0, 0 ($sp)
	addi $sp,$sp,4

.end_macro

############################### termina subv ################################################

################################################### Termina Renan ##################################################

########################  INICIO COSSENO ####################

# cos = (a1*b1 + a2*b2 +...)/ raiz( (a1+b1)*(a1+b1) + (a2+b2)*(a2+b2) + ... )

#coloca em f0 o cosseno dos vetores contidos em a1 e a2
.macro cos(%a0,%a1)

	#empilha parametros
	addi $sp,$sp,-4
	sw %a0,0($sp)	
	addi $sp,$sp,-4
	sw %a1,0($sp)

	
	lw $t8,0(%a0) #tamanho do vetor a0
	lw $t9,0(%a1) #tamanho do vetor a1
	bne $t8,$t9,erro_cos #se os vetores pertencerem a espacos diferentes nao pode calcular o cosseno
	
	addi $t0,%a0,4 # t0 = endereco de a0 depois do elemento q contem o tamanho
	addi $t1,%a1,4 # t1 = endereco de a0 depois do elemento q contem o tamanho

	#calcular o numerador somatorio =   (a1*b1 + a2*b2 +...)
	li $t7,0 #somatorio
	li $t9,0 #contador i
	loop1_cos: beq $t9,$t8,end_loop1_cos #se i = tamanho sai
		addi $t9,$t9,1
	
		lw $t2,0($t0) #t2 = a0[i]
		lw $t3,0($t1) #t3 = a1[i]

		mul $t2,$t2,$t3 #t2 = t2 * t3
		add $t7,$t7,$t2 #t7 = t7+t2
	
		add $t0,$t0,4 #atualizar para o prox endereco
		add $t1,$t1,4
	j loop1_cos
	end_loop1_cos:
		
	addi $t0,%a0,4 # t0 = endereco de a0 depois do elemento q contem o tamanho
	addi $t1,%a1,4 # t1 = endereco de a0 depois do elemento q contem o tamanho
	
	#calcular denominador   raiz( (a1+b1)*(a1+b1) + (a2+b2)*(a2+b2) + ... )
	li $t5,0# norma do primeiro
	li $t6,0 #norma do segundo
	li $t9,0 #contador i
	loop2_cos: beq $t9,$t8,end_loop2_cos #se i = tamanho sai
		addi $t9,$t9,1 # i++
	
		lw $t2,0($t0) #t2 = a0[i]
		lw $t3,0($t1) #t3 = a1[i]
		
		mul $t2,$t2,$t2 
		add $t5,$t5,$t2
		
		
		mul $t3,$t3,$t3 
		add $t6,$t6,$t3 

		addi $t0,%a0,4 #incrementa endereco para prox iteracao
		addi $t1,%a1,4 #incrementa endereco para prox iteracao
	j loop2_cos
	end_loop2_cos:
#	mul $t6,$t6,$t5

	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	jal cosseno
	
	lw $ra,0($sp)
	addi $sp,$sp,4


	#desempilha parametros
	lw %a0,0($sp)
	addi $sp,$sp,4
	lw %a1,0($sp)
	addi $sp,$sp,4
.end_macro


cosseno:

	mtc1  $t6, $f1		# transformar int em Float
	beq $t6,0,erro_cos #denominador deve ser diferente de 0
	cvt.s.w $f1, $f1
	
	mtc1  $t5, $f3		# transformar int em Float
	beq $t5,0,erro_cos #denominador deve ser diferente de 0
	cvt.s.w $f3, $f3

	
	sqrt.s $f1,$f1 #f0 = raiz(t6)	
	sqrt.s $f3,$f3 #f0 = raiz(t6)
	
	mul.s $f1,$f1,$f3

	mtc1  $t7, $f2		# transformar int em Float
	cvt.s.w $f2, $f2
	
	div.s $f0,$f2,$f1 #f0 = f2/f1
	
	j end_cosseno
	
	erro_cos:
		l.s $f0,2 #coloca 2 no resultado quando ocorrer erro pois  -1 <= cos <= 1
	
	end_cosseno:

jr $ra


####################### FIM COSSENO ######################
main:


#la $a1, vetFloat

#la $a2, vetFloat

la $a0, v+32
lv ($a1, vetFloat)
lv ($a2, vetFloat)

#sv ($a0,$a1)
addvf($a0, $a1, $a2)
#addv($a0,$a0,$a1)
 #multve($a0,2)
# medv($a0)
#multvv($a0, $a1)

#liv ($a1, 4)
# subv($a0, $a1, $a2)
# addiv($a0,1)
# cos ($a1, $a2)

lwc1 $f1,4($a0)
lwc1 $f2,8($a0)
lwc1 $f3,12($a0)

#lw $s1, 4 ($a0)
#lw $s2, 8 ($a0)
#lw $s3, 12 ($a0)



end:

# S2 <3
