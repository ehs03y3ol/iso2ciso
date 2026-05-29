@echo off
setlocal EnableDelayedExpansion

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
        echo.
        echo ----------------------------------------------------
        echo Processing: "%%~nxF"
        echo ----------------------------------------------------
        
        rem PURGE variables to prevent leaking from the previous file!
        set "rawID="
        set "gameID="
        
        rem Extract the ID. Added 2^>nul to hide ugly console errors if WIT crashes.
        for /f "delims=" %%I in ('""%witRute%" id6 "%%~fF" 2^>nul"') do set "rawID=%%I"
        
        rem ERROR HANDLING: Did WIT fail to read the file?
        if "!rawID!"=="" (
            echo [ERROR] WIT failed to read the ID from "%%~nxF". Skipping downloads...
            rem Save the failed filename to our log
            echo %%~nxF >> "%failLog%"
        ) else (
            
            rem Force exactly 6 characters
            set "gameID=!rawID:~0,6!"
            
            rem Double check that it initialized correctly after trimming
            if "!gameID!"=="" (
                echo [ERROR] ID extraction corrupted for "%%~nxF". Skipping...
                echo %%~nxF >> "%failLog%"
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
                
                rem Delete the variable before the completion message
                set "gameID="
                
                echo [SUCCESS] Finished processing "%%~nxF"
            )
        )
        
        rem Politeness Delay: Wait 1 second silently before the next game
        timeout /t 1 /nobreak >nul
    )
    
) else (
    echo.
    echo [INFO] No CISO files found in the "games" folder.
)

echo.
echo ====================================================
echo Script finished! 

rem Output the list of failed files at the end
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
