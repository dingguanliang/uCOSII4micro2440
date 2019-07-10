.global OSStartHighRdy
OSStartHighRdy:
    ldr r4, =OSRunning         
    mov r5, #1
    strb r5, [r4]

    ldr r4, =OSTCBHighRdy      
    ldr r4, [r4]               
    ldr sp, [r4]               

    ldmfd sp!, {r4}            
    msr spsr, r4
    ldmfd sp!, {r4}            
    msr cpsr, r4
    ldmfd sp!, {r0-r12, lr, pc}   

.global OSCtxSw
OSCtxSw:
    stmfd sp!, {lr}            
    stmfd sp!, {r0-r12, lr}       
    mrs r4, cpsr
    stmfd sp!, {r4}              
    mrs r4, spsr
    stmfd sp!, {r4}            

	ldr r4, =OSTCBCur
    ldr r5, [r4]
    str sp, [r5]

	ldr r4, =OSPrioCur
    ldr r5, =OSPrioHighRdy
    ldr r6, [r5]
    str r6, [r4]    

	ldr r4, =OSTCBCur
    ldr r5, =OSTCBHighRdy
    ldr r6, [r5]
	str r6, [r4]   

    ldr sp, [r6]                            

    ldmfd sp!, {r4}            
    msr spsr, r4
    ldmfd sp!, {r4}            
    msr cpsr, r4
    ldmfd sp!, {r0-r12, lr, pc}      

.global UCOS_IRQHandler
UCOS_IRQHandler:
	stmfd sp!, {r0-r3, r12, lr}  

	bl OSIntEnter
    bl do_irq	
    bl OSIntExit
	
	ldmfd sp!, {r0-r3, r12, lr}
	
    stmfd sp!, {r0-r3}
    mov r1, sp
    sub r2, lr, #4
	add sp, sp, #16

    mrs r3, spsr
    orr r0, r3, #0xc0
    msr spsr_c, r0

    msr cpsr_c, #0x13

    stmfd sp!, {r2}             
    stmfd sp!, {r4-r12, lr}     
    mov r4, r1                 
    mov r5, r3
    ldmfd r4!, {r0-r3}
    stmfd sp!, {r0-r3}          
    stmfd sp!, {r5}            
    mrs r4, spsr
    stmfd sp!, {r4}

	ldr r4, =OSTCBCur
    ldr r5, [r4]
    str sp, [r5]

	ldr r4, =OSPrioCur
    ldr r5, =OSPrioHighRdy
    ldr r6, [r5]
    str r6, [r4]    

	ldr r4, =OSTCBCur
    ldr r5, =OSTCBHighRdy
    ldr r6, [r5]
	str r6, [r4]   

    ldr sp, [r6]                            

    ldmfd sp!, {r4}            
    msr spsr, r4
    ldmfd sp!, {r4}            
    msr cpsr, r4
    ldmfd sp!, {r0-r12, lr, pc}   

.global OSCPUSaveSR
OSCPUSaveSR:
    mrs r0, cpsr
    orr r1, r0, #0xc0
    msr cpsr_c, r1
    mov pc, lr

.global OSCPURestoreSR
OSCPURestoreSR:
    msr cpsr_c, r0
    mov pc, lr
