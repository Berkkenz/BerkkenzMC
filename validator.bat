@echo off
REM GIT VALIDATION
if exist "%TEMP%\gitinstaller.exe" (
	git --version 2>nul
	if errorlevel 1 (
		where git 2>nul
		if errorlevel 1 (
			del /f /q "%TEMP%\gitinstaller.exe"
			exit /b 1
		) else (
			del /f /q "%TEMP%\gitinstaller.exe"
			exit /b 0
		)
	) else (
		del /f /q "%TEMP%\gitinstaller.exe"
		exit /b 0
	)
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