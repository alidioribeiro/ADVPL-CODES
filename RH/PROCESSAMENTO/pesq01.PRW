#Include "Rwmake.ch" 
#Include "TOPCONN.ch"

User Function pesq01() 
teste := .t.


if teste
anRadion :={1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0}  
anRadion2:={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
anRadion3:={1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
anRadion4:={1,1,1,1,1,1,1,1}
else
anRadion :={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
anRadion2:={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
anRadion3:={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} 
anRadion4:={0,0,0,0,0,0,0,0} 
end

// 1-RESPPOSTA ESTRUTURA
aResp:={"Fortemete Concordo","Concordo","Discordo","Discordo Completamente","Sem Opini�o"}  

// 2-RESPOSTA CLIMA
aResp2a:={"P�ssimo","Regular","Bom","Muito Bom","�timo"}
aResp2b:={"Nunhuma importancia para a organiza��o","Pouca import�ncia para a organiza��o",;
	      "Em parte importante para a organiza��o","Muito importante para a organiza��o ",;
	      "Fundamental para a organiza��o        "}          
aResp2c:={"Insuficiente","Negativo","Alienado","Positivo","Motivador"}
aResp2d:={"Sal�rio,Benef�cios(Alimenta��o,Pl. Sa�de,Transporte,Drogaria,etc)",;
	      "Relacionamento Chefia, supervisor, lider com sua equipe",;
	      "Gest�o da Alta Dire��o (Presidente, Diretor, Gerentes)",;
	      "Relacionamento entre setores"}	      
aResp2e:={"Muito Importante","N�o importante","N�o faz diferen�a",;
          "Fundamental para a minha vida","Pouco importante     "}
aResp2f:={"P�ssima","Confusa","Incompleta","�tima","Boa"}
aResp2g:={"Amplo conhecimento",;
          "Bom conhecimento",;
          "Pouco conhecimento",;
          "Conhecimento te�rico, mas n�o pr�tico",;
	      "N�o tem conhecimento das atividades"}	      
aResp2h:={"Fundamentais","Desnecess�rios","Desgastantes","Muito importantes","Gratificantes"}
aResp2i:={"Fundamental para o aprendizado",;
          "Indispens�vel para a intera��o de ideais",;
          "Favor�vel para a melhoria cont�nua nas atividades",;
	      "H� dificuldade de acesso por isso n�o tem import�ncia",;
	      "N�o � permitido usar da autonomia e participa��o nos projetos"}
aResp2j:={"Ess�ncial para qualidade do produto",;
          "Fundamental para o processo em geral",;
          "Pouca importancia, a motiva��o n�o conta",;
          "Nenhuma rela��o de motiva��o pode afetar a Qualidade",;
	      "N�o h� rela��o, o servi�o � mecanizado"} 	      

// 2-RESPOSTA DA GEST�O
aResp2l:={"Competente","Muito competente","Pouco competente","N�o � competente","Nada a opnar"}	       
aResp2m:={"Excelente","�timo","Bom","P�ssimo","Nada a opnar"}

// 3-RESPOSTA DOS BENEFICIOS
aResp3a:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}	       
aResp3b:={"Agendamento Longo","Agendamento Breve","Dificudades no Agendamento","Facilidades no Agendamento",;
          "Nenhuma Queixa"}
aResp3c:={"Todos s�o poss�veis","Alguns s�o poss�veis","poucos s�o poss�veis",;
          "Demora nos resultados","nenhuma queixa"}
aResp3d:={"Diversas, mas desorganizadas","Diversas e excelentes",;
          "Limitadas, por�m satisfat�rias","Limitadas e insatisfat�rias","Nenhuma queixa"}
aResp3e:={"Problemas com anestesistas","�timos tratamentos cir�rgicos",;
          "Regulares tratamentos cir�rgicos","Problemas nas autoriza��es","Nenhuma queixa"}
aResp3f:={"�timo atendimento","P�ssimo atendimento","Regular atendimento","Bom atendimento","Nenhuma queixa"}
//
aResp3g:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3h:={"Falta Medicamento","Demora na entrega","Pre�os altos","�timos servi�os","Nenhuma queixa"}
aResp3i:={"Erro de informa��o ao RH","Erro na entrega","Baixo desconto","�timo servi�os","Nenhuma queixa"}
aResp3j:={"P�ssimo","Regular","Bom","Muito bom","�timo"} 
aResp3l:={"�timo produtos","P�ssimo produtos","Bons produtos","produtos muito caros","Nenhuma queixa"} 
aResp3m:={"Facilidade no pagamento","Dificudades nos pagamentos","Baixo desconto","�timos servi�os","Nenhuma queixa"} 
//
aResp3n:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3o:={"�timos","P�ssimos","Regulares","Bons","Nenhuma queixa"} 
aResp3p:={"Prudentes","Imprudentes","Relacionam-se bem","Relacionam-se mal","Nenhuma queixa"} 
aResp3q:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3r:={"Cedo","Muito cedo","tarde","Ideal","Nenhuma queixa"}
aResp3s:={"Distante da resid�ncia","Perto da resid�ncia","N�o muito distante","Ideal","Nenhuma queixa"} 
aResp3t:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"} 
aResp3u:={"�timo","P�ssimo","Regular","Bom","Nenhuma queixa"}
aResp3v:={"�timo","P�ssimo","Regular","Bom","Nenhuma queixa"}  
aResp3x:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3z:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3w:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp3y:={"Baixo","Muito baixo","Ideal","Alto","Nenhuma queixa"} 
aResp3k:={"�timo","P�ssimo","Regular","Bom","Nenhuma queixa"} 
aResp3a1:={"Tolerar 1 atestado","Tolerar 2 atestado","tolerar 3h","Permanece","Nenhuma queixa"}  

//RESPOSTA DOS TREINAMENTOS
aResp4a:={"N�o","Parcialmente","Totalmenteo"}
aResp4b:={"N�o","Sim","Somente alguns s�o previlegiados"}	       
aResp4c:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}	       
aResp4d:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp4e:={"P�ssimo","Regular","Bom","Muito Bom","Otimo"}
aResp4f:={"Tecnicos do cargo","Rela��es interpessoais","Gerenciais","Trabalho em equipe","Qualidade"} 
aResp4g:={"Produ��o","Impress�o","Inje��o","Administra��o","Gestores","Controle da qualidade","Almoxerifado","Manuten��o","TI"} 
aResp4h:={"Sem importancia","Motivador para o crescimento profissional","Disseminador de novas ideias",;
          "Facilitador do desenvolvimento no trabalho","Sem opini�o"} 

sair:=.F.
main()
Return


**********************************                                                       				
Static Function main()
**********************************    
Local oDlg, oSay, oFontD:= TFont():New("Time New Roman",,-12,.T.,.T.)
Local oDlg, oSay, oFont := TFont():New("Time New Roman",,-15,.T.,.T.)
@ 96,20 To 700,1027 DIALOG oDlg TITLE "BEM VINDO AO PORTAL DE PESQUISA NIPPON SEIKI DO BRASIL"  

@ 06,2  To 275, 505  
//@ 36,6  To 245, 500 

oSay:= tSay():New(45,55,{||"A PESQUISA DE CLIMA ORGANIZACIONAL PODE SER DEFINIDA COMO A ATUA��O PERMANENTE VOLTADA PARA"},;//A Pesquisa de Clima Organizacional pode ser definida como a atua��o permanente voltada   "},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(55,45,{||"ALCAN�AR E MANTER A MOTIVA��O, O INTERESSE, O ENVOLVIMENTO, PARTICIPA��O E O DESEMPENHO DOS"},; //para alcan�ar e manter a motiva��o, o interesse, o envolvimento, a participa��o e o      "},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(65,45,{||"FUNCION�RIOS. � PORTANTO UM DESAFIO QUE APRESENTA A CADA COLABORADOR VISANDO CONTRIBUIR,   "},; //desempenho dos funcion�rios. �, portanto, um desafio que se apresenta a cada colaborador,"},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(75,45,{||"ATRAV�S DAS RESPOSTAS, PARA UM DESENVOLVIMENTO DE A��ES NO INTUIDO DE TROCAR EXPERI�NCIAS E"},;//visando contribuir, atrav�s das respostas, para um desenvolvimento de a��es no intuito de"},;
oDlg,,oFont,,,,.T.,,,500,30)  
oSay:= tSay():New(85,45,{||"INFORMA��ES E COM ISSO FACILITAR O TRABALHO DE CADA UM."},;
oDlg,,oFont,,,,.T.,,,500,30) 


oSay:= tSay():New(150,45,{||"ESTA PESQUISA COMPREENDE 4 ETAPAS CONCLUINDO UMA DE CADA VEZ"},; //Esta Pesquisa Compreende 4 etapas sempre concluindo uma de cada vez:"},;
oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(170,45,{||":. Pesquisa da organiza��o e sua estrutura;"},;
oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(180,45,{||":. Pesquisa da Gest�o;"},;
oDlg,,oFont,,,,.T.,,,500,30) 
oSay:= tSay():New(190,45,{||":. Pesquisa dos benef�cios;"},;
oDlg,,oFont,,,,.T.,,,500,30)               
oSay:= tSay():New(200,45,{||":. Pesquisa de treinamento."},;
oDlg,,oFont,,,,.T.,,,500,30)              


oSay:= tSay():New(230,390,{||":. Desenvolvido: Remerson Y. Mogi"},;
oDlg,,oFontD,,,,.T.,,,500,30)
oSay:= tSay():New(238,390,{||":. aishii@nippon-seikibr.com.br"},;
oDlg,,oFontD,,,,.T.,,,500,30)
oSay:= tSay():New(246,390,{||":. TI - Tecnologia da Informa��o"},;
oDlg,,oFontD,,,,.T.,,,500,30)

 
@ 275,2  To 300, 505
//@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("LP8841")
@ 280, 450 BUTTON "Iniciar >" SIZE 34, 15 ACTION (fFim(oDlg),quest01A()) 
          
ACTIVATE DIALOG oDlg
return


**********************************
Static Function quest01A()        	
**********************************
Do while empty(mv_par01)
      Pergunte("SZQ001") 

      dbSelectArea("SZQ")
      dbSetOrder(2)
      If dbSeek(strzero(year(ddatabase),4)+strzero(month(ddatabase),2)+alltrim(mv_par01))
         mv_par01:=""
         //msgstop("Usuario ja realizou a pesquisa !!"+"Entre com outro usuario...") 
         aOp:= {"Ok","Cancel"}
         cTit:= "Atencao!"
         cMsg:= "Usuario ja realizou a pesquisa !!   Entre com outro usuario..."
         nOp:= Aviso(cTit,cMsg,aOp)     
         If nOp == 1    // Sim                    
         Else           // Nao ou <ESC>   
	            return
         Endif  
      end
enddo
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg01A TITLE "AVALIA��O ESTRUTURAL 1.1"

@ 06,2  To 275, 505
@ 10,6    SAY   "1.A miss�o desta empresa � conhecida.   "
@ 15,6    SAY   "Todos sabem onde queremos chegar ?      "  
@ 25,6    RADIO aResp VAR anRadion[1] 

@ 10,135  SAY   "2.Os objetivos desta empresa s�o claros "
@ 15,135  SAY   "e conservadores? Gostamos de desafios.  "  
@ 25,135  RADIO aResp VAR anRadion[2] 

@ 10,275  SAY   "3.Os fluxos de trabalho interno s�o     "
@ 15,275  SAY   "eficientes? As melhorias s�o constantes."  
@ 25,275  RADIO aResp VAR anRadion[3] 

@ 10,390  SAY   "4.Nossos clietes nos v�em como uma �tima"
@ 15,390  SAY   "empresa.                                "  
@ 25,390  RADIO aResp VAR anRadion[4]

@ 70,6    SAY   "5.Nossos empregados trabalham motivados "
@ 75,6    SAY   "e satisfeitos. Ninguem reclama ?.       "  
@ 85,6    RADIO aResp VAR anRadion[5]

@ 70,135  SAY   "6.As opini�es das pessoas s�o acolhidas"
@ 75,135  SAY   "e quase sempre aproveitadas.           "  
@ 85,135  RADIO aResp VAR anRadion[6]

@ 70,275  SAY   "7.Nossos salarios e beneficios s�o com- "
@ 75,275  SAY   "petitivos com o mercado em que atuamos. "  
@ 85,275  RADIO aResp VAR anRadion[7] 

@ 70,390  SAY   "8.Nossas equipes tem um papel importante"
@ 75,390  SAY   "nos resultados desta empresa?           "  
@ 85,390  RADIO aResp VAR anRadion[8]

@ 130,6   SAY   "9.Nossos chefes s�o acessiveis e interes-"
@ 135,6   SAY   "sados em nossos problemas e dificudades. "  
@ 145,6   RADIO aResp VAR anRadion[9]

@ 130,135 SAY   "10.O relacionamento interpessoal � exelen"
@ 135,135 SAY   "te. O feedback � aceito com naturalidade?"  
@ 145,135 RADIO aResp VAR anRadion[10]      


@ 130,275 SAY   "11.As diversas �reas da empresa(TI,Produ-"
@ 135,275 SAY   "��o,RH...)interagem entre si muito bem.  "  
@ 145,275 RADIO aResp VAR anRadion[11]

@ 130,390  SAY   "12.As diferen�as de opini�o s�o discuti-"
@ 135,390  SAY   "das e administradas a contento.         "  
@ 145,390  RADIO aResp VAR anRadion[12]

@ 190,6  SAY   "13.Esta empresa se preocupa com o progresso"
@ 195,6  SAY   " profissional dos empregados              "  
@ 205,6  RADIO aResp VAR anRadion[13]

@ 190,135  SAY   "14.Os empregados s�o envolvidos nas deci-"
@ 195,135  SAY   "s�es que afetam seu trabalho?           "  
@ 205,135 RADIO aResp VAR anRadion[14] 

@ 190,275  SAY   "15.Os empregados dizem que vale a pena  "
@ 195,275  SAY   "trabalhar aqui. O turnover � pequeno    "  
@ 205,275  RADIO aResp VAR anRadion[15] 

@ 190,390  SAY   "16.O ambiente fisico � limpo e bem orga-"
@ 195,390  SAY   "nizado. Todos colaboram na limpeza."  
@ 205,390  RADIO aResp VAR anRadion[16]


@ 275,2  To 300, 505
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg01A),Quest01B()),;
                                                   IIF(validaQ1A()=="",(fFim(oDlg01A),Quest01B()),msgstop(validaQ1A())) )
ACTIVATE DIALOG oDlg01A
Return 


**********************************
Static Function Quest01B()
**********************************
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg01B TITLE "AVALIA��O ESTRUTURAL 1.2"

@ 06,2  To 275, 505
@ 10,6    SAY   "17.Os equipamentos e ferramentas s�o con"
@ 15,6    SAY   "servados adequadamente.                 "  
@ 25,6    RADIO aResp VAR anRadion[17] 

@ 10,135  SAY   "18. Nossas reuni�es s�o objetivas. aqui "
@ 15,135  SAY   "n�o perdemos tempo.                     "  
@ 25,135  RADIO aResp VAR anRadion[18] 

@ 10,275  SAY   "19. Estamos buscando sempre a efici�ncia"
@ 15,275  SAY   "em nosso trabalho.                      "  
@ 25,275  RADIO aResp VAR anRadion[19] 

@ 10,390  SAY   "20. Esta empresa proporciona produtos   "
@ 15,390  SAY   "e servi�os competitivos.                "  
@ 25,390  RADIO aResp VAR anRadion[20]


@ 275,2  To 300, 505
@ 280, 410 BUTTON "< Voltar  " SIZE 34, 15 ACTION (fFim(oDlg01B),quest01A()) 
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION iif(passa ,(fFim(oDlg01B),quest02A()),validaQ1B())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg01B),quest02A()),;
                                                   IIF(validaQ1B()=="",(fFim(oDlg01B),quest02A()),msgstop(validaQ1B())) )
ACTIVATE DIALOG oDlg01B
Return


**********************************
Static Function quest02A()
**********************************
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg02A TITLE "AVALIA��O DE CLIMA / GEST�O 2.1"

@ 06,2  To 275, 505

@ 10,6     SAY   "1.Como voc� percebe seu n�vel de motiva��o profissional  "
@ 15,6     SAY   "e pessoal trabalhando na NSB?"  
@ 25,6     RADIO aResp2a VAR anRadion2[1] 

@ 10,177   SAY   "2.Como voc� percebe seu papel na quest�o operacional     "
@ 15,177   SAY   "na NSB?                                                  "  
@ 25,177   RADIO aResp2b VAR anRadion2[2] 

@ 10,350   SAY   "3.Qual o refor�o de crescimento da maturidade psicol�gica"
@ 15,350   SAY   "e profissional do trabalhador de n�vel operacional na NSB?"
@ 25,350   RADIO aResp2c VAR anRadion2[3] 

@ 70,006   SAY   "4.Qual o fator que voc� considera o maior causador da     "
@ 75,006   SAY   "desmotiva��o do trabalhador da NSB?   "
@ 85,006   RADIO aResp2d VAR anRadion2[4]

@ 70,177   SAY   "5.Como voc� classifica sua fun��o para a motiva��o  do seu"
@ 75,177   SAY   "trabalho na NSB?                                          "  
@ 85,177   RADIO aResp2e VAR anRadion2[5]

@ 70,350   SAY   "6.Como � a comunica��o entre Chefe, supervisor, l�der e   "
@ 75,350   SAY   "liderado para a motiva��o do trabalhador na NSB ?         "
@ 85,350   RADIO aResp2f VAR anRadion2[6]

@ 130,006  SAY   "7.Como voc� observa o conhecimento do seu superior nas ati-"
@ 135,006  SAY   "vidades exercidas por voc� e que ele superviosiona?"
@ 145,006  RADIO aResp2g VAR anRadion2[7] 

@ 130,177  SAY   "8.Como voc� observa os desafios no trabalho para a motiva��o"
@ 135,177  SAY   " do trabalhador na NSB?                                     "  
@ 145,177  RADIO aResp2h VAR anRadion2[8]

@ 130,350  SAY   "9.Qual a import�ncia da autonomia e da participa��o para a  "
@ 135,350  SAY   "motiva��o do trabalhador na NSB?                            "
@ 145,350  RADIO aResp2i VAR anRadion2[9]

@ 190,006  SAY   "10.Qual a rela��o entre a motiva��o do trabalhador de n�vel "
@ 195,006  SAY   "operacional com a Qualidade produzida? "
@ 205,006  RADIO aResp2j VAR anRadion2[10]


@ 275,2  To 300, 505     
@ 280, 410 BUTTON "< Voltar  "  SIZE 34, 15 ACTION (fFim(oDlg02A),quest01B())
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION (fFim(oDlg02A),Quest02B())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg02A),Quest02B()),;
                                                   IIF(validaQ2A()=="",(fFim(oDlg02A),Quest02B()),msgstop(validaQ2A())) )
ACTIVATE DIALOG oDlg02A
Return 


**********************************
Static Function Quest02B()
**********************************
Local oDlg02B, oSay, oFont2b := TFont():New("Time New Roman",,-11,.T.,.T.)   
Local oDlg02B, oSay, oFont2bq:= TFont():New("Time New Roman",,-8 ,.T.,.T.)    
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg02B TITLE "AVALIA��O DE CLIMA / GEST�O 2.2"

@ 06,2  To 275, 505

oSay:= tSay():New(00,120,{||"Sinalise sua opini�o � respeito dos nossos gestores e sua atua��o na NSB"},;
oDlg02B,,oFont2b,,,,.T.,,,500,30)  

oSay:= tSay():New(010,6,{||"Presidencia e Diretoria"},;
oDlg02B,,oFont2b,,,,.T.,,,500,30)  

@ 020,006  SAY   "11.1 Compet�ncia"
@ 030,006  RADIO aResp2l VAR anRadion2[11]

@ 075,006  SAY   "12.2 Gest�o de pessoas"
@ 085,006  RADIO aResp2m VAR anRadion2[12]

oSay:= tSay():New(010,135,{||"Gerencia"},;
oDlg02B,,oFont2b,,,,.T.,,,500,30)  

@ 020,135  SAY   "13.1 Compet�ncia"
@ 030,135  RADIO aResp2l VAR anRadion2[13]

@ 075,135  SAY   "14.2 Gest�o de pessoas"
@ 085,135  RADIO aResp2m VAR anRadion2[14]  

oSay:= tSay():New(010,275,{||"Supervis�o"},;
oDlg02B,,oFont2b,,,,.T.,,,500,30)  

@ 020,275  SAY   "15.1 Compet�ncia"
@ 030,275  RADIO aResp2l VAR anRadion2[15]

@ 075,275  SAY   "16.2 Gest�o de pessoas"
@ 085,275  RADIO aResp2m VAR anRadion2[16]

oSay:= tSay():New(010,390,{||"Chefia"},;
oDlg02B,,oFont2b,,,,.T.,,,500,30)   

@ 020,390  SAY   "17.1 Compet�ncia"
@ 030,390  RADIO aResp2l VAR anRadion2[17]

@ 075,390  SAY   "18.2 Gest�o de pessoas"
@ 085,390  RADIO aResp2m VAR anRadion2[18]


@ 275,2  To 300, 505
@ 280, 410 BUTTON "< Voltar  " SIZE 34, 15 ACTION (fFim(oDlg02B),quest02A())
//@ 280, 450 BUTTON "Continua >" SIZE 34, 15 ACTION (fFim(oDlg02B), quest03A()) 
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg02B),quest03A()),;
                                                   IIF(validaQ2B()=="",(fFim(oDlg02B),quest03A()),msgstop(validaQ2B())) )
ACTIVATE DIALOG oDlg02B
Return


**********************************
Static Function quest03A()
**********************************

Local oDlg03A, oSay, oFont3a := TFont():New("Time New Roman",,-11,.T.,.T.)   
Local oDlg03A, oSay, oFont3aq:= TFont():New("Time New Roman",,-8 ,.T.,.T.)  
passa:=.f. 
@ 96,20 To 700,1027 DIALOG oDlg03A TITLE "AVALIA��O DOS BENEFICIOS 3.1"

@ 06,2  To 275, 505

oSay:= tSay():New(010,177,{||"P L A N O  DE  S A U D E"},;
oDlg03A,,oFont3a,,,,.T.,,,500,30)  
@ 20,6     SAY   "1.Atendimento Geral"  
@ 30,6     RADIO aResp3a VAR anRadion3[1]       

@ 20,177   SAY   "2.Consultas(Periodo)"                
@ 30,177   RADIO aResp3b VAR anRadion3[2] 

@ 20,350   SAY   "3.Exames (Cobertura)"
@ 30,350   RADIO aResp3c VAR anRadion3[3] 

@ 75,006   SAY   "4.Especialidades Cl�nicas"
@ 85,006   RADIO aResp3d VAR anRadion3[4]

@ 75,177   SAY   "5.Hospitais (Cirurgias)"  
@ 85,177   RADIO aResp3e VAR anRadion3[5]

@ 75,350   SAY   "6.Pronto Socorro"
@ 85,350   RADIO aResp3f VAR anRadion3[6]

oSay:= tSay():New(125,177,{||"D R O G A R I A"},;
oDlg03A,,oFont3a,,,,.T.,,,500,30)
@ 135,006  SAY   "7.Atendimento Geral"
@ 145,006  RADIO aResp3g VAR anRadion3[7] 

@ 135,177  SAY   "8.Medicamentos"  
@ 145,177  RADIO aResp3h VAR anRadion3[8]

@ 135,350  SAY   "9.Desconto em folha"
@ 145,350  RADIO aResp3i VAR anRadion3[9]
                                 

oSay:= tSay():New(190,177,{||"� T I C A"},;
oDlg03A,,oFont3a,,,,.T.,,,500,30) 
@ 200,006  SAY   "10.Atendimento Geral"
@ 210,006  RADIO aResp3j VAR anRadion3[10] 

@ 200,177  SAY   "11.Produto"  
@ 210,177  RADIO aResp3l VAR anRadion3[11]

@ 200,350  SAY   "12.Desconto em folha"
@ 210,350  RADIO aResp3m VAR anRadion3[12]

@ 275,2  To 300, 505     
@ 280, 410 BUTTON "< Voltar  "  SIZE 34, 15 ACTION (fFim(oDlg03A),quest02B())
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION (fFim(oDlg03A),quest03B())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg03A),quest03B()),;
                                                   IIF(validaQ3A()=="",(fFim(oDlg03A),quest03B()),msgstop(validaQ3A())) )

ACTIVATE DIALOG oDlg03A
Return 


**********************************
Static Function quest03B()
**********************************

Local oDlg03B, oSay, oFont3b := TFont():New("Time New Roman",,-11,.T.,.T.)   
Local oDlg03B, oSay, oFont3bq:= TFont():New("Time New Roman",,-8 ,.T.,.T.)   
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg03B TITLE "AVALIA��O DOS BENEFICIOS 3.2"

@ 06,2  To 275, 505

oSay:= tSay():New(010,177,{||"T R A N S P O R T E"},;
oDlg03B,,oFont3b,,,,.T.,,,500,30)  
@ 20,6     SAY   "13.Atendimento Geral"  
@ 30,6     RADIO aResp3n VAR anRadion3[13] 

@ 20,177   SAY   "14.Carros"                
@ 30,177   RADIO aResp3o VAR anRadion3[14] 

@ 20,350   SAY   "15.Motoristas"
@ 30,350   RADIO aResp3p VAR anRadion3[15] 

@ 75,006   SAY   "16.Distribui��o de rotas"
@ 85,006   RADIO aResp3q VAR anRadion3[16]

@ 75,177   SAY   "17.Hor�rio de entrada"  
@ 85,177   RADIO aResp3r VAR anRadion3[17]

@ 75,350   SAY   "18.Embarque / Desembarque"
@ 85,350   RADIO aResp3s VAR anRadion3[18]

oSay:= tSay():New(125,177,{||"A L I M E N T A � � O"},;
oDlg03B,,oFont3b,,,,.T.,,,500,30)
@ 135,006  SAY   "19.Atendimento Geral"
@ 145,006  RADIO aResp3t VAR anRadion3[19] 

@ 135,177  SAY   "20.Desejum"  
@ 145,177  RADIO aResp3u VAR anRadion3[20]

@ 135,350  SAY   "21.Almo�o / Jantar"
@ 145,350  RADIO aResp3v VAR anRadion3[21]                                 

@ 190,006  SAY   "22.Lanche"
@ 200,006  RADIO aResp3x VAR anRadion3[22] 

@ 190,177  SAY   "23.Bebida(Cafe,leite,suco)"  
@ 200,177  RADIO aResp3z VAR anRadion3[23]

@ 190,350  SAY   "24.Sobremesa"
@ 200,350  RADIO aResp3w VAR anRadion3[24]

@ 275,2  To 300, 505    
@ 280, 410 BUTTON "< Voltar  "  SIZE 34, 15 ACTION (fFim(oDlg03B),quest03A())
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION (fFim(oDlg03B),quest03C())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg03B),quest03C()),;
                                                   IIF(validaQ3B()=="",(fFim(oDlg03B),quest03C()),msgstop(validaQ3B())) )

ACTIVATE DIALOG oDlg03B                                                 
Return 

**********************************
Static Function quest03C()
**********************************

Local oDlg03C, oSay, oFont3c := TFont():New("Time New Roman",,-11,.T.,.T.)   
Local oDlg03C, oSay, oFont3cq:= TFont():New("Time New Roman",,-8 ,.T.,.T.)   
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg03C TITLE "AVALIA��O DOS BENEFICIOS 3.3"

@ 06,2  To 275, 505

oSay:= tSay():New(010,177,{||"C E S T A    B � S I C A"},;
oDlg03C,,oFont3c,,,,.T.,,,500,30)  
@ 20,6     SAY   "25.Valor (R$ 35,00)"  
@ 30,6     RADIO aResp3y VAR anRadion3[25] 

@ 20,177   SAY   "26.Uso de cart�o alimenta��o"                
@ 30,177   RADIO aResp3k VAR anRadion3[26] 

@ 20,350   SAY   "27.Absente�smo"
@ 30,350   RADIO aResp3a1 VAR anRadion3[27] 

@ 275,2  To 300, 505  
@ 280, 410 BUTTON "< Voltar  "  SIZE 34, 15 ACTION (fFim(oDlg03C),quest03B())
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION (fFim(oDlg03C),quest04A())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg03C),quest04A()),;
                                                   IIF(validaQ3C()=="",(fFim(oDlg03C),quest04A()),msgstop(validaQ3C())) )

ACTIVATE DIALOG oDlg03C
Return 

**********************************
Static Function quest04A()
**********************************
passa:=.f.
@ 96,20 To 700,1027 DIALOG oDlg04A TITLE "AVALIA��O TREINAMENTO 4.1"

@ 06,2  To 275, 505
@ 10,6    SAY   "1.Atende o levantamento de necessidade  "
@ 15,6    SAY   "de Treinamento ?                        "  
@ 25,6    RADIO aResp4a VAR anRadion4[1] 

@ 10,135  SAY   "2.Todos os colaboradores s�o favorecidos"
@ 15,135  SAY   "com os treinamentos ?                   "  
@ 25,135  RADIO aResp4b VAR anRadion4[2] 

@ 10,275  SAY   "3.Como voc� classifica os treinamentos  "
@ 15,275  SAY   "realizados ?                            "  
@ 25,275  RADIO aResp4c VAR anRadion4[3] 

@ 10,390  SAY   "4.Como voc� classifica as institui��es "
@ 15,390  SAY   "externas que ministram os treinamento da NSB."  
@ 25,390  RADIO aResp4d VAR anRadion4[4]

@ 70,6    SAY   "5.Como voc� classifica os treinamentos  "
@ 75,6    SAY   "internos ?                              "  
@ 85,6    RADIO aResp4e VAR anRadion4[5]

@ 70,135  SAY   "6.Que treinamento voc� considera os mais"
@ 75,135  SAY   "importantes para a NSB ?                "  
@ 85,135  RADIO aResp4f VAR anRadion4[6]

@ 70,275  SAY   "7.Qual o grupo que voc� considera que   "
@ 75,275  SAY   " mais necessita de treinamento ?        "  
@ 85,275  RADIO aResp4g VAR anRadion4[7] 

@ 70,390  SAY   "8.Voc� considera os treinamentos como ?"  
@ 85,390  RADIO aResp4h VAR anRadion4[8]

@ 275,2  To 300, 505
@ 280, 410 BUTTON "< Voltar  "  SIZE 34, 15 ACTION (fFim(oDlg04A),quest03C())
//@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION (fFim(oDlg04A),resultQ())
@ 280, 450 BUTTON "Continua >"  SIZE 34, 15 ACTION IIF(passa ,(fFim(oDlg04A),resultQ()),;
                                                   IIF(validaQ4A()=="",(fFim(oDlg04A),resultQ()),msgstop(validaQ4A())) )

ACTIVATE DIALOG oDlg04A
Return 


//*******************************
//** VALIDA��ES DOS QUESTIONARIOS
//*******************************
**********************************
Static Function validaQ1A()
**********************************
msg:=""
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=1 to 16//len(anRadion)       
    if anRadion[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.
    end
next
    if !nRespondeu    
       passa:=.t. 
    else
       msg:="Por Favor verifique as quest�es :"  + qt 
    end    
Return msg

**********************************
Static Function validaQ1B()
**********************************
qt :="" 
msg:=""
nRespondeu:=.f. 
valida:=.F.
for i:=17 to len(anRadion)       
    if anRadion[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t. 
    else
       msg:="Por Favor verifique as quest�es :"  + qt   
    end    
Return msg

**********************************
Static Function validaQ2A()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=1 to 10      
    if anRadion2[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt     

**********************************
Static Function validaQ2B()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=11 to len(anRadion2)      
    if anRadion2[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt

**********************************
Static Function validaQ3A()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=1 to 12    
    if anRadion3[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt

**********************************
Static Function validaQ3B()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=13 to 24  
    if anRadion3[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt

**********************************
Static Function validaQ3C()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=25 to len(anRadion3)     
    if anRadion3[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt 

**********************************
Static Function validaQ4A()
**********************************
qt:=""
nRespondeu:=.f. 
valida:=.F.
for i:=1 to len(anRadion4)     
    if anRadion4[i]==0
       if valida 
          qt+= " - "        
       end               
       qt+= strzero(i,2)
       nRespondeu:=.T. 
       valida:=.t.  
    end
next
    if !nRespondeu    
       passa:=.t.       
    end    
Return qt 
**********************************
Static Function resultQ()
********************************** 
for i:=1 to len(anRadion)
    cadastraSZQ("001",i,anRadion[i])
next
for i:=1 to len(anRadion2)
    cadastraSZQ("002",i,anRadion2[i])
next
for i:=1 to len(anRadion3)
    cadastraSZQ("003",i,anRadion3[i])
next
for i:=1 to len(anRadion4)
    cadastraSZQ("004",i,anRadion4[i])
next

@ 96,20 To 700,1027 DIALOG oDlgR TITLE "FINAL DA AVALIA��O"    
@ 06,2  To 275, 505
a:=0
b:=0
c:=0
d:=0
e:=0

for i:=1 to len(anRadion)    
    do case
       case anRadion[i]==1
            a+=1
       case anRadion[i]==2
            b+=1
       case anRadion[i]==3
            c+=1
       case anRadion[i]==4                 
            d+=1
       case anRadion[i]==5
            e+=1
    endcase
next
@ 10,20   SAY   ":. SUA AVALIA��O FOI UM SUCESSO "
@ 20,20   SAY   ":. SIMULA��O RESULTADO DO QUESTIONARIO 1"
@ 30,20   SAY   ":. A NSB Atende Satisfatorimente no contexto geral da estrutura organizacional?"

@ 50,20   SAY   strzero(a,2) +" Fortemete Concordo"
@ 60,20   SAY   strzero(b,2) +" Concordo"
@ 70,20   SAY   strzero(c,2) +" Discordo"
@ 80,20   SAY   strzero(d,2) +" Discordo Completamente"
@ 90,20   SAY   strzero(e,2) +" Sem Opini�o"


@ 120,20  SAY   "OBRIGADO POR SUA PARTICIPA��O" 
@ 130,20  SAY   "Elaborado por: Elda Pacheco - RH" 

@ 280, 450 BUTTON "SAIR >" SIZE 34, 15 ACTION SairFim() 
ACTIVATE DIALOG oDlgR                            
Return  

**********************************
Static Function cadastraSZQ(nQuest,nPerg,nResp)
********************************** 
//ADD REGISTRO
RecLock("SZQ",.T.)
	     SZQ->ZQ_FILIAL := xFilial("SZQ")
         SZQ->ZQ_ANO    := strzero(year(ddatabase),4)
         SZQ->ZQ_MES    := strzero(month(ddatabase),2)
         SZQ->ZQ_USER   := MV_PAR01
         SZQ->ZQ_QUEST  := nQuest          
         SZQ->ZQ_PERG   := strzero(nPerg ,2)  
         SZQ->ZQ_RESP   := nResp
         SZQ->(MsUnlock())
//ADD REGISTRO 
return

********************************
Static Function SairFim()
*******************************
//fFim(oDlgR)

While .T.  
     aOp:= {"Sim","Nao"}
     cTit:= "Atencao!"
     cMsg:= "Voc� deseja sair do sistema ?"
     nOp:= Aviso(cTit,cMsg,aOp)     
     If nOp == 1    // Sim 
         fFim(oDlgR)                  
        //return        
     Else           // Nao ou <ESC>   
        //resultQ()
        exit
     Endif
     Exit

EndDo

Return 
                                                                  
**********************************
Static Function fFim(oDlgx)
**********************************
Close(oDlgx)
Return      

**********************************
Static Function validaUser(cMat)
**********************************
 cfMat:=""
 cQuery := ""
 cQuery := " select RA_MAT,RA_NOME,RA_CC"
 cQuery += " from DADOSAP10..SRA010" 
 cQuery += " WHERE RA_MAT <> '"+cMat+"'"
 cQuery += " UNION"
 cQuery += " select RA_MAT,RA_NOME,RA_CC"
 cQuery += " from DADOSAP10..SRA020"
 cQuery += " WHERE RA_MAT <> '"+cMat+"'"
 cQuery += " ORDER BY RA_MAT"
 
 cQuery := ChangeQuery(cQuery)

 TCQUERY cQuery Alias TRA New      // Tabela de Funcionario Temporarios

 DbSElectArea("TRA") 
 
 cfMat:=TRA->RA_MAT
 
 dbSelectArea("TRA")
 dbClearFil(NIL)
 dbCloseArea("TRA")
 dbCloseArea()
 Return  cfMat