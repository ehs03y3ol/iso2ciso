@echo off
set witRute=C:\wit-v3.05a-r8638-cygwin64\bin\wit.exe

if exist %witRute% (
    ::/Do nothing here
    rem
    ) else (
    echo WIT has not located properly, be sure to edit the script var witRute to your wit installation.
    echo To exit press enter.
    pause
    exit /b
    )

echo Press start if you are ready to transform the files.
pause

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
  echo "Folder Out not exist, making it, the script will rerun on enter"
  mkdir Out
  "%~nx0"   

) 
