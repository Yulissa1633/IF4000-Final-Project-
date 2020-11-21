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
   
main:	bl _seedrand            @ toma el método seedrand
	mov R0, #0              @ inicializa índice de la variable

writeloop:	
	cmp R0, #2000           @ revisa que se haga la iteración
	beq writedone           @ termina el ciclo si está listo
    	ldr R1, =randarray      @ busca el arreglo
    	lsl R2, R0, #2          @ multiplica el índice * 4 para tener el desplazamiento del arreglo
    	add R2, R1, R2          @ pasa el elemento a R2
    	push {R0}               @ respaldo del iterador antes de llamar al procedimiento
    	push {R2}               @ respaldo del elemento antes de llamar al procedimiento
    	bl _getrand             @ toma un número random
    	pop {R2}                @ restaura elemento
    	str R0, [R2]            @ escribe randarray[i] 
    	pop {R0}                @ restaura iterator
    	add R0, R0, #1          @ incrementa ínidce
    	b   writeloop           @ vuelve al ciclo

writedone:
	mov R0, #0              @ inicializa índice de la variable

readloop:
	cmp R0, #2000           @ revisa que se haga la iteración
	beq readdone            @ termina el ciclo si está listo
	ldr R1, =randarray      @ busca el arreglo
	lsl R2, R0, #2          @ multiplica el índice * 4 para tener el desplazamiento del arreglo
	add R2, R1, R2          @ pasa el elemento a R2
	ldr R1, [R2]            @ lee lo que tiene el arreglo
	push {R0}               @ respaldo del registro antes de llamar al procedimiento
	push {R1}               @ respaldo del registro antes de llamar al procedimiento
	push {R2}               @ respaldo del registro antes de llamar al procedimiento
	mov R2, R1              @ mueve el valor que tiene el arreglo a R2 para imprimirlo
	mov R1, R0              @ mueve el ínidice del arreglo a R1 para imprimirlo
	bl  _printf             @ llama al procedimiento que imprime
	pop {R2}                @ restaura registro
	pop {R1}                @ restaura registro
	pop {R0}                @ restaura registro
	add R0, R0, #1          @ incrementa el índice
	b   readloop            @ vuelve al ciclo

readdone:
    	b _exit                  @ sale si está listo
    
_exit:  mov R7, #4              
    	mov R0, #1              
    	mov R2, #21             @ print string length
    	ldr R1, =exit_str       @ string at label exit_str:
    	swi 0                   @ hace llamada al sistema
    	mov R7, #1              @ termina llamada al sistema, 1
    	swi 0                   @ hace llamada al sistema
       
_printf:push {LR}               @ almacena retorno
    	ldr R0, =printf_str     @ pasa string a RO
    	bl printf               @ llama a printf
    	pop {PC}                @ restaura el puntero de la pila
    
_seedrand:
    	push {LR}               @ respaldo al retorno
    	mov R0, #0              @ pasa 0 para llamar a time
    	bl time                 @ toma time
    	mov R1, R0              @ pasa time a srand
    	bl srand                @ toma srand
    	pop {PC}                @ retorna 
    
_getrand:
    	push {LR}               @ respaldo al retorno
    	bl rand                 @ roma el número aleatorio
    	pop {PC}                @ retorna 

		/*Bloque que ordena números aleatorios*/
	/*Copyright 2019, Andrew C. Young <andrew@vaelen.org>*/

	/*R0 = Ubicación del arreglo, R1 = Tamaño del arreglo*/

		push {R0-R6,LR}	@ Salvar registros

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

bsort_check:	cmp R6,#0	@ Revisa cambios, ¿han habido cambios en esta iteración?
    		subgt R1,R1,#1	@ En el siguiente ciclo omite el último valor
    		bgt bsort_next	@ Se hace de nuevo si hubieron cambios

bsort_done:     pop {R0-R6,PC}	@ Saca los registros y sale
