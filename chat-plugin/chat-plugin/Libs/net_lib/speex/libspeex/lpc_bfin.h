

#include "bfin.h"

#define OVERRIDE_SPEEX_AUTOCORR
void _spx_autocorr(
const spx_word16_t *x,   
spx_word16_t       *ac,  
int          lag, 
int          n
                  )
{
   spx_word32_t d;
   const spx_word16_t *xs;
   int i, j;
   spx_word32_t ac0=1;
   spx_word32_t ac32[11], *ac32top;
   int shift, ac_shift;
   ac32top = ac32+lag-1;
   int lag_1, N_lag;
   int nshift;
   lag_1 = lag-1;
   N_lag = n-lag_1;
   for (j=0;j<n;j++)
      ac0 = ADD32(ac0,SHR32(MULT16_16(x[j],x[j]),8));
   ac0 = ADD32(ac0,n);
   shift = 8;
   while (shift && ac0<0x40000000)
   {
      shift--;
      ac0 <<= 1;
   }
   ac_shift = 18;
   while (ac_shift && ac0<0x40000000)
   {
      ac_shift--;
      ac0 <<= 1;
   }
   
   xs = x+lag-1;
   nshift = -shift;
   __asm__ __volatile__ 
   (
         "P2 = %0;\n\t"
         "I0 = P2;\n\t" 
         "B0 = P2;\n\t" 
         "R0 = %3;\n\t" 
         "P3 = %3;\n\t" 
         "P4 = %4;\n\t" 
         "R1 = R0 << 1;\n\t" 
         "L0 = R1;\n\t"
         "P0 = %1;\n\t"
         "P1 = %2;\n\t"
         "B1 = P1;\n\t"
         "R4 = %5;\n\t"
         "L1 = 0;\n\t" 

         "r0 = [I0++];\n\t"
         "R2 = 0;R3=0;"
         "LOOP pitch%= LC0 = P4 >> 1;\n\t"
         "LOOP_BEGIN pitch%=;\n\t"
            "I1 = P0;\n\t"
            "A1 = A0 = 0;\n\t"
            "R1 = [I1++];\n\t"
            "LOOP inner_prod%= LC1 = P3 >> 1;\n\t"
            "LOOP_BEGIN inner_prod%=;\n\t"
               "A1 += R0.L*R1.H, A0 += R0.L*R1.L (IS) || R1.L = W[I1++];\n\t"
               "A1 += R0.H*R1.L, A0 += R0.H*R1.H (IS) || R1.H = W[I1++] || R0 = [I0++];\n\t"
            "LOOP_END inner_prod%=;\n\t"
            "A0 = ASHIFT A0 by R4.L;\n\t"
            "A1 = ASHIFT A1 by R4.L;\n\t"
   
            "R2 = A0, R3 = A1;\n\t"
            "[P1--] = R2;\n\t"
            "[P1--] = R3;\n\t"
            "P0 += 4;\n\t"
         "LOOP_END pitch%=;\n\t"
   : : "m" (xs), "m" (x), "m" (ac32top), "m" (N_lag), "m" (lag_1), "m" (nshift)
   : "A0", "A1", "P0", "P1", "P2", "P3", "P4", "R0", "R1", "R2", "R3", "R4", "I0", "I1", "L0", "L1", "B0", "B1", "memory",
     "ASTAT" BFIN_HWLOOP0_REGS BFIN_HWLOOP1_REGS
   );
   d=0;
   for (j=0;j<n;j++)
   {
      d = ADD32(d,SHR32(MULT16_16(x[j],x[j]), shift));
   }
   ac32[0] = d;
   
   for (i=0;i<lag;i++)
   {
      d=0;
      for (j=i;j<lag_1;j++)
      {
         d = ADD32(d,SHR32(MULT16_16(x[j],x[j-i]), shift));
      }
      if (i)
         ac32[i] += d;
      ac[i] = SHR32(ac32[i], ac_shift);
   }
}
