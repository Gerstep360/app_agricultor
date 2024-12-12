Configuración del Proyecto Flutter para Windows

Este proyecto requiere algunos pasos previos en la configuración de la plataforma Windows en Flutter. 
Asegúrate de seguir las instrucciones a continuación antes de ejecutar el programa en un entorno Windows.

Pasos de Configuración

1. Limpieza del Proyecto

   Antes de iniciar, limpia cualquier archivo o configuración anterior del proyecto. Esto garantiza que se utilicen 
   archivos de compilación actualizados. Para limpiar el proyecto, ejecuta:

       flutter clean

2. Actualización de Dependencias

   Una vez limpio el proyecto, asegúrate de instalar todas las dependencias necesarias con:

       flutter pub get

3. Habilitar la plataforma Windows en Flutter

   Asegúrate de que la plataforma Windows esté habilitada en Flutter. Para habilitarla, abre una terminal en el 
   directorio raíz del proyecto y ejecuta:

       flutter config --enable-windows-desktop

4. Recrear el Directorio de Compilación de Windows

   Si observas algún error relacionado con archivos de compilación faltantes o corruptos, como "CMakeLists.txt" o 
   la carpeta "runner", sigue estos pasos:

   - Primero, elimina la carpeta "windows" en el directorio raíz del proyecto.
   - Luego, regenera los archivos ejecutando:
		```bash
       flutter create .

   Esto reinstalará los archivos necesarios en "windows/" y configurará de nuevo los archivos de compilación.

5. Verificar que CMake esté instalado y en el PATH

   Asegúrate de que CMake esté instalado en tu sistema y accesible desde la terminal. Puedes verificar esto ejecutando:

       cmake --version

   Si CMake no está instalado o en el PATH, Flutter no podrá compilar la aplicación para Windows.

6. Correr nuevamente el proyecto

   Una vez que hayas seguido los pasos anteriores, intenta compilar el proyecto con:

       flutter run -d windows

Estos pasos deberían restaurar los archivos de configuración para Windows y resolver los errores de compilación.