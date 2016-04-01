@echo on
set swf_path = %cd%\child

cd child


pause

for  /d %%i in (*) do (
        echo %%i  
         cd %%i 
        echo %cd%
         copy *.swf  %cd%\swf  
         cd..
         echo %cd%
 
)
	



	


pause