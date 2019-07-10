#include <types.h>
#include <register.h>
#include <interrupt.h>
#include <timer.h>
#include <uart.h>
#include <includes.h>

void timer2_svr()
{
	OSTimeTick();    
}

void system_init(void)
{
#if OS_CRITICAL_METHOD == 3u
	OS_CPU_SR cpu_sr;
#endif

	OS_ENTER_CRITICAL();
	
	while(!int_init(INT_TIMER2, timer2_svr));
	while(!timer_init(TIMER2_BASE, AUTO_RELOAD, 0, 10, 100000 / OS_TICKS_PER_SEC));
	while(!uart_init(UART0, 115200, NOMAL_MODE, NP, OSB, _8BIT));
	
	OS_EXIT_CRITICAL();
}
