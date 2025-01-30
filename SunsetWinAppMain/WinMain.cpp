#include <Windows.h>
#include <iostream>
#include <string>
#include <filesystem>

//------------------------------------------------------------------------------------------------
//マクロ定義
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//型定義
//------------------------------------------------------------------------------------------------
typedef int(*FUNC)(HINSTANCE, int);

//------------------------------------------------------------------------------------------------
//グローバル変数宣言
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------
//メイン関数
//------------------------------------------------------------------------------------------------
int WINAPI wWinMain(
    _In_        HINSTANCE   hInstance       ,
    _In_opt_    HINSTANCE   hPrevInstance   ,
    _In_        LPWSTR      lpCmdLine       ,
    _In_        int         nShowCmd
)
{
    //コンパイル時テキストファイル読み込み
    std::string const text =
        #include "Filepath_StartUp.txt"
    ;

    const size_t first_pos = text.find('\n') + 1;   //最初の改行の位置を取得
    const size_t last_pos = text.rfind('\n');       //最後の改行の位置を取得

    //最初の改行から最後の改行までの内側の文字列を抽出
    std::string startup_text = text.substr(first_pos, (last_pos - first_pos));

    //抽出した文字列を改行で分割
    const size_t pos = startup_text.find('\n');
    std::filesystem::path startup_path = startup_text.substr(0, pos);
    std::string startup_func = startup_text.substr((pos + 1), startup_text.size() - (pos + 1));

    startup_path = std::filesystem::absolute(startup_path);

    
    //DLLファイル読み込み
    HMODULE hModule = LoadLibraryEx(
        startup_path.c_str(), 
        NULL, 
        LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR
    );
    if (hModule == NULL) {
        //DLLの読み込み：失敗
        DWORD word = GetLastError();
        MessageBox(NULL, L"ErrorCode_0002 : Load library StartUp.dll",  L"Failed                                                                                                                         ", MB_OK | MB_ICONERROR);
        MessageBox(NULL, L"Exit Application",                           L"ErrorCode : 0002                                                                                                               ", MB_OK | MB_ICONERROR);
        exit(0002);
    }
    
    //呼び出す関数の名前を読み込む
    FUNC funcRun = (FUNC)GetProcAddress(hModule, startup_func.c_str());
    if (funcRun == NULL) {
        //関数の読み込み：失敗
        MessageBox(NULL, L"ErrorCode_0003 : Get Process Run()", L"Failed                                                                                                                         ", MB_OK | MB_ICONERROR);
        MessageBox(NULL, L"Exit Application",                   L"ErrorCode : 0003                                                                                                               ", MB_OK | MB_ICONERROR);
        exit(0003);
    } 

    //関数呼び出し
	return funcRun(hInstance, nShowCmd);
}
