@echo off

set "LR=%APPDATA%\BerkkenzMC"
set "LOCAL_VERSION_FILE=%REPOPATH%\version.txt"
set "RR=https://github.com/Berkkenz/BerkkenzMC.git"
set "JAVA8=%ProgramFiles(x86)%\Java\jre1.8.0_421\bin\java.exe"
set "JAVA17=%ProgramFiles%\Java\jdk-17\bin\java.exe"
set "FORGELOG=%TEMP%\forgelog.txt"

echo Main Batch Started...

if not exist "%APPDATA%\.minecraft" (
	cls
	echo Minecraft is not installed. Exiting...
	echo msgbox "Minecraft is not installed. Please install Minecraft and relaunch BerkkenzMC!", vbInformation, "Minecraft Folder Missing" > "%TEMP%\mcpopup.vbs"
	cscript //nologo "%TEMP%\mcpopup.vbs"
	del /s /f "%TEMP%\mcpopup.vbs"
	exit /b 1
)	

cls
echo Checking if Java 8 is installed...
REM THIS IS THE JAVA 8 UPDATE ------------------------------------------------------
where java >nul
if errorlevel 1 (
	cls
	echo Java 8 is not installed, attempting download...
	curl -L -o "%TEMP%\java8installer.exe" "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=250111_d8aa705069af427f9b83e66b34f5e380"
	if errorlevel 1 (
		cls
		echo Java download has failed. Exiting...
		echo msgbox "Java 8 download has unexpectedly failed and has terminated the script.", vbInformation, "Java 8 Download Failed" > "%TEMP%\java8popup.vbs"
		cscript //nologo "%TEMP%\mcpopup.vbs"
		del /s /f "%TEMP%\mcpopup.vbs"
		del /q /f "%TEMP%\java8installer.exe"
		exit /b 1
	)
	cls
	echo Java 8 download successful. Attempting install...
	start "" /wait "%TEMP%\java8installer.exe" /s
	if errorlevel 1 (
		cls
		echo Java install has failed. Exiting...
		pause
		del /q /f "%TEMP%\java8installer.exe"
		exit /b 1
	)
	cls
	echo Java 8 finalizing
	timeout 4 /nobreak >nul
	call "%LR%\validator.bat"
	if errorlevel 1 (
		cls
		echo Java 8 install has failed. Exiting...
		pause
		if exist "%TEMP%\java8installer.exe" (
			del /q /f "%TEMP%\java8installer.exe"
		)
		exit /b 1
	)
	cls
	echo Java 8 install successful! Proceeding...
	timeout 3
) else (
	cls
	echo Java 8 is already installed...
)

if not exist "%JAVA17%" (
	cls
	echo Java 17 executable not found. Attempting download...
	curl -L -o "%TEMP%\java17installer.exe" "https://download.oracle.com/java/17/archive/jdk-17.0.11_windows-x64_bin.exe"
	if errorlevel 1 (
		if not exist "%TEMP%\java17installer.exe" (
			cls
			echo Java 17 download has failed. Exiting...
			pause
			del /f /q "%TEMP%\java17installer.exe"
			exit /b 1
		) else (
			cls
			echo Java 17 download was successful, but an error level was present. Proceeding...
			del /f /q "%TEMP%\java17installer.exe"
			timeout 3
		)
	)
	cls
	echo Java download successfull. Attempting install...
	start "" /wait "%TEMP%\java17installer.exe" /s
	if errorlevel 1 (
		if not exist "%JAVA17%" (
			cls
			echo Java 17 install has failed. Exiting...
			pause
			del /f /q "%TEMP%\java17installer.exe"
			exit /b 1
		) else (
			cls
			echo Java 17 install successful, but an error level was present. Proceeding...
			del /f /q "%TEMP%\java17installer.exe"
			timeout 3
		)
	)
	cls
	echo Java 17 has been successfully installed. Proceeding...
	del /f /q "%TEMP%\java17installer.exe"
	timeout 3
) else (
	cls
	echo Java 17 is already installed. Proceeding...
	if exist "%TEMP%\java17installer.exe" (
		del /f /q "%TEMP%\java17installer.exe"
	)
)

cls
:forgecheck
if not exist "%APPDATA%\.minecraft\versions\1.20.1-forge-47.3.10" (
	echo Correct Forge version not installed. Attempting download...
	curl -L -o "%TEMP%\forgeinstaller.jar" "https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.1-47.3.10/forge-1.20.1-47.3.10-installer.jar"
	if not exist "%TEMP%\forgeinstaller.jar" (
		cls
		echo Forge download has failed. Exiting...
		pause
		del /f /q "%TEMP%\forgeinstaller.jar"
		exit /b 1
	)
	cls
	echo Forge has downloaded successfully. Attempting download...
	if not exist "%APPDATA%\.minecraft\versions\1.20.1\1.20.1.jar" (
		cls
		echo Version 1.20.1 not installed, cloning placeholder...
		if exist "%APPDATA%\.minecraft\versions\1.20.1" (
			rmdir /s /q "%APPDATA%\.minecraft\versions\1.20.1"
		)
		xcopy "%LR%\1.20.1" "%APPDATA%\.minecraft\versions\1.20.1" /e /i /h /y
		
	%JAVA8% -jar "%TEMP%\forgeinstaller.jar" --installClient "%APPDATA%\.minecraft"
	if errorlevel 1 (
		if not exist "%APPDATA%\.minecraft\versions\1.20.1-forge-47.3.10\1.20.1-forge-47.3.10.json" (
			cls
			echo Forge install has failed. Exiting...
			del /f /q "%TEMP%\forgeinstaller.jar"
			pause
			exit /b 1
		) else (
			cls
			echo Forge install has succeeded, but an error code is present. Proceeding...
			timeout 3
		)
	)
	cls
	echo Forge has been successfully installed. Proceeding...
	timeout 3
)
echo Forge version already installed

:filecopy
cd /d %LR%
robocopy "%LR%\mods" "%APPDATA%\.minecraft\mods" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting mods folder...
	rmdir /s /q "%APPDATA%\.minecraft\mods"
	xcopy "%LR%\mods" "%APPDATA%\.minecraft\mods" /e /i /h /y
)
echo Mods up-to-date. Proceeding...

robocopy "%LR%\config" "%APPDATA%\.minecraft\config" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting config folder...
	rmdir /s /q "%APPDATA%\.minecraft\config"
	xcopy "%LR%\config" "%APPDATA%\.minecraft\config" /e /i /h /y
)
echo Config up-to-date. Proceeding...

if not exist "%APPDATA%\.minecraft\emotes" (
	echo No emotes folder, creating one now...
	mkdir "%APPDATA%\.minecraft\emotes"
)
robocopy "%LR%\emotes" "%APPDATA%\.minecraft\emotes" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting emotes folder...
	rmdir /s /q "%APPDATA%\.minecraft\emotes"
	xcopy "%LR%\emotes" "%APPDATA%\.minecraft\emotes" /e /i /h /y
)
echo Emotes up-to-date. Proceeding...

robocopy "%LR%\resourcepacks" "%APPDATA%\.minecraft\resourcepacks" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting resourcepacks folder...
	del /q /f "%APPDATA%\.minecraft\resourcepacks"
	xcopy "%LR%\resourcepacks" "%APPDATA%\.minecraft\resourcepacks" /e /i /h /y
)
echo Resourcepacks up-to-date. Proceeding...

robocopy "%LR%\options.txt" "%APPDATA%\.minecraft\options.txt" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting options.txt file...
	del /q /f "%APPDATA%\.minecraft\options.txt"
	copy "%LR%\options.txt" "%APPDATA%\.minecraft\options.txt" /y
)
echo Options file up-to-date. Proceeding...

if not exist "%APPDATA%\.minecraft\shaderpacks" (
	echo No shaderpacks folder. Creating one now...
	mkdir "%APPDATA%\.minecraft\shaderpacks"
)
robocopy "%LR%\shaderpacks" "%APPDATA%\.minecraft\shaderpacks" /l /e /njh /njs /ndl /fp >nul
if %errorlevel% geq 1 (
	echo Files do not match. Overwriting config folder...
	rmdir /s /q "%APPDATA%\.minecraft\shaderpacks"
	xcopy "%LR%\shaderpacks" "%APPDATA%\.minecraft\shaderpacks" /e /i /h /y
)
echo Shaderpacks up-to-date. Proceeding...
echo finalizing...

echo msgbox "The BerkkenzMC Initiator has completed. Enjoy!", vbInformation, "Completed" > "%TEMP%\popup.vbs"
cscript //nologo "%TEMP%\popup.vbs"
del /s /f "%TEMP%\popup.vbs"
exit /b 0