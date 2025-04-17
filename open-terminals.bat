@echo off
echo Opening terminals for E-Learning Project...

:: Open Frontend Terminal
start cmd /k "cd SourceCode\e-learning-frontend && echo Frontend Directory && echo Ready to start! && echo. && echo npm run dev"

:: Wait for 1 second
timeout /t 1 /nobreak >nul

:: Open Backend Terminal
start cmd /k "cd SourceCode\e-learning-backend && echo Backend Directory && echo Ready to start! && echo. && echo rails s"

echo Terminals opened successfully!
