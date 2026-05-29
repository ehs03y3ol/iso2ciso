@echo off
setlocal EnableDelayedExpansion

set "witRute=C:\wit-v3.05a-r8638-cygwin64\bin\wit.exe"
set "imgFolder=usbloader_images"

if not exist "%witRute%" (
    echo [ERROR] WIT has not located properly. 
    echo Be sure to edit the script var witRute to your wit installation.
    pause
    exit /b
)

echo Ready to extract Game IDs and download covers from GameTDB!
pause

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
        
        rem Extract the raw ID
        for /f "delims=" %%I in ('""%witRute%" id6 "%%~fF""') do set "rawID=%%I"
        
        rem Force exactly 6 characters to kill the invisible carriage return!
        set "gameID=!rawID:~0,6!"
        echo Found Game ID: [!gameID!]
        
        rem Using the correct /wii/ directory with Anti-Bot bypass (-L -A)
        echo Downloading 2D Cover...
        curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/US/!gameID!.png"
        if not exist "%imgFolder%\2D\!gameID!.png" (
            curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/EN/!gameID!.png"
        )
        
        echo Downloading 3D Cover...
        curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/US/!gameID!.png"
        if not exist "%imgFolder%\3D\!gameID!.png" (
            curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/EN/!gameID!.png"
        )
        
        echo Downloading Disc Artwork...
        curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/US/!gameID!.png"
        if not exist "%imgFolder%\disc\!gameID!.png" (
            curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/EN/!gameID!.png"
        )
        
        echo Downloading Full Cover...
        curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/US/!gameID!.png"
        if not exist "%imgFolder%\full\!gameID!.png" (
            curl -f -L -s -A "Mozilla/5.0" -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/EN/!gameID!.png"
        )
        
        echo [SUCCESS] Finished downloads for !gameID!
    )
    
) else (
    echo.
    echo [INFO] No CISO files found in the "games" folder.
)

echo.
echo ====================================================
echo Script finished! 
pause
