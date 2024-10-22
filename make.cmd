@echo off

del out\%1.exe

set include=C:\fasmg\packages\x86\include
C:\fasmg\core\fasmg asm\%1.asm out\%1.exe
IF ERRORLEVEL 1 GOTO koniec


cd out
@echo on
%1.exe
cd ..

:koniec