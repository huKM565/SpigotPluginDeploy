@echo off
chcp 65001 >nul
echo ========================================
echo Сборка EXE файла для SpigotPluginDeploy
echo ========================================
echo.

REM Запрашиваем версию
set /p version=Введите версию (например: 1.0.0): 
if "%version%"=="" (
    echo Версия не указана, используем по умолчанию: 1.0.0
    set version=1.0.0
)

echo.
echo Сборка версии: %version%
echo.

REM Проверяем наличие Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: Python не найден в PATH!
    echo Убедитесь, что Python установлен и добавлен в PATH
    pause
    exit /b 1
)

REM Проверяем наличие pip
pip --version >nul 2>&1
if errorlevel 1 (
    echo ОШИБКА: pip не найден!
    echo Убедитесь, что pip установлен
    pause
    exit /b 1
)

echo Устанавливаем необходимые зависимости...
echo.

REM Устанавливаем PyInstaller если его нет
pip install pyinstaller

REM Устанавливаем зависимости проекта
pip install watchdog psutil

echo.
echo ========================================
echo Зависимости установлены
echo ========================================
echo.

REM Очищаем предыдущие сборки
if exist "build" (
    echo Удаляем папку build...
    rmdir /s /q "build"
)

if exist "dist" (
    echo Удаляем папку dist...
    rmdir /s /q "dist"
)

echo.
echo ========================================
echo Начинаем сборку EXE...
echo ========================================
echo.

REM Собираем exe с помощью PyInstaller
pyinstaller --onefile --windowed --name "SpigotPluginDeploy-%version%" main.py

if errorlevel 1 (
    echo.
    echo ОШИБКА при сборке!
    echo Проверьте логи выше
    pause
    exit /b 1
)

echo.
echo ========================================
echo Сборка завершена успешно!
echo ========================================
echo.
echo EXE файл находится в папке: dist\SpigotPluginDeploy-%version%.exe
echo.

REM Проверяем наличие созданного файла
if exist "dist\SpigotPluginDeploy-%version%.exe" (
    echo Файл создан успешно!
    echo Размер: 
    dir "dist\SpigotPluginDeploy-%version%.exe" | find "SpigotPluginDeploy-%version%.exe"
    echo.
    echo Открыть папку с результатом? (y/n)
    set /p choice=
    if /i "%choice%"=="y" (
        explorer "dist"
    )
) else (
    echo ОШИБКА: EXE файл не найден в папке dist!
)

echo.
echo Нажмите любую клавишу для выхода...
pause >nul 