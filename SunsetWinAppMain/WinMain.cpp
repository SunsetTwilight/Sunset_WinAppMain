#include <Windows.h>
#include <iostream>
#include <string>
#include <filesystem>

//------------------------------------------------------------------------------------------------
//�}�N����`
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//�^��`
//------------------------------------------------------------------------------------------------
typedef int(*FUNC)(HINSTANCE, int);

//------------------------------------------------------------------------------------------------
//�O���[�o���ϐ��錾
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//���C���֐�
//------------------------------------------------------------------------------------------------
int WINAPI wWinMain(
    _In_        HINSTANCE   hInstance       ,
    _In_opt_    HINSTANCE   hPrevInstance   ,
    _In_        LPWSTR      lpCmdLine       ,
    _In_        int         nShowCmd
)
{
    //�R���p�C�����e�L�X�g�t�@�C���ǂݍ���
    std::string const text =
        #include "Filepath_StartUp.txt"
    ;

    const size_t first_pos = text.find('\n') + 1;   //�ŏ��̉��s�̈ʒu���擾
    const size_t last_pos = text.rfind('\n');       //�Ō�̉��s�̈ʒu���擾

    //�ŏ��̉��s����Ō�̉��s�܂ł̓����̕�����𒊏o
    std::string startup_text = text.substr(first_pos, (last_pos - first_pos));

    //���o��������������s�ŕ���
    const size_t pos = startup_text.find('\n');
    std::filesystem::path startup_path = startup_text.substr(0, pos);
    std::string startup_func = startup_text.substr((pos + 1), startup_text.size() - (pos + 1));

    startup_path = std::filesystem::absolute(startup_path);

    
    //DLL�t�@�C���ǂݍ���
    HMODULE hModule = LoadLibraryEx(
        startup_path.c_str(), 
        NULL, 
        LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR
    );
    if (hModule == NULL) {
        //DLL�̓ǂݍ��݁F���s
        DWORD word = GetLastError();
        MessageBox(NULL, L"ErrorCode_0002 : Load library StartUp.dll",  L"Failed                                                                                                                         ", MB_OK | MB_ICONERROR);
        MessageBox(NULL, L"Exit Application",                           L"ErrorCode : 0002                                                                                                               ", MB_OK | MB_ICONERROR);
        exit(0002);
    }
    
    //�Ăяo���֐��̖��O��ǂݍ���
    FUNC funcRun = (FUNC)GetProcAddress(hModule, startup_func.c_str());
    if (funcRun == NULL) {
        //�֐��̓ǂݍ��݁F���s
        MessageBox(NULL, L"ErrorCode_0003 : Get Process Run()", L"Failed                                                                                                                         ", MB_OK | MB_ICONERROR);
        MessageBox(NULL, L"Exit Application",                   L"ErrorCode : 0003                                                                                                               ", MB_OK | MB_ICONERROR);
        exit(0003);
    } 

    //�֐��Ăяo��
	return funcRun(hInstance, nShowCmd);
}
