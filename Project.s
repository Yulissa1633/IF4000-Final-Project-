@ Yulissa Camacho Quirós
@ B91472

.data

.balign 4
randarray:	.skip	40000
printf_str:     .asciz	"randarray[%d] = %d\n"
debug_str:	.asciz	"R%-2d   0x%08X  %011d \n"
exit_str:       .ascii	"Programa terminado.\n"

.global main
.func main

	/*Bloque que llena un arreglo con números aleatorios
		generado tomando como guía el código 
		  de: Christopher D. McMurrough*/

		/*Bloque que ordena números aleatorios
		   Copyright 2019, Andrew C. Young 
			<andrew@vaelen.org>*/
   
main:		bl _seedrand            @ Toma el método seedrand
		mov R0, #0              @ Inicializa índice de la variable

writeloop:	cmp R0, #2000           @ Revisa que se haga la iteración
		beq writedone           @ Termina el ciclo si está listo
	    	ldr R1, =randarray      @ Busca el arreglo
	    	lsl R2, R0, #2          @ Multiplica el índice * 4 para tener el desplazamiento del arreglo
	    	add R2, R1, R2          @ Pasa el elemento a R2
	    	push {R0}               @ Respaldo del iterador antes de llamar al procedimiento
	    	push {R2}               @ Respaldo del elemento antes de llamar al procedimiento
	    	bl _getrand             @ Toma un número random
	    	pop {R2}                @ Restaura elemento
	    	str R0, [R2]            @ Escribe randarray[i] 
	    	pop {R0}                @ Restaura iterator
	    	add R0, R0, #1          @ Incrementa ínidce
	    	b   writeloop           @ Vuelve al ciclo

writedone:	mov R0, #0              @ Inicializa índice de la variable

readloop:	cmp R0, #2000           @ Revisa que se haga la iteración
		beq readdone            @ Termina el ciclo si está listo
		ldr R1, =randarray      @ Busca el arreglo
		lsl R2, R0, #2          @ Multiplica el índice * 4 para tener el desplazamiento del arreglo
		add R2, R1, R2          @ Pasa el elemento a R2
		ldr R1, [R2]            @ Lee lo que tiene el arreglo
		push {R0}               @ Respaldo del registro antes de llamar al procedimiento
		push {R1}               @ Respaldo del registro antes de llamar al procedimiento
		push {R2}               @ Respaldo del registro antes de llamar al procedimiento
		mov R2, R1              @ Mueve el valor que tiene el arreglo a R2 para imprimirlo
		mov R1, R0              @ Mueve el ínidice del arreglo a R1 para imprimirlo
		bl  _printf             @ Llama al procedimiento que imprime
		pop {R2}                @ Restaura registro
		pop {R1}                @ Restaura registro
		pop {R0}	@ Restaura registro
		add R0, R0, #1          @ Incrementa el índice
		b   readloop            @ Vuelve al ciclo

		    /*R0 = Tamaño del arreglo, 
		    R1 = Ubicación del arreglo*/

		push {R0-R6,LR}	@ Salvar registros
		ldr R1, =randarray
		mov R0, #2000

bsort_next:	mov R2,#0	@ R2 = Número del elemento actual
                mov R6,#0       @ R6 = Contador 

bsort_loop:	add R3,R2,#1	@ R3 = Siguente número
                cmp R3,R1	@ Revisa final del arreglo
		bge bsort_check	@ Cuando llega al final, revisa cambios
		ldr R4,[R0,R2,LSL #2]	@ R4 = Valor del elemento actual
		ldr R5,[R0,R3,LSL #2]	@ R5 = Valor del siguiente elemento
		cmp R4,R5	@ Compara los valores de los elementos
    		strgt R5,[R0,R2,LSL #2]	@ Si R4 > R5, almacena valor actual en el siguiente
    		strgt R4,[R0,R3,LSL #2]	@ Si R4 > R5, almacena el siguiente valor en el actual
    		addgt R6,R6,#1	@ Si R4 > R5, Incrementa contador
    		mov R2,R3	@ Avanza al siguiente elemento 
    		b bsort_loop 	@ Fin del ciclo

printagain:	b readloop	@ Imprime de nuevo cuando esté ordenado

readdone:	pop {R0-R6,PC}	@ Saca los registros y sale
	    	b _exit                 @ Sale si está listo
    
_exit:  	mov R7, #4              
	    	mov R0, #1              
	    	mov R2, #21             @ Print string length
	    	ldr R1, =exit_str       @ String at label exit_str:
	    	swi 0                   @ Hace llamada al sistema
	    	mov R7, #1              @ Termina llamada al sistema, 1
	    	swi 0                   @ Hace llamada al sistema
       
_printf:	push {LR}               @ Almacena retorno
	    	ldr R0, =printf_str     @ Pasa string a RO
	    	bl printf               @ Llama a printf
	    	pop {PC}                @ Restaura el puntero de la pila
    
_seedrand:    	push {LR}               @ Respaldo al retorno
	    	mov R0, #0              @ Pasa 0 para llamar a time
	    	bl time                 @ Toma time
	    	mov R1, R0              @ Pasa time a srand
	    	bl srand                @ Toma srand
	    	pop {PC}                @ Retorna 
    
_getrand:    	push {LR}               @ Respaldo al retorno
	    	bl rand                 @ Roma el número aleatorio
	    	pop {PC}                @ Retorna 

		


bsort_check:	cmp R6,#0	@ Revisa cambios, ¿han habido cambios en esta iteración?
    		subgt R1,R1,#1	@ En el siguiente ciclo omite el último valor
    		bgt bsort_next	@ Se hace de nuevo si hubieron cambios
