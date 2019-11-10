#include <msp430.h> 

int main(void)
{
    WDTCTL = WDTPW + WDTHOLD;       // Stop WDT

    P1DIR |= BIT0;                  // P1.0 output(LED1)
    P1OUT &= ~BIT0;                 // firstly turn off the LED1
    TA0CCTL0 |= CCIE;               // CCR0 interrupt enabled
    TA0CCR0 = 62500;                // 0.125Hz = 65536/8/8/0.25
    TA0CTL |= TASSEL_2 + MC_1 + ID_3;   // SMCLK, upmode, Timer A input divider: /8
    TA0EX0 |= TAIDEX_7;             // Timer A Input divider expansion : /8

    __enable_interrupt();         // Enter LPM0, enable interrupts

	return 0;
}

// Timer0 A0 interrupt service routine
#pragma vector=TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR(void)
{
    P1OUT ^= BIT0;          // Toggle P1.0(LED1)
}
