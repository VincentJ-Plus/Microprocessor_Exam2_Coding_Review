#include <msp430.h> 
#define delay_ms(x)__delay_cycles((long)x*800)

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	P1DIR |= BIT0;
	P4DIR |= BIT7;
	P1OUT &= ~BIT0;
	P4OUT &= ~BIT7;

    TA0CCTL0 |= CCIE;               // CCR0 interrupt enabled
    TA0CTL |= TASSEL_1 + MC_1; // ACLK frequency of ACLK is 32786 Hz; upmode;
    TA0CCR0 = 32768-1;

    __enable_interrupt();         // Enter LPM0, enable interrupts
	return 0;
}

#pragma vector=TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR(void)
{
    P1OUT ^= BIT0;
    delay_ms(1000);
    P4OUT ^= BIT7;
}
