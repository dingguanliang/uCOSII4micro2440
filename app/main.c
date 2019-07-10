#include <types.h>
#include <stdio.h>
#include <includes.h>

#define TASK_STACK_SIZE	128	

static OS_STK TaskStartStk[TASK_STACK_SIZE];	
static OS_STK Task1Stk[TASK_STACK_SIZE];	
static OS_STK Task2Stk[TASK_STACK_SIZE];

static void TaskStart(void *p_arg);
static void Task1(void *p_arg);
static void Task2(void *p_arg);

extern void system_init(void);

int32_t main()
{
	OSInit();
	OSTaskCreate(TaskStart, (void *)0, &TaskStartStk[TASK_STACK_SIZE-1], 1);	// 创建起始任务，赋予最高优先级1。 
	system_init();
	OSStart();	
	
	return(0);
}

static void TaskStart(void *p_arg)
{
	#if OS_TASK_STAT_EN > 0u
		OSStatInit();	// 是否开启统计任务。
	#endif
    OSTaskCreate(Task1, (void *)0, &Task1Stk[TASK_STACK_SIZE], 2);	// 在起始任务中创建Task1，优先级2。
    OSTaskCreate(Task2, (void *)0, &Task2Stk[TASK_STACK_SIZE], 3);	// 在起始任务中创建Task2，优先级3。

    while(1)
    {
		OSTaskSuspend(OS_PRIO_SELF);	// 挂起自身，进行任务调度。
    }
}

static void Task1(void *p_arg)
{  
	while(1)
	{
		printf("task 1!\n\r");
		OSTimeDlyHMSM(0, 0, 1, 0);	// 将任务延时，在此进行任务调度。 
	}
}

static void Task2(void *p_arg)
{ 
	while(1)
	{
		printf("task 2!\n\r");
		OSTimeDlyHMSM(0, 0, 2, 0);	// 将任务延时，在此进行任务调度。 
	}
}
