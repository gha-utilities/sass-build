t11                                                          The SAS System                            09:29 Friday, November 13, 2020
t 
s 1          ;*';*";*/;quit;run;
s 2          OPTIONS PAGENO=MIN;
s 3          %LET _CLIENTTASKLABEL='Segmento e Nomenclatura';
s 4          %LET _CLIENTPROCESSFLOWNAME='Process Flow';
s 5          %LET _CLIENTPROJECTPATH='\\fscorp\PREVIEW\25.Leonardo\Concluidos\89.BID Vidros\Bid Vidros4.egp';
s 6          %LET _CLIENTPROJECTPATHHOST='01L11691D778654';
s 7          %LET _CLIENTPROJECTNAME='Bid Vidros4.egp';
s 8          
s 9          ODS _ALL_ CLOSE;
s 10         OPTIONS DEV=PNG;
s 11         GOPTIONS XPIXELS=0 YPIXELS=0;
s 12         FILENAME EGSR TEMP;
s 13         ODS tagsets.sasreport13(ID=EGSR) FILE=EGSR
s 14             STYLE=HTMLBlue
s 15             STYLESHEET=(URL="file:///C:/Program%20Files/SASHome/SASEnterpriseGuide/7.1/Styles/HTMLBlue.css")
s 16             NOGTITLE
s 17             NOGFOOTNOTE
s 18             GPATH=&sasworklocation
s 19             ENCODING=UTF8
s 20             options(rolap="on")
s 21         ;
n NOTE: Writing TAGSETS.SASREPORT13(EGSR) Body file: EGSR
s 22         
s 23         GOPTIONS ACCESSIBLE;
s 24         %_eg_conditional_dropds(GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0003);
n NOTE: Table GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0003 has been dropped.
n NOTE: PROCEDURE SQL used (Total process time):
n       real time           0.01 seconds
n       cpu time            0.00 seconds
n       
n 
s 25         
s 26         PROC SQL;
s 27            CREATE TABLE GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0003 AS
s 28            SELECT DISTINCT t1.CNTDIMCOD,
s 29                   t1.RAMCOD AS Ramo,
s 30                   t1.SUCCOD AS Sucursal,
s 31                   t1.APLNUMDIG AS 'Apólice'n,
s 32                   t1.ITMNUMDIG AS Item,
s 33                   t1.EDSNUMDIG AS Endosso,
s 34                   t1.SEGNOM AS 'Nome Segurado'n,
s 35                   t1.ENDLGDTIP AS TipoLogradouro,
s 36                   t1.ENDLGD AS Logradouro,
s 37                   t1.ENDNUM AS Numero,
s 38                   t1.ENDCMP AS Complemento,
s 39                   t1.ENDBRR AS Bairro,
s 40                   t1.ENDCID AS Cidade,
s 41                   t1.ENDCEP AS Cep,
s 42                   t1.ENDCEPCMP AS ComplementoCep,
s 43                   t1.UFDCOD AS UF,
s 44                   t1.CGCCPFNUM AS CPF,
s 45                   t1.CGCCPFDIG AS DigitoCPF,
s 46                   t1.CGCORD AS OrdemCNPJ,
s 47                   t1.DDDRESNUM AS DDDTelefone,
s 48                   t1.TELRESNUM AS Telefone,
s 49                   t1.NSCDAT AS DataNascimento,
s 50                   t1.SEXSGL AS Sexo,
s 51                   t1.TMPVIGINCAPLCOD AS InicioVigencia,
t12                                                          The SAS System                            09:29 Friday, November 13, 2020
t 
s 52                   t1.TMPVIGFNLAPLCOD AS FimVigencia,
s 53                   t1.TMPEMSAPLCOD AS DataEmissao,
s 54                   t1.TMPVIGINCDOCCOD AS DataEndosso,
s 55                   t1.VCLMRCNOM AS Montadora,
s 56                   t1.VCLMDLNOMCPL AS 'Modelo (VCLMDLNOMCPL)'n,
s 57                   t1.VCLANOMDLDES AS AnoModelo,
s 58                   t1.VCLCHSCMP AS Chassi,
s 59                   t1.VCLLICNUM AS Placa,
s 60                   t1.VCL0KMDES AS Veiculo0KM,
s 61                   t1.CORSUS AS 'CódigoCorretor'n,
s 62                   t1.SUCNOM AS NomeSucursal,
s 63                   t1.CTGTRFDIMCOD AS CodCategoriaTarifaria,
s 64                   t1.CTGTRFDES AS DescCategoriaTarifaria,
s 65                   t1.CLSCOD AS Clausula,
s 66                   t1.TMPEMSDOCCOD AS DocCod,
s 67                   t1.VCLDES,
s 68                   t1.AUTCLISGMCOD,
s 69                   t1.AUTCLISGMNOM,
s 70                   t1.BLIIMSVLR,
s 71                   t1.CVNNOM,
s 72                   t1.STTDES,
s 73                   t1.COD_FIPE,
s 74                   t1.TMPVIGFNLDOCCOD,
s 75                   t1.TMPEMSITMCOD,
s 76                   t1.TMPVIGINCITMCOD,
s 77                   t1.TMPVIGFNLITMCOD,
s 78                   t1.CLALCLDIMCOD,
s 79                   t1.BONCLADIMCOD,
s 80                   t1.CORDIMCOD,
s 81                   t1.ENDCIADIMCOD,
s 82                   t1.PESDOCDIMCOD,
s 83                   t1.SEGTIPDIMCOD,
s 84                   t1.VCLUSODIMCOD,
s 85                   t1.VCL0KMDIMCOD,
s 86                   t1.VCLLNHDIMCOD,
s 87                   t1.VCLTIPDIMCOD,
s 88                   t1.EDSTIPDIMCOD,
s 89                   t1.EMSTIPDIMCOD,
s 90                   t1.CLCTIPDIMCOD,
s 91                   t1.SUCDIMCOD,
s 92                   t1.MDLDIMCOD,
s 93                   t1.VCLMDLDIMCOD,
s 94                   t1.VCLMRCDIMCOD,
s 95                   t1.VCLCMBDIMCOD,
s 96                   t1.FUNDIMCOD,
s 97                   t1.PGTFRMDIMCOD,
s 98                   t1.EMPDIMCOD,
s 99                   t1.VCLLICDIMCOD,
s 100                  t1.VCLCHSDIMCOD,
s 101                  t1.VCLANOMDLDIMCOD,
s 102                  t1.STTAPLDIMCOD,
s 103                  t1.STTDOCDIMCOD,
s 104                  t1.STTITMDIMCOD,
s 105                  t1.CRTGRPDIMCOD,
s 106                  t1.IDDANOVCLDIMCOD,
s 107                  t1.IDDSEGDIMCOD,
s 108                  t1.VCLPORQTDDIMCOD,
s 109                  t1.VCLANOFABDIMCOD,
t13                                                          The SAS System                            09:29 Friday, November 13, 2020
t 
s 110                  t1.DCTNUMSEQ,
s 111                  t1.FRQCLADIMCOD,
s 112                  t1.VIDSRGTIPDIMCOD,
s 113                  t1.CLSDIMCOD,
s 114                  t1.CASIMSVLR,
s 115                  t3.AUTDCTSGMNOM
s 116              FROM GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0001 t1
s 117                   LEFT JOIN DWSIN.ADWKAUTDCTSGMDIM t3 ON (t1.AUTDCTSGMDIMCOD = t3.AUTDCTSGMDIMCOD);
d ORACLE: SELECT * FROM DW.ADWKAUTDCTSGMDIM 
d ORACLE: SELECT  NULL as TABLE_QUALIFIER,  t.owner as TABLE_OWNER,  t.table_name as TABLE_NAME,  t.num_rows as ROW_COUNT  FROM  
d all_tables t WHERE  t.table_name='ADWKAUTDCTSGMDIM' AND  t.owner='DW'  
d ORACLE: SELECT  "AUTDCTSGMDIMCOD", "AUTDCTSGMNOM" FROM DW.ADWKAUTDCTSGMDIM  
n NOTE: Compressing data set GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0003 decreased size by 56.35 percent. 
n       Compressed is 28227 pages; un-compressed would require 64662 pages.
n NOTE: Table GRIDWORK.QUERY_FOR_ADWMDCTFAT_000A_0003 created, with 2845099 rows and 88 columns.
d 
s 118        QUIT;
n NOTE: PROCEDURE SQL used (Total process time):
n       real time           1:49.84
n       cpu time            1:50.50
n       
n 
s 119        
s 120        GOPTIONS NOACCESSIBLE;
s 121        
s 122        
s 123        
s 124        %LET _CLIENTTASKLABEL=;
s 125        %LET _CLIENTPROCESSFLOWNAME=;
s 126        %LET _CLIENTPROJECTPATH=;
s 127        %LET _CLIENTPROJECTPATHHOST=;
s 128        %LET _CLIENTPROJECTNAME=;
s 129        
s 130        ;*';*";*/;quit;run;
s 131        ODS _ALL_ CLOSE;
s 132        
s 133        
s 134        QUIT; RUN;
s 135        
