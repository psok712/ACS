Основная программа содержится в main.asm. 
Макробиблиотека содержится в файле macrolib.asm и подключена к основной программе через .include.
Тестирующая программа на языке C++ содержится в файле testCase.cpp. В ней прописан исполняющий код по проверке корректности работы программы на ассемблере. Желающий запустить ее на своем компьютере должен поменять фактические пути под свои. Поскольку программа связанна с консолью, пришлось прописывать фактический путь, чтобы запустить файлы через rars1_6.jar.
В файлах test_case1, ..., test_case6.txt представлены тесты, покрывающие возможные случаи.