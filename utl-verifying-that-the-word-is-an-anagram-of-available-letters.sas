%let pgm=utl-verifying-that-the-word-is-an-anagram-of-available-letters;

Verifying that the word is an anagram of available letters

I find the sas/wps solution much more readable that R or Python ana maybe faster?

  Two Solutions

        1. SAS
        2. WPS

github
https://tinyurl.com/5n74sbdy
https://github.com/rogerjdeangelis/utl-verifying-that-the-word-is-an-anagram-of-available-letters

StackOverflow R
https://tinyurl.com/4xfdp963
https://stackoverflow.com/questions/73775569/subsetting-dataframe-based-on-lots-of-columns-in-r


Remove rows that do not match the key word. Are not an anagram of key

                                                              |  RULES
  KEY       A     B     C     D     E     F     G     H     I |
                                                              |
1 aged      1     0     0     1     1     0     1     0     0 |
2 caged     1     0     1     1     1     0     1     0     0 |
2 abe       0     1     0     0     1     0     0     0     0 |   No match remove (no A)
3 chide     0     0     1     1     1     0     0     1     1 |
4 head      1     0     0     1     1     0     0     1     0 |
4 deaf      1     0     0     1     1     0     0     0     0 |   No match remove (no f)

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
   informat key $6.;
   input key (a b c d e f g h i) ($2.);
cards4;
AGED 1 0 0 1 1 0 1 0 0
CAGED 1 0 1 1 1 0 1 0 0
ABE 0 1 0 0 1 0 0 0 0
CHIDE 0 0 1 1 1 0 0 1 1
HEAD 1 0 0 1 1 0 0 1 0
DEAF 1 0 0 1 1 0 0 0 0
;;;;
run;quit;


Up to 40 obs WORK.HAVE total obs=6 19SEP2022:11:43:49

Obs     KEY     A    B    C    D    E    F    G    H    I

 1     aged     1    0    0    1    1    0    1    0    0
 2     caged    1    0    1    1    1    0    1    0    0
 3     abe      0    1    0    0    1    0    0    0    0
 4     chide    0    0    1    1    1    0    0    1    1
 5     head     1    0    0    1    1    0    0    1    0
 6     deaf     1    0    0    1    1    0    0    0    0

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/


Up to 40 obs WORK.WANT total obs=4 19SEP2022:13:07:07

        ABAGRAMS

Obs    STR     KEY    A   B   C   D   E   F   G   H   I

 1    ADEG    AGED    1   0   0   1   1   0   1   0   0
 2    ACDEG   CAGED   1   0   1   1   1   0   1   0   0
 3    CDEHI   CHIDE   0   0   1   1   1   0   0   1   1
 4    ADEH    HEAD    1   0   0   1   1   0   0   1   0


/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
 _
/ |    ___  __ _ ___
| |   / __|/ _` / __|
| |_  \__ \ (_| \__ \
|_(_) |___/\__,_|___/

*/

data want;
  length str $9.;
  set have;
  array alpha a--i;
  do over alpha;
      if alpha = 1 then str=cats(str,vname(alpha));
  end;
  if not verify(key, str); * not verified that key is in array;
run;quit;                  * remove if all letters in array are not in key;

/*___
|___ \    __      ___ __  ___
  __) |   \ \ /\ / / `_ \/ __|
 / __/ _   \ V  V /| |_) \__ \
|_____(_)   \_/\_/ | .__/|___/
                   |_|
*/  \

libname sd1 "d:/sd1";

data sd1.have;
   informat key $6.;
   input key (a b c d e f g h i) ($2.);
cards4;
AGED 1 0 0 1 1 0 1 0 0
CAGED 1 0 1 1 1 0 1 0 0
ABE 0 1 0 0 1 0 0 0 0
CHIDE 0 0 1 1 1 0 0 1 1
HEAD 1 0 0 1 1 0 0 1 0
DEAF 1 0 0 1 1 0 0 0 0
;;;;
run;quit;

%utl_submit_wps64('
libname sd1 "d:/sd1";
data want;
  length str $9.;
  set sd1.have;
  array alpha a--i;
  do over alpha;
      if alpha = 1 then str=cats(str,vname(alpha));
  end;
  if not verify(key, str); * not verified that key is in array;
run;quit;
proc print data=want;
run;quit;
');

The WPS System

Obs     STR      KEY     A    B    C    D    E    F    G    H    I

 1     ADEG     AGED     1    0    0    1    1    0    1    0    0
 2     ACDEG    CAGED    1    0    1    1    1    0    1    0    0
 3     CDEHI    CHIDE    0    0    1    1    1    0    0    1    1
 4     ADEH     HEAD     1    0    0    1    1    0    0    1    0



%macro utl_submit_wps64(pgmx,resolve=Y,returnVarName=)/des="submiit a single quoted sas program to wps";

  * whatever you put in the Python or R clipboard will be returned in the macro variable
    returnVarName;

  * if you delay resolution, use resove=Y to resolve macros and macro variables passed to python;

  * write the program to a temporary file;

  %utlfkil(%sysfunc(pathname(work))/wps_pgmtmp.wps);
  %utlfkil(%sysfunc(pathname(work))/wps_pgm.wps);
  %utlfkil(%sysfunc(pathname(work))/wps_pgm001.wps);
  %utlfkil(wps_pgm.lst);

  filename wps_pgm "%sysfunc(pathname(work))/wps_pgmtmp.wps" lrecl=32756 recfm=v;
  data _null_;
    length pgm  $32756 cmd $32756;
    file wps_pgm ;
    %if %upcase(%substr(&resolve,1,1))=Y %then %do;
       pgm=resolve(&pgmx);
    %end;
    %else %do;
      pgm=&pgmx;
    %end;
    semi=countc(pgm,';');
      do idx=1 to semi;
        cmd=cats(scan(pgm,idx,';'),';');
        len=length(strip(cmd));
        put cmd $varying32756. len;
        putlog cmd $varying32756. len;
      end;
  run;

  filename wps_001 "%sysfunc(pathname(work))/wps_pgm001.wps" lrecl=255 recfm=v ;
  data _null_ ;
    length textin $ 32767 textout $ 255 ;
    file wps_001;
    infile "%sysfunc(pathname(work))/wps_pgmtmp.wps" lrecl=32767 truncover;
    format textin $char32767.;
    input textin $char32767.;
    putlog _infile_;
    if lengthn( textin ) <= 255 then put textin ;
    else do while( lengthn( textin ) > 255 ) ;
       textout = reverse( substr( textin, 1, 255 )) ;
       ndx = index( textout, ' ' ) ;
       if ndx then do ;
          textout = reverse( substr( textout, ndx + 1 )) ;
          put textout $char255. ;
          textin = substr( textin, 255 - ndx + 1 ) ;
    end ;
    else do;
      textout = substr(textin,1,255);
      put textout $char255. ;
      textin = substr(textin,255+1);
    end;
    if lengthn( textin ) le 255 then put textin $char255. ;
    end ;
  run ;

  %put ****** file %sysfunc(pathname(work))/wps_pgm.wps ****;

  filename wps_fin "%sysfunc(pathname(work))/wps_pgm.wps" lrecl=255 recfm=v ;
  data _null_;
      retain switch 0;
      infile wps_001;
      input;
      file wps_fin;
      if substr(_infile_,1,1) = '.' then  _infile_= substr(left(_infile_),2);
      select;
         when(left(upcase(_infile_))=:'SUBMIT;')     switch=1;
         when(left(upcase(_infile_))=:'ENDSUBMIT;')  switch=0;
         otherwise;
      end;
      if lag(switch)=1 then  _infile_=compress(_infile_,';');
      if left(upcase(_infile_))= 'ENDSUBMIT' then _infile_=cats(_infile_,';');
      put _infile_;
      putlog _infile_;
  run;quit;

  %let _loc=%sysfunc(pathname(wps_fin));
  %let _w=%sysfunc(compbl(C:\progra~1\worldp~1\wpsana~1\4\bin\wps.exe -autoexec c:\oto\Tut_Otowps.sas -config c:\cfg\wps.cfg));
  %put &_loc;

  filename rut pipe "&_w -sysin &_loc";
  data _null_;
    file print;
    infile rut;
    input;
    put _infile_;
    putlog _infile_;
  run;

  filename rut clear;
  filename wps_pgm clear;
  data _null_;
    infile "wps_pgm.lst";
    input;
    putlog _infile_;
  run;quit;

  * use the clipboard to create macro variable;
  %if "&returnVarName" ne ""  %then %do;
    filename clp clipbrd ;
    data _null_;
     infile clp;
     input;
     putlog "*******  " _infile_;
     call symputx("&returnVarName.",_infile_,"G");
    run;quit;
  %end;


%mend utl_submit_wps64;

%utl_submit_wps64('
PROC SETINIT;
run;quit;
RUN;
');
