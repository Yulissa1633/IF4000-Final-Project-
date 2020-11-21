/*Bloque que ordena números aleatorios*/
	/*Copyright 2019, Andrew C. Young <andrew@vaelen.org>*/

	/*R0 = Ubicación del arreglo, R1 = Tamaño del arreglo*/

		push {R0-R6,LR}	 @ Salvar registros

bsort_next:	mov R2,#0	@ R2 = Número del elemento actual
                mov R6,#0       @ R6 = Contador

bsort_loop:     add R3,R2,#1	@ R3 = Siguente número
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