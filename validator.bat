@echo off
echo starting validation script

REM JAVA 8 VALIDATION
if exist "%TEMP%\java8installer.exe" (
	if not exist "%ProgramFiles(x86)%\Java\jre1.8.0_421\bin\java.exe" (
		java --version 2>nul | find "1.8" >null
		if errorlevel 1 (
			del /f /q "%TEMP%\java8installer.exe"
			exit /b 1
		) else (
			del /f /q "%TEMP%\java8installer.exe"
			exit /b 0
		)
	) else (
		del /f /q "%TEMP%\java8installer.exe"
		exit /b 0
	)
)

REM JAVA 17 VALIDATION
if exist "%TEMP%\java17installer.exe" (
	if not exist "%ProgramFiles%\Java\jdk-17\bin\java.exe" (
		java --version 2>nul | find "1.8" >null
		if errorlevel 1 (
			del /f /q "%TEMP%\java17installer.exe"
			exit /b 1
		) else (
			del /f /q "%TEMP%\java17installer.exe"
			exit /b 0
		)
	) else (
		del /f /q "%TEMP%\java17installer.exe"
		exit /b 0
	)
)