rem Sunset_WinMainApp 
rem �ŏ��ɓǂݍ���DLL�t�@�C���̃f�B���N�g���ʒu�̃e�L�X�g�f�[�^���쐬
rem �����P�@exe�����������f�B���N�g��
rem �����Q�@���߂ɓǂݍ��ރt�@�C���p�X���ۑ�����Ă���e�L�X�g�f�[�^

@echo off
setlocal enabledelayedexpansion

set dir_generate_exe=%1

for /F %%a in (%2) do (
set str=%%a
set str=!str:~0,1!
echo %%a �̍ŏ���1������ !str! �ł��B
)
pause
