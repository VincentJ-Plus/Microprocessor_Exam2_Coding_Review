#include <msp430.h> 

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1DIR |= BIT0;
    P1OUT &= ~BIT0;
    // set S1, for lower button
    P2REN |= BIT1;      // enable P2.1 resistor
    P2OUT |= BIT1;
    P2IES &= ~BIT1;     // falling edge trigger
    P2IFG &= ~BIT1;     // clear P2.1 flag
    P2IE |= BIT1;       // enable P2.1 interrupt

    TA0CCTL0 |= CCIE;               // CCR0 interrupt enabled
    TA0CTL |= TASSEL_1 + MC_1; // ACLK frequency of ACLK is 32786 Hz; upmode;
    TA0CCR0 = 32768/2-1;

    __enable_interrupt();         // Enter LPM0, enable interrupts
    return 0;
}

#pragma vector=TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR(void)
{
    P1OUT ^= BIT0;
}

#pragma vector=PORT2_VECTOR
__interrupt void Port_2(void)
{
    P1DIR ^= BIT0;
    P2IFG &= ~BIT1;
}
