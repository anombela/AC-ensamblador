#——-——ISAM——>09/12/2015: array de enteros
#$s0 -> tamaño del array, $s1->direccion array
.data
	array: .word 0:100 
	Info: .asciiz "Indica el tamaño del array: "
	Introducir: .asciiz "Introducir valor: "
	Contenido: .asciiz "\nContenido del array: \n"
	Buscar: .asciiz "\nValor a buscar: "
	Desde: .asciiz "\nBuscar desde la posicion: "
	str: .asciiz "\n"
	Encontrado: .asciiz "Encontrado en la posicion (empezando en 0)-(no encontrado = -1): "
.text

main:
	la $a0 Info
	li $v0 4
	syscall
#inicializar	
	li $v0, 5
	syscall
	move $s0, $v0 		#el tamaño del array
	la $s1 array  		# direccion del array se guarda en s1
	move $a0 $s1  		#---auxiliar, para no moverlo--- int array[]
	move $a1, $s0 		#int n
	jal inicializar 	# inicializar(int array[], int n)
#imprimir	
	move $a0, $s1  	#int array[]
	move $a1, $s0
	jal imprimir		#imprimir(int array[])

#buscardesde
	la $a0, Buscar	#valor a buscar
	li $v0, 4
	syscall
	li $v0,5
	syscall
	move $t0, $v0  # v0 se ha obtenido de la entrada antes
	la $a0, Desde	#desde la posicion que buscara
	li $v0, 4
	syscall
	li $v0,5
	syscall
	move $a0, $s1  #array
	move $a1, $t0	#valor a buscar
	move $a2, $v0  #valor en el que empieza a buscar
	move $a3, $s0  #longitud del array
	jal buscarDesde  #se le pasan 4 parametros a0, a1 a2 y a3

#imprimir la posicion
	move $t0, $v0  #posicion donde se ha encontrado
	la $a0 Encontrado
	li $v0 4
	syscall
	move $a0, $t0
	li $v0 1
	syscall
	la $a0 str
	li $v0 4
	syscall
	beq $t0, -1, exit #si no lo ha encontrado sale y acaba (si es -1)

#intercambiar
	move $a0, $t0    #posicion
	add $a1, $a0, 1  #posicion + 1
	move $a2, $s1    #array
	jal intercambiar 

#imprimir	
	move $a0, $s1  	#int array[]
	move $a1, $s0
	jal imprimir		#imprimir(int array[])

exit:
	li $v0,10
	syscall

########################################################
# void inicializar(int array[], int n): pide n enteros #
# le paso tambien el valor n ($a1), no se otra forma   #
########################################################
inicializar: #iterativo #
	li $t1, 0 #contador 

insertar:
	move $t0,$a0 		#para que no se machaque

	la $a0, Introducir
	li $v0, 4
	syscall
	li $v0,5
	syscall

	sw $v0, 0($t0)
	add $t0, $t0 4  	#porque 4 ocupa un word (integer)
	add $t1, $t1 1 		#aumentando tamaño del array contador

	move $a0,$t0
	blt $t1 $a1 insertar  #si t0 es menor  a1(tamaño), salta

	jr $ra  

#####################################################################
# void imprimir(int array[]): recorre el array, imprime sus valores #                                                                       #
#####################################################################
imprimir:
	move $t0, $a0 #para no macahcar el puntero 
	
	la $a0 Contenido
	li $v0 4
	syscall
	li $t1, 0 #contador

imprimir_array:
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	la $a0 str
	li $v0 4
	syscall

	add $t0 $t0 4
	add $t1, $t1, 1

	blt $t1 $a1 imprimir_array #si t0 es menor que longitud array (a1) sigue,
	jr $ra


##################################################################################################
#  (obligatoria)int buscarDesde(int array[], int valor, int pos, int longitud): recibe como      #
#  parámetros la dirección del array, el valor a buscar, la posición desde la que se comienza a  #
#  buscar y la longitud total del array.											  #
##################################################################################################
buscarDesde:
	mul $t0, $a2, 4 	# posicion en la que esta´a buscando 
	add $t0, $a0, $t0  	# suma la direccion de inicio del array mas la direcion que hay que desplazarse
	
	lw $t1, 0($t0)
	beq $t1, $a1, encontrado

	add $a2, $a2, 1 	#posicion + 1
	blt $a2 $a3 buscarDesde  #si la posicion es menor que la longitud del array sigue buscando
	
	#aqui solo llega si no encuentra
	li $v0, -1
	jr $ra  

encontrado:
	move $v0, $a2  	#será el valor que devolvera
	jr $ra  			#aqui solo llega si ha encontrado


##################################################################################################
# (obligatoria)void intercambiar(int i, int j, int array[]): intercambia el contenido de las     #
# posiciones “i” y “j” del array (cuya dirección se pasa como argumento).                        #
##################################################################################################
intercambiar:
	#valor 1
	mul $t0, $a0, 4 
	add $t0, $a2, $t0  # suma la direccion de inicio del array mas la direcion que hay que desplazarse
	lw $t2, 0($t0)  # me guardo el valor primero
	#valor 2
	mul $t1, $a1, 4 
	add $t1, $a2, $t1  # suma la direccion de inicio del array mas la direcion que hay que desplazarse
	lw $t3, 0($t1)  # me guardo el valor segund

	sw $t3, 0($t0)
	sw $t2, 0($t1)

	jr $ra

