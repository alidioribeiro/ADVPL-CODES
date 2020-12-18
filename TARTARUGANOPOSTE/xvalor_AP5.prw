#include "rwmake.ch"     

User Function xvalor()   

SetPrvt("VAL01,VAL02,XVALOR,")      

VAL01  := STR(SE1->E1_VALOR,13,2) 
VAL02  := STRTRAN(VAL01,".","")
XVALOR := STRZERO(VAL(VAL02),13)
                    
Return(XVALOR) 

