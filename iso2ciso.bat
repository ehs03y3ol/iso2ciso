@echo off
set "witRute=C:\wit-v3.05a-r8638-cygwin64\bin\wit.exe"

if exist "%witRute%" (
    ::Do nothing here
    rem
) else (
    echo [INFO] WIT has not located properly. 
	echo Edit the script line 2 to set witRute.
    echo To exit press enter.
    pause
    exit /b
)
echo Press start if you are ready to transform the files.
echo [WARNING] Files will be deleted onche processed.
pause

:: Check if there are any ISOs to process
if exist "*.iso" (
    :: Check if the destination folder exists
    if exist "out\" (
        for %%F in (*.iso) do (
            echo.
            echo ----------------------------------------------------
            echo Processing: "%%~nxF"
            echo ----------------------------------------------------
            
            :: Run the conversion command with quotes around paths
            "%witRute%" copy "%%~fF" --dest "out\%%~nF.ciso" --ciso
            if errorlevel 1 (
                echo [ERROR] Failed to convert "%%~nxF"
            ) else (
                echo [SUCCESS] Converted to "out\%%~nF.ciso"
                del "%%~nxF"
				)
        )
    ) else (
        echo Folder Out does not exist, making it. The script will rerun.
        mkdir Out
        "%~nx0"
    )
) else (
    echo.
    echo [INFO] No ISO files are found.
    pause
)
