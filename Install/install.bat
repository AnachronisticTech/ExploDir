setlocal enabledelayedexpansion
mkdir "C:\Program Files\ExploDir\"
copy %~dp0ExploDir.exe "C:\Program Files\ExploDir\"
REG IMPORT "%~dp0Explode Directory.reg"
