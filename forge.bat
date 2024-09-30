@echo off
setlocal enabledelayedexpansion

set "JAVA8=%ProgramFiles(x86)%\Java\jre1.8.0_421\bin\java.exe"
set "MC=%APPDATA%\.minecraft"
set "LR=%APPDATA%\BerkkenzMC"

echo Forge not installed. Attempting download...
curl -L -o "%TEMP%\forgeinstaller.jar" "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-installer.jar"
if errorlevel 1 (
	cls
	echo Forge download has failed... Exiting
	del /s /f "%TEMP%\forgeinstaller.jar"
	pause
	exit /b 1
)
cls
echo Forge download successful. Proceeding...
pause
if not exist "%MC%\versions\1.20.1\1.20.1.jar" (
	xcopy "%LR%\1.20.1" "%MC%\versions\1.20.1" /e /i /h /y
)
pause
%JAVA8% -jar "%TEMP%\forgeinstaller.jar" --installClient --installDir %MC% --nogui
if errorlevel 1 (
	cls
	echo Forge install has failed. Exiting...
	del /s /f "%TEMP%\forgeinstaller.jar"
	exit /b 2
)
cls
echo Forge has been installed. Exiting...
del /s /f "%TEMP%\forgeinstaller.jar"
exit /b 0