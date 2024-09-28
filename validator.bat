@echo off
echo starting validation script
REM ELEVATION
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please approve the elevation prompt.
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)



REM JAVA 8 VALIDATION
if exist "%TEMP%\java8installer.exe" (
	where java 2>nul
	if errorlevel 1 (
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