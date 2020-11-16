@ Yulissa Camacho Quirós
@ B91472

.data

var1:	.asciz "%d\n"
seed:	.word	1
const1:	.word	1103515245
const2:	.word	12345

.global main, bsort
.text

	/*Bloque que genera números aleatorios*/

main:	push	r4	@ salva registros
	mov	r0, #42	@ llama a mysrand con parámetro 42
	bl	mysrand
	mov	r4, #5	@ inicializa contador del bucle

bucle:	bl	myrand	@ lee número aleatorio
	mov	r1, r0	@ pasa valor a r1
	ldr	r0, =var1	@ pone cadena de texto en r0
	bl	printf	@ llama a la función printf
	subs	r4, r4, #1	@ decremento contador
	cmp	r4, #0	
	bne	bucle
	b	end	

myrand:	ldr	r1, =seed	@ leo puntero semilla
	ldr	r0, [r1]	@ leo valor de semilla
	ldr	r2, [r1, #4]	@ leo const1 en r2
	mul	r3, r0, r2	@ r3 = seed*1103515245
	ldr	r0, [r1, #8]	@ leo const2 en r0
	add	r0, r0, r3	@ r0 = r3 + 12345
	str	r0, [r1]	 @ guardo en variable seed
	mov	r0, r0, LSL #1
	mov	r0, r0, LSR #17
	bx	lr

mysrand: ldr	r1, = seed	/*"seed >> 16 y 0x7 fff (evita AND)"*/
	 str	r0, [r1]
	 bx	lr

end: 	pop	r4	@ recupera registros y sale
	bx	lr

	/*Bloque que ordena números aleatorios*/
	/*Copyright 2019, Andrew C. Young <andrew@vaelen.org>*/

	/*R0 = Ubicación del arreglo, R1 = Tamaño del arreglo*/

		push {R0-R6,LR}	 @ Push registers on to the stack

bsort_next:	mov R2,#0	@ Check for a sorted array, R2 = Current Element Number
                mov R6,#0       @ R6 = Number of swaps

bsort_loop:     add R3,R2,#1	@ Start loop, R3 = Next Element Number
                cmp R3,R1	@ Check for the end of the array
		bge bsort_check	@ When we reach the end, check for changes
		ldr R4,[R0,R2,LSL #2]	@ R4 = Current Element Value
		ldr R5,[R0,R3,LSL #2]	@ R5 = Next Element Value
		cmp R4,R5	@ Compare element values
    		strgt R5,[R0,R2,LSL #2]	@ If R4 > R5, store current value at next
    		strgt R4,[R0,R3,LSL #2]	@ If R4 > R5, Store next value at current
    		addgt R6,R6,#1	@ If R4 > R5, Increment swap counter
    		mov R2,R3	@ Advance to the next element
    		b sort_loop 	@ End loop

bsort_check:	CMP R6,#0	@ Check for changes, Were there changes this iteration?
    		subgt R1,R1,#1	@ Optimization: skip last value in next loop
    		bgt bsort_next	@ If there were changes, do it again

bsort_done:     POP {R0-R6,PC}	@ Return, Pop the registers off of the stack
