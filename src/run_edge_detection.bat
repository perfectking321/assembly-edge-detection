@echo off
echo Running edge detection comparison...

REM Compile assembly version
nasm -f win32 edge_detector.asm -o edge_detector.obj
gcc -m32 edge_detector.obj -o edge_detector.exe

REM Run both versions with timing
echo.
echo Running Assembly version...
set start_time=%time%
edge_detector.exe
set end_time=%time%

REM Calculate assembly execution time
for /F "tokens=1-4 delims=:.," %%a in ("%start_time%") do set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
for /F "tokens=1-4 delims=:.," %%a in ("%end_time%") do set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
set /A elapsed=end-start
echo Assembly edge detection time: %elapsed% centiseconds

echo.
echo Running Python version...
python edge_detector.py

echo.
echo Comparison complete! Check output_edges_asm.jpg and output_edges_python.jpg for results. 