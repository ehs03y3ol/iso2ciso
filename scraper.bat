@echo off
rem 1. Start with this DISABLED so the loop can safely read "!" in filenames
setlocal DisableDelayedExpansion

set "witRute=C:\wit-v3.05a-r8638-cygwin64\bin\wit.exe"
set "imgFolder=usbloader_images"
set "failLog=failed_downloads.txt"

if exist "%witRute%" (
    rem
) else (
    echo [ERROR] WIT has not located properly. 
    echo Be sure to edit the script var witRute to your wit installation.
    pause
    exit /b
)

echo Ready to extract Game IDs and download covers from GameTDB!
pause

:: Clear any old fail log from a previous run
if exist "%failLog%" del "%failLog%"

:: Create the folder structure
if not exist "%imgFolder%\2D" mkdir "%imgFolder%\2D"
if not exist "%imgFolder%\3D" mkdir "%imgFolder%\3D"
if not exist "%imgFolder%\disc" mkdir "%imgFolder%\disc"
if not exist "%imgFolder%\full" mkdir "%imgFolder%\full"

if exist "games\*.ciso" (
    
    for %%F in ("games\*.ciso") do (
        
        rem 2. Safely capture the path and name BEFORE delayed expansion wakes up
        set "safePath=%%~fF"
        set "safeName=%%~nxF"
        
        rem 3. NOW turn it on so our internal variables work!
        setlocal EnableDelayedExpansion
        
        echo.
        echo ----------------------------------------------------
        echo Processing: "!safeName!"
        echo ----------------------------------------------------
        
        set "rawID="
        set "gameID="
        
        rem Use !safePath! instead of %%~fF to pass it cleanly to WIT
        "%witRute%" id6 "!safePath!" > temp_id.txt 2>nul
        set /p rawID=<temp_id.txt 2>nul
        if exist temp_id.txt del temp_id.txt
        
        if "!rawID!"=="" (
            echo [ERROR] WIT failed to read the ID from "!safeName!". Skipping downloads...
            (echo !safeName!) >> "%failLog%"
        ) else (
            
            set "gameID=!rawID:~0,6!"
            
            if "!gameID!"=="" (
                echo [ERROR] ID extraction corrupted for "!safeName!". Skipping...
                (echo !safeName!) >> "%failLog%"
            ) else (
                echo Found Game ID: [!gameID!]
                
                echo Downloading 2D Cover...
                curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/US/!gameID!.png"
                if not exist "%imgFolder%\2D\!gameID!.png" curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/EN/!gameID!.png"
                
                echo Downloading 3D Cover...
                curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/US/!gameID!.png"
                if not exist "%imgFolder%\3D\!gameID!.png" curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/EN/!gameID!.png"
                
                echo Downloading Disc Artwork...
                curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/US/!gameID!.png"
                if not exist "%imgFolder%\disc\!gameID!.png" curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/EN/!gameID!.png"
                
                echo Downloading Full Cover...
                curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/US/!gameID!.png"
                if not exist "%imgFolder%\full\!gameID!.png" curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/EN/!gameID!.png"
                
                echo [SUCCESS] Finished processing "!safeName!"
            )
        )
        
        timeout /t 1 /nobreak >nul
        
        rem 4. Turn it back off before the loop repeats to read the next game!
        endlocal
    )
    
) else (
    echo.
    echo [INFO] No CISO files found in the "games" folder.
)

echo.
echo ====================================================
echo Script finished! 

if exist "%failLog%" (
    echo.
    echo [WARNING] The following files failed to process or WIT couldn't read them:
    echo ----------------------------------------------------
    type "%failLog%"
    echo ----------------------------------------------------
    del "%failLog%"
) else (
    echo All files processed successfully!
)

echo.
echo You can now copy the 4 folders inside "%imgFolder%" 
echo directly to your SD card inside "apps\usbloader_gx\images\"
echo ====================================================
pause
