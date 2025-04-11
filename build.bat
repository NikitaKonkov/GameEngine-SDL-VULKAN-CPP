@echo off
echo Building Engine project...

REM Parse command line arguments for AVX options
set USE_AVX512=OFF
set CLEAN_BUILD=false

:parse_args
if "%1"=="" goto done_args
if /i "%1"=="--avx512" set USE_AVX512=ON
if /i "%1"=="--avx2" set USE_AVX512=OFF
if /i "%1"=="--clean" set CLEAN_BUILD=true
shift
goto parse_args
:done_args

echo AVX512 is %USE_AVX512%

REM Create build directory if it doesn't exist
if not exist build mkdir build

REM Clean build if requested
if "%CLEAN_BUILD%"=="true" (
    echo Cleaning build directory...
    rmdir /s /q build
    mkdir build
)

REM Navigate to build directory
cd build

REM Configure with CMake
echo Configuring with CMake...
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DUSE_AVX512=%USE_AVX512% -G "Visual Studio 17 2022" -T host=x86 -A x64 ..\Engine

REM Build the project
echo Building project...
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" --build . --config Release

REM Check if build was successful
if %ERRORLEVEL% NEQ 0 (
    echo Build failed with error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

echo Build successful!
cd ..
REM Run the executable
echo Running the application...
build\Release\gameengine.exe

echo Done!


REM build.bat --avx2       # Build with AVX2 (default)
REM build.bat --avx512     # Build with AVX512
REM build.bat --clean      # Clean build with default AVX2
REM build.bat --clean --avx512  # Clean build with AVX512