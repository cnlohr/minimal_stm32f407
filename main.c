#include <stdint.h>
#include <stdio.h>
#include <systems.h>

RCC_ClocksTypeDef RCC_Clocks;

int main(void)
{  
	uint32_t i = 0;

	RCC_GetClocksFreq( &RCC_Clocks );

	ConfigureLED(); LED_ON;

	/* SysTick end of count event each 10ms */
	SysTick_Config( RCC_Clocks.HCLK_Frequency / 100);

	printf( "Operating at %dHz\n", RCC_Clocks.HCLK_Frequency );
	while(1)
	{
	}
}

void TimingDelay_Decrement()
{
	static int i;
	i++;
	if( i == 100 )
	{
		LED_ON;
		i = 0;
	}
	if( i == 5 )
	{
		LED_OFF;
	}
}


