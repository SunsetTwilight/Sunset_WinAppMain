

rem �����P�i�\�����[�V�����f�B���N�g���j
set solution_dir=%1

rem �����Q�i���s�t�@�C���o�̓f�B���N�g���j
set out_dir=%2

rem �J�����g�f�B���N�g���擾
set CUR=%~dp0

rem �J�����g�f�B���N�g���ړ�
pushd %solution_dir%

rem echo %CUR% > DspResult.txt
rem echo %dir_path% >> DspResult.txt

echo > DspResult.txt

rem �T������t�@�C�����Ɗ֐����̓������t�@�C����ǂݍ���
if exist StartUp.txt (
    set /p startup_data=<StartUp.txt
   
    set /a count=0
    for /f %%i in (StartUp.txt) do (
        echo %%i>DspResult.txt
    )
) else (
    echo StartUp�t�@�C����������܂���ł����B
    echo �I�����܂��B
    exit
)

set /p start_func_name=<DspResult.txt

set StartUp_filename=%startup_data%
rem set /p StartUp_func=%startup_data[1]%

rem ���s�t�@�C���o�̓f�B���N�g���ֈړ�
pushd %out_dir%

rem �t�@�C�������Əo�́i/b:�p�X�̂ݕ\���A/s:�T�u�t�H���_���܂߂ĕ\���j
dir /b /s %StartUp_filename%>DspResult.txt

set /p text=<DspResult.txt

if "%text%"=="" (
    echo DLL�t�@�C����������܂���ł����B
    echo �I�����܂��B
    exit 1
) else (
    echo DLL_File_Path : %text%
    set /p %StartUp_filename%=%text%
)

rem �����Q�̕����񒷂��擾
rem echo %out_dir%

set str=%out_dir%
set len=0

:LOOP
if not "%str%"=="" (
    set str=%str:~1%
    set /a len=%len% + 1
    goto :LOOP
)
rem ! �����P�̕����񒷂��擾

rem �o�̓t�@�C���ړ�
move DspResult.txt %CUR%

rem �J�����g�f�B���N�g���ړ�
pushd %CUR%

rem @echo ON

set /p input=<DspResult.txt

rem @echo OFF

rem �t�@�C���p�X�̕�����̐؂���
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

rem �^�[�Q�b�g�t�@�C���̃t�@�C�����i$(TargetFileName)�j��
rem �\�����[�V�����f�B���N�g���i$(SolutionDir)�j�ɏ����o��