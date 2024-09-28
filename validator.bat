@echo off
REM ELEVATION
net session >nul 2>&1
if errorlevel 1 (
    echo This script requires administrator privileges.
    pause
    exit /b 1
)

REM JAVA 8 VALIDATION
if exist "%TEMP%\java8installer.exe" (
	java -version 2>nul
	if errorlevel 1 (
		where java 2>nul
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