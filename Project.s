@ Yulissa Camacho Quirós
@ B91472

	/*Programa que genera números aleatorios*/
.data

var1:	.asciz "%d\n"
seed:	.word	1
const1:	.word	1103515245
const2:	.word	12345

.global main
.text

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
