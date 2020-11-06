@ Yulissa Camacho Quirós
@ B91472

	/*Programa que genera números aleatorios*/
.data
seed:	.word	1
const1:	.word	1103515245
const2:	.word	12345

.global main, mysrand
.text

main:	ldr	r1, =seed	@ leo puntero semilla
	ldr	r0, [r1]	@ leo valor de semilla
	ldr	r2, [r1, #4]	@ leo const1 en r2
	mul	r3, r0, r2	@ r3 = seed*1103515245
	ldr	r0, [r1, #8]	@ leo const2 en r0
	add	r0, r0, r3	@ r0 = r3 + 12345
	str	r0, [r1]	 @ guardo en variable seed
	LSL	r0, #1
	LSR	r0, #17
	bx	lr	/*"seed >> 16 y 0x7 fff (evita AND)"*/
mysrand: ldr	r1, = seed
	 str	r0, [r1]
	 bx	lr


