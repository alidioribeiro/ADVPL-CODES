#INCLUDE "rwmake.ch"   
#include "ap5mail.ch"     
#Include "TOPCONN.CH"
#Include "TBICONN.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFE05     �Autor  �Microsiga           � Data �  15/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Avisa aos responsaveis que o Fcost ja esta disponivel para ���
���          � Preenchimento                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function WFE05

   
    oProcess := TWFProcess():New( "Fcost", "Preenchimento do Fcost" )
    oProcess :NewTask( "100003", "\WORKFLOW\exemplo.HTM" )
    oProcess :cSubject := "WFE05 - Preenchimento do Fcost"
    oHTML    := oProcess:oHTML 
    
    cMen := " <html>"
    cMen := " <head>"
    cMen := " <title></title>"
    cMen := " </head>"    
    cMen += " <body>"
    cMen += ' <tr></tr> '
    cMen += " </body>"
    cMen += " </html>"
    
    CodRot:="WFE05"   
    Mto:= u_MontaRec(CodRot)
        
    oHtml:ValByName("MENS", cMen)
    oProcess:cTo  := Mto
    cMailId := oProcess:Start()
    
Return