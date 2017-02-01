#—AC————————>11/12/2015: PILA (push, remove, print)
#$s0 es la cima de la pila
##IMPORTANTE-->>no introduzco el valor 0 en la pila (el valor centinela)
#typedef struct _node_t {
#	int val; /* valor del nodo; tamaño palabra */
#	struct _node_t *prev; /* puntero al nodo anterior */
#} node_t; 
#---------------cosas nuevas

	.data
#---------------los strings deben tener nombres, no str1, str2....
info:  .asciiz "Introduce valores en la pila, 0 acaba.\n"
insert:  .asciiz "Introducir valor:"
newline:  .asciiz "\n"
print_str:  .asciiz "valores de la pila:\n"
remove_str:  .asciiz "Introducir valor para borrar: "

	.text
main:
	la $a0, info
	li $v0, 4
	syscall

	li $s0, 0 #---------------inicializar $s0

read:
	la $a0, insert
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	
	beqz $v0,continue  #deja de leer y pasa a hacer otras cosas	
	move $a0, $s0 	#node_t *top
	move $a1, $v0 	#int val
	jal push       #node_t * push(node_t *top, int val)
	move $s0, $v0  #actualizo la cima
	b read

continue:
	la $a0, print_str
	li $v0, 4
	syscall
	move $a0, $s0 	#node_t *top
	jal print 	#void print(node_t *top):

	la $a0, remove_str
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $a0, $s0 	#node_t *top
	move $a1, $v0 	#int val
	jal remove     #node_t * remove(node_t *top, int val)
	
	move $a0, $s0
    	jal print 	#pinta de nuevo sin el valor eliminado

exit:
	li $v0 10
	syscall


######################################################################
#	node_t * push(node_t *top, int val):	 devuelve direcion nodo #
######################################################################
push:
#---------------no hace falta crear pila pues no se usara recursividad
	
	move $t0, $a0

	li $a0, 8 
	li $v0, 9       	#reserva 8 byts de memoria
	syscall  

	move $a0, $t0
	sw $a1, 0($v0)  	#valor en posicion 0 del nodo
	sw $a0, 4($v0)	 	#nodo anterior en posicion 4 del nodo
	#---------------aqui tenia un error ($s0 en vez de a0)
	#el nuevo nodo apunta a la cima ahora

	jr $ra


#####################################################################
#void print(node_t *top): (recursivo y orden inverso al introducido #
#####################################################################
print:
#------------print renovado a gusto de Katia
	lw $t0, 4($a0)
	bnez $t0, print_recur#si no es igual a 0

	#aqui imprimir el último valor y retornara al main
	lw $a0, 0($a0)
	li $v0, 1
	syscall
	la $a0, newline
	li $v0, 4
	syscall	

	jr $ra  

print_recur:
	subu $sp, $sp, 32
	sw $ra, 0($sp)
    	sw $fp, 4($sp)
    	addiu $fp, $sp, 28

	sw $a0, 0($fp)  	#lo  guarda para luego (recursivo)
	lw $a0, 4($a0)
	jal print

	lw $a0, 0($fp) 	#revupera ¢a0 de la pila	
	lw $a0, 0($a0) 
	li $v0, 1	
	syscall	
	la $a0, newline
	li $v0, 4	
	syscall

	lw $ra, 0($sp)
    	lw $fp, 4($sp)
    	addiu $sp, $sp, 32
	jr $ra

######################################################################
# node_t * remove(node_t *top, int val): devuelve direccion del nodo #
######################################################################
remove:
#NO BORRA LA CIMA
	lw $t1, 4($a0) 		#siguiente nodo
    	beqz $t1, notfound		#si no hay siguiente nodo acaba
#!!!!OJO POR QUE VA UNO POR DELANTE!!!-->borra el ultimo tambien
    	lw $t0, 0($t1) 		#valor del nodo
    	beq $a1, $t0, rm		#si es igual pasa a eliminar

    	lw $a0, 4($a0)  		#siguiente nodo 
    	b remove

rm:
    lw $t2, 4($t1)  #nodo siguiente al siguiente nodo
    sw $t2, 4($a0)
    move $v0, $t1 #devuelve direcion del nodo borrado
    jr $ra  #va a volver a  el jal de remove primero
    
notfound:
    li, $v0, 0  	#devuleve null si no encuentra que borrar
    jr $ra
