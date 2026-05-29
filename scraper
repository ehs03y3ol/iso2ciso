:: This is 100% made with IA, this is 4:42 AM I have insomnia and I don't want to heat my brain anymore

@echo off
:: This line is mandatory so we can create and read the ID variable inside the loop!
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

:: 1. Create the folder structure for USB Loader GX
if not exist "%imgFolder%\2D" mkdir "%imgFolder%\2D"
if not exist "%imgFolder%\3D" mkdir "%imgFolder%\3D"
if not exist "%imgFolder%\disc" mkdir "%imgFolder%\disc"
if not exist "%imgFolder%\full" mkdir "%imgFolder%\full"

:: 2. Check if the games folder has CISO files
if exist "games\*.ciso" (
    
    for %%F in ("games\*.ciso") do (
        echo.
        echo ----------------------------------------------------
        echo Processing: "%%~nxF"
        echo ----------------------------------------------------
        
        :: 3. Extract the 6-character ID using wit and save to !gameID!
        for /f "delims=" %%I in ('"%witRute%" id6 "%%~fF"') do set "gameID=%%I"
        echo Found Game ID: !gameID!
        
        :: 4. Download 2D Cover (Try US first, if not found, fallback to EN)
        echo Downloading 2D Cover...
        curl -f -s -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/US/!gameID!.png"
        if not exist "%imgFolder%\2D\!gameID!.png" (
            curl -f -s -o "%imgFolder%\2D\!gameID!.png" "https://art.gametdb.com/wii/cover/EN/!gameID!.png"
        )
        
        :: Download 3D Cover
        echo Downloading 3D Cover...
        curl -f -s -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/US/!gameID!.png"
        if not exist "%imgFolder%\3D\!gameID!.png" (
            curl -f -s -o "%imgFolder%\3D\!gameID!.png" "https://art.gametdb.com/wii/cover3D/EN/!gameID!.png"
        )
        
        :: Download Disc Art
        echo Downloading Disc Artwork...
        curl -f -s -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/US/!gameID!.png"
        if not exist "%imgFolder%\disc\!gameID!.png" (
            curl -f -s -o "%imgFolder%\disc\!gameID!.png" "https://art.gametdb.com/wii/disc/EN/!gameID!.png"
        )
        
        :: Download Full Cover Wrap
        echo Downloading Full Cover...
        curl -f -s -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/US/!gameID!.png"
        if not exist "%imgFolder%\full\!gameID!.png" (
            curl -f -s -o "%imgFolder%\full\!gameID!.png" "https://art.gametdb.com/wii/coverfull/EN/!gameID!.png"
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
echo You can now copy the 4 folders inside "%imgFolder%" 
echo directly to your SD card inside "apps\usbloader_gx\images\"
echo ====================================================
pause
