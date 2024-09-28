@echo off
REM ELEVATION
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please approve the elevation prompt.
	 powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
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