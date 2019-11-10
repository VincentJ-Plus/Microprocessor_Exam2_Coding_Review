#include <msp430.h>

int main(void)
{
    WDTCTL = WDTPW + WDTHOLD;       // Stop WDT

    P1DIR |= BIT0;                  // P1.0 output(LED1)
    P4DIR |= BIT7;                  // P4.7 output(LED2)
    P4OUT &= ~BIT7;                 // firstly turn off the LED2
    TA0CCTL0 |= CCIE;               // CCR0 interrupt enabled
    TA0CTL |= TASSEL_1 + MC_1; // ACLK frequency of ACLK is 32786 Hz; upmode;
    TA0CCR0 = 32768/4-1;

    // set S2, for faster button
    P1REN |= BIT1;      // enable P1.1 resistor
    P1OUT |= BIT1;
    P1IES &= ~BIT1;     // falling edge trigger
    P1IFG &= ~BIT1;     // clear P1.1 flag
    P1IE |= BIT1;       // enable P1.1 interrupt

    // set S1, for lower button
    P2REN |= BIT1;      // enable P2.1 resistor
    P2OUT |= BIT1;
    P2IES &= ~BIT1;     // falling edge trigger
    P2IFG &= ~BIT1;     // clear P2.1 flag
    P2IE |= BIT1;       // enable P2.1 interrupt

    __enable_interrupt();         // Enter LPM0, enable interrupts
  // __bis_SR_register(LPM0_bits + GIE);      // alternative for previous line
}

// Timer0 A0 interrupt service routine
#pragma vector=TIMER0_A0_VECTOR
__interrupt void TIMER0_A0_ISR(void)
{
    P1OUT ^= BIT0;          // Toggle P1.0(LED1)
}

// S2 control faster
#pragma vector=PORT1_VECTOR
__interrupt void Port_1(void)
{
    TA0CCR0 -= 2000; // decrease blinking frequency
    if (TA0CCR0<4000) {
        P4OUT |= BIT7; // turn on LED2
        __delay_cycles(100000);
        P4OUT &= ~BIT7;
        TA0CCR0 += 2000;
        }

    P1IFG &= ~BIT1;
}

// S1 control lower
#pragma vector=PORT2_VECTOR
__interrupt void Port_2(void)
{
    TA0CCR0 += 2000; // decrease blinking frequency
    if (TA0CCR0>=35000) {
        P4OUT |= BIT7; // turn on LED2
        __delay_cycles(100000);
        P4OUT &= ~BIT7;
        TA0CCR0 -= 2000;
        }

    P2IFG &= ~BIT1;
}
