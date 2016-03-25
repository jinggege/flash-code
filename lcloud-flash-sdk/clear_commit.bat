@echo on

echo %cd%

for  /d %%i in (*) do (
        echo %%i  

       rd  /s/q  %cd%\%%i\bin-debug
       rd  /s/q  %cd%\%%i\bin-release
)
	

	


pause