<!-- : Begin batch script
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
IF not "%1" == "" ( 
    GOTO :%1
)

:: Framerate Code by einstein1969

:MAIN
CALL :PRELUDE
SET "area=1"
START /B "" %0 RENDER_PROPS

%$silence%
%$music:type name=Track ThingWithFeathers%

%$input% > "%TEMP%\%~n0_sig.txt" | "%~F0" MENU < "%TEMP%\%~n0_sig.txt"
DEL /F /Q "%~dpn0.quit"

:TUTORIAL
%$music:type name=Track AndSheWas%

%$input% > "%TEMP%\%~n0_sig.txt" | "%~F0" STORY < "%TEMP%\%~n0_sig.txt"
DEL /F /Q "%~dpn0.quit"

ECHO %ESC%[21;60H%ESC%[1J ^
     %ESC%[8;5H%ESC%[4mControls%ESC%[0m ^
     %ESC%[10;5HPlay this game using default Terminal CMD settings. ^
     %ESC%[12;5H%ESC%[38;2;129;197;240mW%ESC%[0m  -  Jump. You can change directions in-jump. ^
     %ESC%[13;5H%ESC%[38;2;129;197;240mA%ESC%[0m  -  Move Left / Direction Left ^
     %ESC%[14;5H%ESC%[38;2;129;197;240mD%ESC%[0m  -  Move Right / Direction Right ^
     %ESC%[16;5HAscend the platforms to collect %ESC%[38;2;129;197;240m♦︎%ESC%[0m ^
     %ESC%[17;5HThere is audio, so turn up the volume ^
     %ESC%[20;27HSelect (A^) 
PAUSE >NUL

:AREA_LOOP
%$input% > "%TEMP%\%~n0_sig.txt" | "%~F0" GAME < "%TEMP%\%~n0_sig.txt"
DEL /F /Q "%~dpn0.quit"
SET /A "area+=1"

IF "%area%" == "8" (
    TIMEOUT /T 3 /NOBREAK >NUL
    %$silence%
    %$music:type name=Track ListenToTheGrassGrow%
    SET "area=1"
    ECHO %ESC%[21;60H%ESC%[1J ^
         %ESC%[5;5HAfter returning all 7 crystals to the village, ^
         %ESC%[6;5HThe remaining unaffected villagers were ecstatic. ^
         %ESC%[7;5HYet, as Kaho observed, it seemed as though they ^
         %ESC%[8;5Hhad no effect on the curse. ^
         %ESC%[9;5HThey couldn't stay long however, as the mission ^
         %ESC%[10;5Hwas more important. ^
         %ESC%[11;5H"%ESC%[38;2;145;149;189mI wonder how the village is doing,%ESC%[0m" said Cath. ^
         %ESC%[12;5H"%ESC%[38;2;224;45;45mEven with the curse, they seemed happy.%ESC%[0m" replied Kaho. ^
         %ESC%[13;5H"%ESC%[38;2;224;45;45mAnd once I see the Queen, perhaps I can end all of this.%ESC%[0m" ^
         %ESC%[14;5H"%ESC%[38;2;145;149;189mMaybe we can visit the village once the curse is lifted.%ESC%[0m" ^
         %ESC%[15;5H"%ESC%[38;2;145;149;189mYou and I together, Kaho.%ESC%[0m" ^
         %ESC%[17;5HThey returned to Karst City, continuing their journey. ^
         %ESC%[20;27HSelect (A^)
    PAUSE >NUL
    GOTO :MAIN
)
GOTO :AREA_LOOP

:STORY
SETLOCAL DISABLEDELAYEDEXPANSION

CALL :GEN_SPRITES "Sprites\KahoIdleRight" kaho.idler
CALL :GEN_SPRITES "Sprites\KahoTalkIdle" kaho.talkidle
CALL :GEN_SPRITES "Sprites\CathCute" cath.cute
CALL :GEN_SPRITES "Sprites\CathIdle" cath.idle

SETLOCAL ENABLEDELAYEDEXPANSION

SET "dialogue.1=cath;idle;I met a villager whose village is infested with the curse."
SET "dialogue.2=kaho;idler;As important as my mission is..."
SET "dialogue.3=kaho;talkidle;Perhaps I can help him, and find out more about the curse."
SET "dialogue.4=cath;cute;I'll go with you. You need protecting."
SET "dialogue.5=cath;idle;The villager spoke about these ancient crystals..."
SET "dialogue.6=kaho;idler;Oh?"
SET "dialogue.7=cath;idle;They say they were stolen by demons once the curse started."
SET "dialogue.8=cath;idle;He believes it can stop the curse."
SET "dialogue.9=kaho;talkidle;Can it?"
SET "dialogue.10=cath;idle;I don't know. But if it saves a village, it's worth a shot."
SET "dialogue.11=kaho;talkidle;I passed by some places on my way to Karst..."
SET "dialogue.12=kaho;talkidle;They might be there."
SET "dialogue.13=cath;cute;Great. Let's go."

SET "cath.sprite=cath.idle"
SET "kaho.sprite=kaho.idler"
SET /A "dialogue.num=2", "kaho.cur=cath.cur=0", "until.next=frame=0"
CALL :SET_DIALOGUE_SCENE "%dialogue.1%"

FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t1=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100"

FOR /L %%$ in () DO (
    SET /P "input="
    IF defined input (
        IF not "!input:A=!" == "A" (
            IF !frame! GEQ !until.next! (
                FOR %%D in (!dialogue.num!) DO (
                    IF not defined dialogue.%%D (
                        COPY NUL "%~dpn0.quit" >NUL
                        EXIT
                    )
                    CALL :SET_DIALOGUE_SCENE "!dialogue.%%D!"
                )
                SET /A "dialogue.num+=1", "until.next=frame + 10"
            )
        )
        SET "input="
    )
    FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t2=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100", "dt=t2-t1"
    IF !dt! GTR 3 (
        SET /A "t1=t2", "frame=(frame + 1) %% 0x7FFFFFFF", "anim=frame %% 2"
        FOR /F "tokens=1-4" %%1 in ("!cath.sprite! !cath.cur! !kaho.sprite! !kaho.cur!") DO (
            ECHO %ESC%[21;60H%ESC%[1J ^
                 %ESC%[12;!offset!H%ESC%[38;2;!col!m!text!%ESC%[0m ^
                 %ESC%[20;27HSelect (A^) ^
                 %ESC%[15;33H!%%1.%%2! ^
                 %ESC%[17;25H██████████████ ^
                 %ESC%[15;26H!%%3.%%4!
            IF "!anim!" == "0" (
                SET /A "kaho.cur=(kaho.cur + 1) %% %%3.max", "cath.cur=(cath.cur + 1) %% %%1.max"
            )
        )
    )
)
GOTO :EOF

:SET_DIALOGUE_SCENE <dialogue>
FOR /F "tokens=1-3 delims=;" %%A in ("%~1") DO (
    SET "%%A.sprite=%%A.%%B"
    SET "text=%%C"
    SET "%%A.cur=0"
    IF "%%A" == "kaho" (
        SET "col=224;45;45"
    ) else (
        SET "col=145;149;189"
    )
    CALL :STRLEN "%%C" len
    SET /A "offset=32 - (len / 2)"

)
GOTO :EOF

:MENU
FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t1=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100"

FOR /L %%$ in () DO (
    SET /P "input="
    IF defined input (
        IF not "!input:A=!" == "A" (
            ECHO %ESC%[15;27H%ESC%[38;2;129;197;240mSelect (A^)%ESC%[0m
            %$silence%
            %$music:type name=Effect Confirm%
            COPY NUL "%~dpn0.quit" >NUL
            EXIT
        )
    )
    
    FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t2=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100", "dt=t2-t1"
    IF !dt! GTR 3 (
        SET /A "t1=t2", "frame=(frame + 1) %% 0x7FFFFFFF", "anim=frame %% 2", "spawn=frame %% 3"
        IF "!spawn!" == "0" (
            SET /A "par.num+=1", "par.x=!RANDOM! * (60-2) / 32768 + 3", "par.y=!RANDOM! * (20-2) / 32768 + 3"
            SET "par[!par.num!]=!par.x! !par.y! 4"
            SET "par.list=!par.list! [!par.num!]"
        )
        IF "!anim!" == "0" (
            SET "par.disp="
            FOR %%W in (!par.list!) DO (
                FOR /F "tokens=1-3" %%A in ("!par%%W!") DO (
                    SET /A "par.type=%%C - 1"
                    IF !par.type! EQU -1 (
                        SET "par.list=!par.list:%%W=!"
                        SET "par%%W="
                    ) else (
                        IF !par.type! EQU 3 (
                            SET "par.disp=!par.disp!%ESC%[%%B;%%AH*"
                        ) else IF !par.type! EQU 2 (
                            SET "par.disp=!par.disp!%ESC%[%%B;%%AHº"
                        ) else IF !par.type! EQU 1 (
                            SET "par.disp=!par.disp!%ESC%[%%B;%%AH%ESC%[38;2;138;138;138mº%ESC%[0m"
                        ) else (
                            SET "par.disp=!par.disp!%ESC%[%%B;%%AH%ESC%[A%ESC%[38;2;138;138;138m.%ESC%[0m"
                        )
                        SET "par%%W=%%A %%B !par.type!"
                    )
                )
            )
        )
        
        ECHO %ESC%[21;60H%ESC%[1J ^
             !par.disp! ^
             %ESC%[2;4HLowsun 2025 ^
             %ESC%[10;23H┳┳┓        ┓%ESC%[1B%ESC%[12D┃┃┃┏┓┏┳┓┏┓┏┫┏┓┏┓┏┓%ESC%[1B%ESC%[18D┛ ┗┗┛┛┗┗┗┛┗┻┗┛┛ ┗┻ ^
             %ESC%[1B%ESC%[30D%ESC%[38;2;129;197;240m♦︎%ESC%[0m%ESC%[1m Lunar Glow %ESC%[0m%ESC%[38;2;129;197;240m♦︎%ESC%[0m ^
             %ESC%[15;27HSelect (A^)
    )
)
GOTO :EOF

:GAME
SETLOCAL DISABLEDELAYEDEXPANSION

CALL :GEN_SPRITES "Sprites\KahoWalkRight" kaho.walkr
CALL :GEN_SPRITES "Sprites\KahoWalkLeft" kaho.walkl
CALL :GEN_SPRITES "Sprites\KahoIdleRight" kaho.idler
CALL :GEN_SPRITES "Sprites\KahoIdleLeft" kaho.idlel
CALL :GEN_SPRITES "Sprites\KahoSpin" kaho.spin
CALL :GEN_SPRITES "Sprites\KahoDeath" kaho.death
CALL :GEN_IMAGE "Sprites\Tiles\castle.sixel" castle 3
CALL :GEN_IMAGE "Sprites\Tiles\tele.sixel" tele 4
SET "dirt=█"
SET "endl=▐"
SET "endr=▌"
SET "shrine=%ESC%[38;2;232;72;117m╬%ESC%[0m"
SET "spike.1=▲"
SET "spike.0=♠︎"
SET "spike.-1=─"
SET "jump=%ESC%[38;2;36;224;127m↕︎%ESC%[0m"
SET "win=%ESC%[38;2;129;197;240m♦︎%ESC%[0m"

SETLOCAL ENABLEDELAYEDEXPANSION

CALL :SELECT_LEVEL %area%

SET "kaho.sprite=kaho.idler"
SET /A "kaho.cur=0", "kaho.dir=kaho.begin.dir", "kaho.y=kaho.begin.y", "kaho.x=kaho.begin.x", "kaho.air=0", "kaho.spike=1", "kaho.fallnex=-1"
FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t1=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100"

FOR /L %%$ in () DO (
    SET /P "input="
    IF "!kaho.sprite!" == "kaho.death" (
        IF "!kaho.cur!" == "23" (
            SET "kaho.sprite=kaho.idler"
            SET "kaho.jump="
            IF "!has.shrine!" == "1" (
                SET "level.1=!level.1:♦=%ESC%[48;2;109;93;227m♦!"
                SET "level.-1=!level.-1:♦=%ESC%[48;2;109;93;227m♦!"
            )
            SET /A "kaho.cur=0", "kaho.y=kaho.begin.y", "kaho.x=kaho.begin.x", "kaho.dir=kaho.begin.dir", "kaho.spike=1", "did.shrine=1 - has.shrine"
        )
    ) else (
        IF defined input (
            IF not "!input:D=!" == "!input!" (
                IF not "!kaho.sprite!" == "kaho.walkr" (
                    SET /A "kaho.cur=0", "kaho.dir=1"
                    SET "kaho.sprite=kaho.walkr"
                )
                IF "!kaho.air!" == "0" (
                   SET /A "kaho.x+=1"
                )
            )
            IF not "!input:A=!" == "!input!" (
                IF not "!kaho.sprite!" == "kaho.walkl" (
                    SET /A "kaho.cur=0", "kaho.dir=-1"
                    SET "kaho.sprite=kaho.walkl"
                )
                IF "!kaho.air!" == "0" (
                   SET /A "kaho.x-=1"
                )
            )
            IF not "!input:W=!" == "!input!" (
                IF "!kaho.air!" == "0" (
                    IF not defined kaho.jump (
                        SET /A "kaho.jump=2", "kaho.jumpnex=frame + 2", "kaho.air=1", "kaho.y-=1", "kaho.spike*=-1"
                    )
                )
            )
            SET /A "until.stop=frame + 3"
            SET "input="
        )
        IF "!frame!" == "!until.stop!"  (
            SET "kaho.cur=0"
            IF "!kaho.dir!" == "1" (
                SET "kaho.sprite=kaho.idler"
            ) else (
                SET "kaho.sprite=kaho.idlel"
            )
        )
        FOR /F "tokens=1-2" %%G in ("#!kaho.y!.!kaho.x!# !kaho.spike!") DO (
            IF "!bound:%%G=!" == "!bound!" (
                IF not defined kaho.jump (
                    IF "!kaho.fallnex!" == "-1" (
                        SET /A "kaho.fallnex=frame + 2"
                    )
                    SET "kaho.air=1"
                    IF "!frame!" == "!kaho.fallnex!" (
                        SET /A "kaho.y+=1", "kaho.fallnex=frame + 2", "kaho.x+=kaho.dir"
                    )
                )
                IF "!kaho.y!" == "19" (
                    SET "kaho.sprite=kaho.death"
                    SET "kaho.cur=0"
                ) else IF "!kaho.x!" == "1" (
                    SET "kaho.sprite=kaho.death"
                    SET "kaho.cur=0"
                ) else IF "!kaho.x!" == "60" (
                    SET "kaho.sprite=kaho.death"
                    SET "kaho.cur=0"
                )
            ) else (
                IF "!kaho.air!" == "1" (
                    SET /A "kaho.air=0", "kaho.fallnex=-1"
                )
            )
            IF defined tele%%Gy (
                SET /A "kaho.y=tele%%Gy", "kaho.x=tele%%Gx"
            ) else IF defined spike%%G.%%H (
                SET "kaho.sprite=kaho.death"
                SET "kaho.cur=0"
            ) else IF defined jump%%G (
                SET /A "kaho.jump=4", "kaho.jumpnex=frame + 2", "kaho.air=1", "kaho.y-=1"
            ) else IF defined shrine%%G (
                SET "level.1=!level.1:%ESC%[48;2;109;93;227m=!"
                SET "level.-1=!level.-1:%ESC%[48;2;109;93;227m=!"
                SET "did.shrine=1"
            ) else IF defined win%%G (
                IF "!did.shrine!" == "1" (
                    CALL :END win
                )
            )   
        )
        IF defined kaho.jump (
            IF "!frame!" == "!kaho.jumpnex!" (
                SET /A "kaho.y-=1", "kaho.x+=kaho.dir", "kaho.jumpnex=frame + 2", "kaho.jump-=1"
                IF "!kaho.jump!" == "0" (
                    SET "kaho.jump="
                )
            )
        )
    )
    FOR /F "tokens=1-4 delims=:.," %%A in ("!TIME: =0!") DO SET /A "t2=(((1%%A*60)+1%%B)*60+1%%C)*100+1%%D-36610100", "dt=t2-t1"
    IF !dt! GTR 3 (
        SET /A "t1=t2", "frame=(frame + 1) %% 0x7FFFFFFF", "anim=frame %% 2"
        FOR /F "tokens=1-3" %%1 in ("!kaho.spike! !kaho.sprite! !kaho.cur!") DO (
            ECHO %ESC%[21;60H%ESC%[1J!level.%%1!%ESC%[!kaho.y!;!kaho.x!H!%%2.%%3!
            IF "!anim!" == "0" (
                SET /A "kaho.cur=(kaho.cur + 1) %% %%2.max"
            )
        )
    )
)

GOTO :EOF

:RENDER_PROPS
SETLOCAL DISABLEDELAYEDEXPANSION

CALL :GEN_SPRITES "Sprites\CatIdle" cat
CALL :GEN_IMAGE "Sprites\Tiles\statue.sixel" statue

SETLOCAL ENABLEDELAYEDEXPANSION

:: 0J sequence at end because of strange bug where text shows instead of interpreted as sixel
SET "cat.cur=0"
ECHO %ESC%[24;3H═══─══─╤╨╤══╤╧═════════════╧╧╧╧═════════════╧╤══╤╨╤─══─═══%ESC%[22;1H!statue!%ESC%[22;60H!statue!
FOR /L %%$ in () DO (
    SET /A "frame+=1", "anim=frame %% 50"
    FOR %%F in (!cat.cur!) DO (
        ECHO %ESC%[24;5H═══%ESC%[23;5H!cat.%%F!%ESC%[27;1H%ESC%[0J
        IF "!anim!" == "0" (
            SET /A "cat.cur=(cat.cur + 1) %% cat.max"
        )
    )
)
GOTO :EOF

:END
%$music:type name=Effect FinalPrayer%
SET /A "kaho.cur=kaho.spin.max - 1"
IF "%area%" == "7" (
    SET "text=All Crystals Collected"
    CALL :STRLEN "!text!" len
    SET /A "text.x=kaho.x - (len / 2) + 1", "text.y=kaho.y - 1"
)
FOR /L %%F in (0, 1, %kaho.cur%) DO (
    ECHO %ESC%[21;60H%ESC%[1J!level.%kaho.spike%!%ESC%[%kaho.y%;%kaho.x%H!kaho.spin.%%F!%ESC%[%text.y%;%text.x%H%text%
    FOR /L %%J in (1, 60, 1000000) DO REM
)
COPY NUL "%~dpn0.quit" >NUL
EXIT

:CREATE_LEVEL <platforms [y;x;[type.w.args]]>
SET "bound=#"
SET "did.shrine=1"
FOR %%L in (%*) DO (
    FOR /F "tokens=1-3 delims=;" %%A in ("%%~L") DO (
        SET /A "start=%%B", "adjY=%%A - 2"
        SET "prev=none"
        SET "level.1=!level.1!%ESC%[%%A;%%BH"
        SET "level.-1=!level.-1!%ESC%[%%A;%%BH"
        FOR %%G in (%%C) DO (
            FOR /F "tokens=1-5 delims=." %%1 in ("!prev!.%%~G") DO (
                IF defined %%1.w (
                    SET "level.1=!level.1!%ESC%[%%A;!start!H"
                    SET "level.-1=!level.-1!%ESC%[%%A;!start!H"
                )
                FOR /L %%Q in (1, 1, %%3) DO (
                    IF defined %%2.w (
                        IF "%%Q" == "1" (
                            SET "level.1=!level.1!!%%2!"
                            SET "level.-1=!level.-1!!%%2!"
                        ) else (
                            SET "level.1=!level.1!%ESC%[%%A;!start!H!%%2!"
                            SET "level.-1=!level.-1!%ESC%[%%A;!start!H!%%2!"
                        )
                        SET /A "adjStart=start - 2", "adjEnd=start + %%2.w - 3"
                        FOR /L %%G in (!adjStart!, 1, !adjEnd!) DO (
                            SET "bound=!bound!!adjY!.%%G#"
                            IF "%%2" == "tele" (
                                SET /A "tele#!adjY!.%%G#y=%%4", "tele#!adjY!.%%G#x=%%5"
                            )
                        )
                        SET /A "start+=%%2.w"
                    ) else (
                        SET /A "adj=start - 2"
                        IF "%%2" == "spike" (
                            IF "%%4" == "1" (
                                SET "level.1=!level.1!!%%2.1!"
                                SET "level.-1=!level.-1!!%%2.-1!"
                                SET "spike#!adjY!.!adj!#.1=1"
                            ) else IF "%%4" == "0" (
                                SET "level.1=!level.1!!%%2.0!"
                                SET "level.-1=!level.-1!!%%2.0!"
                                SET "spike#!adjY!.!adj!#.1=1"
                                SET "spike#!adjY!.!adj!#.-1=1"
                            ) else (
                                SET "level.1=!level.1!!%%2.-1!"
                                SET "level.-1=!level.-1!!%%2.1!"
                                SET "spike#!adjY!.!adj!#.-1=1"
                            )
                            SET "spike#!adjY!.!adj!#=1"
                        ) else (
                            IF "%%2" == "win" (
                                SET /A "adjY+=1"
                                SET "win#!adjY!.!adj!#=1"
                                IF "!has.shrine!" == "1" (
                                    SET "level.1=!level.1!%ESC%[48;2;109;93;227m"
                                    SET "level.-1=!level.-1!%ESC%[48;2;109;93;227m"
                                )
                            ) else IF "%%2" == "jump" (
                                SET "jump#!adjY!.!adj!#=1"
                            ) else IF "%%2" == "shrine" (
                                SET /A "adjY+=1", "did.shrine=0"
                                SET "shrine#!adjY!.!adj!#=1"
                                SET "has.shrine=1"
                            )
                            SET "level.1=!level.1!!%%2!"
                            SET "level.-1=!level.-1!!%%2!"
                        )
                        IF not "%%2" == "shrine" (
                            SET "bound=!bound!!adjY!.!adj!#"
                        )
                        SET /A "start+=1"
                    )
                )
                SET "prev=%%2"
            )
        )
    )
)
GOTO :EOF

:: | ASSUMES DISABLE DELAYED EXPANSION |
:GEN_SPRITES <location> <name>
SET /A "%2.max=0", "sprite.num=-1"
FOR %%@ in ("%~1\*.sixel") DO (
    SET /A "sprite.num+=1"
)
FOR /L %%@ in (0, 1, %sprite.num%) DO (
    CALL :READ_SPRITE "%~1\%%@.sixel" %2
    SET /A "%2.max+=1"
)
GOTO :EOF

:: | ASSUMES DISABLE DELAYED EXPANSION |
:GEN_IMAGE <file> <name> <width?>
FOR /F "tokens=* delims=" %%? in (%~1) DO (
    SET "%2=%%?"
    IF not "%3" == "" (
        SET "%2.w=%3"
    )
    GOTO :EOF
)
GOTO :EOF

:: | ASSUMES DISABLE DELAYED EXPANSION |
:READ_SPRITE <file> <name>
CALL SET "index=%%%2.max%%"
FOR /F "tokens=* delims=" %%? in (%~1) DO (
    SET "%2.%index%=%%?"
    GOTO :EOF
)
GOTO :EOF

:PRELUDE
TITLE Momodora : Lunar Glow
CHCP 65001 >NUL
MODE CON rate=31 delay=0
TASKKILL /F /IM CHOICE.exe >NUL 2>NUL
IF exist "%~dpn0.quit" (
    DEL /F /Q "%~dpn0.quit"
)

SET "save=Path ComSpec TEMP SystemRoot SystemDrive save"
FOR /F "tokens=1 delims==" %%A in ('SET') DO (
    IF "%save%" == "!save:%%A=!" (
        SET "%%A="
    )
)

FOR /F %%A in ('ECHO PROMPT $E ^| CMD') DO SET "ESC=%%A"
SET "$music=(PUSHD Music & START /B CSCRIPT //NOLOGO "%~f0?.wsf" //JOB:Music type name.mp3 & POPD)>NUL"
SET "$silence=TASKKILL /F /IM CSCRIPT.exe >NUL 2>NUL"
SET $input=POWERSHELL ^
Add-Type -AssemblyName PresentationCore; ^
While ($true) { ^
    if ([System.IO.File]::Exists('%~dpn0.quit')) { ^
        Exit ^
    } ^
    $keys = ''; ^
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::W)){ ^
        $keys += 'W' ^
    } ^
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::A)){ ^
        $keys += 'A' ^
    } ^
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::D)){ ^
        $keys += 'D' ^
    } ^
    if ($keys -ne '') { ^
        Write-Host $keys ^
    } ^
    Start-Sleep -Milliseconds 50 ^
}
GOTO :EOF

:SELECT_LEVEL <area>
IF "%1" == "1" (
    SET /A "kaho.begin.dir=1", "kaho.begin.x=10", "kaho.begin.y=17"
    CALL :CREATE_LEVEL "19;9;endl.1 dirt.2 castle.1 dirt.5 spike.5.1" ^
                       "19;28;spike.5.-1" ^
                       "19;36;endl.1 dirt.5 endr.1" ^
                       "18;46;spike.3.1 castle.1 dirt.2 endr.1" ^
                       "15;33;endl.1 dirt.2 castle.3 dirt.2 endr.1" ^
                       "15;28;tele.1.10.12" ^
                       "12;10;endl.1 dirt.8 endr.1" ^
                       "10;12;tele.1.15.28" ^
                       "9;19;endl.1 dirt.10 spike.4.1 dirt.10 endr.1" ^
                       "6;45;endl.1 dirt.7 endr.1" ^
                       "5;50;win.1"
) else IF "%1" == "2" (
    SET /A "kaho.begin.dir=1", "kaho.begin.x=22", "kaho.begin.y=15"
    CALL :CREATE_LEVEL "17;20;endl.1 dirt.3 castle.1 dirt.3 endr.1" ^
                       "17;11;spike.5.-1" ^
                       "14;10;endl.1 dirt.3 endr.1" ^
                       "11;14;spike.3.-1 spike.5.1 spike.4.-1" ^
                       "11;30;endl.1 dirt.3 castle.1 dirt.4 endr.1" ^
                       "15;37;tele.1.3.48 dirt.3 endr.1" ^
                       "3;50;tele.1.15.37" ^
                       "5;39;endl.1 dirt.10 endr.1" ^
                       "5;13;dirt.7 spike.5.1 spike.5.-1 spike.5.1" ^
                       "4;14;win.1"
) else IF "%1" == "3" (
    SET /A "kaho.begin.dir=1", "kaho.begin.x=50", "kaho.begin.y=16"
    CALL :CREATE_LEVEL "18;48;endl.1 dirt.5 tele.1.7.14 dirt.3 endr.1" ^
                       "7;15;tele.1.1.1" ^
                       "11;11;spike.5.1 spike.6.0" ^
                       "14;4;endl.1 dirt.2 castle.1 dirt.2 endr.1" ^
                       "17;15;endl.1 dirt.3 spike.5.1 dirt.4 jump.1" ^
                       "13;30;spike.5.-1 dirt.5 spike.3.0 dirt.5 spike.3.0 dirt.3 jump.1 dirt.3 endr.1" ^
                       "8;49;endl.1 dirt.3 endr.1" ^
                       "6;45;spike.6.1" ^
                       "5;47;win.1"
) else IF "%1" == "4" (
    SET /A "kaho.begin.dir=-1", "kaho.begin.x=56", "kaho.begin.y=16"
    CALL :CREATE_LEVEL "18;49;jump.1 spike.4.1 castle.1 dirt.2 endr.1" ^
                       "18;40;jump.1" ^
                       "18;31;jump.1" ^
                       "18;17;endl.1 dirt.4 jump.1" ^
                       "14;53;jump.1 castle.1 dirt.2 endr.1" ^
                       "12;43;endl.1 spike.4.-1 jump.1" ^
                       "9;53;endl.1 dirt.3 endr.1" ^
                       "6;41;tele.1.5.5 endl.1 dirt.8 endr.1" ^
                       "9;30;jump.1 dirt.4 jump.1 dirt.1 endr.1" ^
                       "7;22;spike.2 jump.1" ^
                       "5;5;tele.1.1.1" ^
                       "10;10;dirt.2" ^
                       "9;11;win.1"
) else IF "%1" == "5" (
    SET /A "kaho.begin.dir=-1", "kaho.begin.x=47", "kaho.begin.y=10"
    CALL :CREATE_LEVEL "12;28;endl.1 dirt.5 castle.1 dirt.2 spike.7.1 castle.1 dirt.2 endr.1" ^
                       "14;20;spike.6.0" ^
                       "17;28;spike.3.-1" ^
                       "20;16;endl.1 dirt.7 jump.1" ^
                       "20;33;spike.3.1 tele.1.3.3" ^
                       "18;10;endl.1 dirt.3 endr.1" ^
                       "17;11;shrine.1" ^
                       "3;3;tele.1.1.1" ^
                       "7;6;dirt.5 spike.3.1 dirt.5" ^
                       "6;18;win.1"
) else IF "%1" == "6" (
    SET /A "kaho.begin.dir=1", "kaho.begin.x=30", "kaho.begin.y=13"
    CALL :CREATE_LEVEL "15;28;endl.1 castle.1 dirt.3 endr.1" ^
                       "13;21;endl.1 dirt.2 jump.1 spike.4.-1" ^
                       "10;14;endl.1 dirt.3 endr.1" ^
                       "9;27;spike.3.-1 jump.1 tele.1.5.6 dirt.4 endr.1" ^
                       "5;8;tele.1.9.30" ^
                       "7;4;dirt.5 spike.4.0" ^
                       "6;5;shrine.1" ^
                       "18;40;spike.4.-1 spike.4.1" ^
                       "15;48;endl.1 dirt.2 jump.1 tele.1.3.50 dirt.3 endr.1" ^
                       "3;50;tele.1.15.48" ^
                       "6;44;spike.3.0 dirt.5 spike.3.0" ^
                       "5;47;win.1"
) else IF "%1" == "7" (
    SET /A "kaho.begin.dir=-1", "kaho.begin.x=26", "kaho.begin.y=18"
    CALL :CREATE_LEVEL "20;26;endl.1 dirt.3 tele.1.1.30 dirt.5 endr.1" ^
                       "1;30;tele.1.1.1" ^
                       "6;27;spike.4.0" ^
                       "10;31;spike.7.0" ^
                       "12;25;endl.1 dirt.1 castle.1 dirt.1 endr.1" ^
                       "14;15;jump.1 spike.5.1" ^
                       "12;8;endl.1 dirt.3 endr.1" ^
                       "9;16;spike.5.-1" ^
                       "6;11;endl.1 dirt.3 endr.1" ^
                       "5;12;shrine.1" ^
                       "6;35;spike.4.1" ^
                       "9;40;endl.1 dirt.3 spike.3.1 dirt.3 endr.1" ^
                       "13;47;spike.4.-1" ^
                       "16;40;endl.1 dirt.7 endr.1" ^
                       "15;42;win.1"
)
GOTO :EOF

:: | SOURCE https://www.dostips.com/forum/viewtopic.php?t=2828 |
:STRLEN <string> <len>
(   SETLOCAL ENABLEDELAYEDEXPANSION
    SET "str=A%~1"
    SET "len=0"
    FOR /L %%A in (12, -1, 0) DO (
        SET /A "len|=1<<%%A"
        FOR %%B in (!len!) DO IF "!str:~%%B,1!" == "" SET /A "len&=~1<<%%A"
    )
)
(
    ENDLOCAL
    IF "%~2" NEQ "" SET /A %~2=%len%
)
EXIT /B

----- Begin wsf script --->
<package>
  <job id="Music">
    <script language="JScript">
        var player = new ActiveXObject("WMPlayer.OCX.7");
        player.URL = WScript.arguments(1);
        player.settings.volume = 100;
        player.settings.setMode("loop", WScript.arguments(0) == "Track");
        player.controls.play();
        while (player.playState !== 1) {
            WScript.Sleep(100);
        }
    </script>
  </job>
</package>