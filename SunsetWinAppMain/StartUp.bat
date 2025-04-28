

rem 引数１（ソリューションディレクトリ）
set solution_dir=%1

rem 引数２（実行ファイル出力ディレクトリ）
set out_dir=%2

rem カレントディレクトリ取得
set CUR=%~dp0

rem カレントディレクトリ移動
pushd %solution_dir%

rem echo %CUR% > DspResult.txt
rem echo %dir_path% >> DspResult.txt

echo > DspResult.txt

rem 探索するファイル名と関数名の入ったファイルを読み込み
if exist StartUp.txt (
    set /p startup_data=<StartUp.txt
   
    set /a count=0
    for /f %%i in (StartUp.txt) do (
        echo %%i>DspResult.txt
    )
) else (
    echo StartUpファイルが見つかりませんでした。
    echo 終了します。
    exit
)

set /p start_func_name=<DspResult.txt

set StartUp_filename=%startup_data%
rem set /p StartUp_func=%startup_data[1]%

rem 実行ファイル出力ディレクトリへ移動
pushd %out_dir%

rem ファイル検索と出力（/b:パスのみ表示、/s:サブフォルダも含めて表示）
dir /b /s %StartUp_filename%>DspResult.txt

set /p text=<DspResult.txt

if "%text%"=="" (
    echo DLLファイルが見つかりませんでした。
    echo 終了します。
    exit 1
) else (
    echo DLL_File_Path : %text%
    set /p %StartUp_filename%=%text%
)

rem 引数２の文字列長を取得
rem echo %out_dir%

set str=%out_dir%
set len=0

:LOOP
if not "%str%"=="" (
    set str=%str:~1%
    set /a len=%len% + 1
    goto :LOOP
)
rem ! 引数１の文字列長を取得

rem 出力ファイル移動
move DspResult.txt %CUR%

rem カレントディレクトリ移動
pushd %CUR%

rem @echo ON

set /p input=<DspResult.txt

rem @echo OFF

rem ファイルパスの文字列の切り取り
call set result=%%input:~%len%%%

echo %len% >> DspResult.txt
echo %result% >> DspResult.txt

set brackets_start=R"("
set brackets_end=")"

echo R"(">Filepath_StartUp.txt

echo .\%result%>>Filepath_StartUp.txt
echo %start_func_name%>>Filepath_StartUp.txt

echo ")">>Filepath_StartUp.txt

echo String_Length_Of_Path : %len%
echo Generate_Local_Path   : %result%

rem ターゲットファイルのファイル名（$(TargetFileName)）を
rem ソリューションディレクトリ（$(SolutionDir)）に書き出す