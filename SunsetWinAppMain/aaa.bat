rem Sunset_WinMainApp 
rem 最初に読み込むDLLファイルのディレクトリ位置のテキストデータを作成
rem 引数１　exeが生成されるディレクトリ
rem 引数２　初めに読み込むファイルパスが保存されているテキストデータ

@echo off
setlocal enabledelayedexpansion

set dir_generate_exe=%1

for /F %%a in (%2) do (
set str=%%a
set str=!str:~0,1!
echo %%a の最初の1文字は !str! です。
)
pause
