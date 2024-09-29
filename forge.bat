@echo off
setlocal enabledelayedexpansion

set "MC=%APPDATA%\.minecraft"
set "LR=%APPDATA%\BerkkenzMC"

if not exist "%MC%\versions\1.20.1-forge-47.3.10" (
	cls
	echo Forge not installed. Attempting download...
	curl -L -o "%TEMP%\forgeinstaller.jar" "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-installer.jar"
	if errorlevel 1 (
		cls
		echo Forge download has failed. Exiting...
		del /s /f "%TEMP%\forgeinstaller.jar"
		pause
		exit /b 1
	)
	cls
	echo Forge download successful. Attempting install...
	if not exist "%MC%\versions\1.20.1" (
		xcopy "%LR%\1.20.1" "%MC%\versions\1.20.1" /e /i /h /y
	)
	%JAVA8% -jar "%TEMP%\forgeinstaller.jar" --installClient
	if errorlevel 1 (
		cls
		echo Forge install has failed. Exiting...
		del /s /f "%TEMP%\forgeinstaller.jar"
		pause
		exit /b 1
	) else (
		cls
		echo Forge has been installed successfully. Proceeding...
		exit /b 0
	)
) else (
	cls
	echo Correct Forge is already installed. Proceeding...
	exit /b 0
)