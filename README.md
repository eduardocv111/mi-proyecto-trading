Proyecto de Trading Automatizado en MetaTrader 4
Este proyecto contiene un Asesor Experto (Expert Advisor) desarrollado en MQL4 para automatizar estrategias de trading en la plataforma MetaTrader 4. El EA utiliza señales del indicador MACD y TTM Scalper para abrir y gestionar operaciones automáticamente en diferentes instrumentos financieros.

Características principales
Estrategia basada en MACD y TTM Scalper: El EA detecta señales de compra y venta utilizando el cruce de las líneas del MACD y el indicador TTM Scalper.
Gestión del riesgo: Implementa una relación riesgo/beneficio configurable y utiliza un porcentaje de stop loss para proteger las operaciones.
Manejo de múltiples símbolos: El código permite operar en varios pares de divisas y otros activos como criptomonedas y metales.
Trailing Stop: Implementa un trailing stop para proteger las ganancias de las operaciones.
Intervalo entre órdenes: El EA puede establecer un tiempo mínimo entre la apertura de órdenes para evitar operar en exceso en condiciones de mercado volátiles.
Conexión a base de datos MySQL: Las órdenes ejecutadas son almacenadas en una base de datos MySQL para su análisis y seguimiento.
Requisitos
MetaTrader 4
Conocimientos básicos de MQL4
Servidor de base de datos MySQL (como el configurado en InfinityFree)
Git para control de versiones (opcional)
Configuración
Instalar MetaTrader 4 y añadir el archivo LaparachatGPT.mq4 en la carpeta Experts.
Configurar el archivo LaparachatGPT.mq4 con los parámetros deseados para el tamaño de lote, stop loss, trailing stop, entre otros.
Conectar a la base de datos MySQL para almacenar las órdenes generadas por el EA.
Cómo usar
Descarga el proyecto y colócalo en la carpeta de Experts de MetaTrader 4.
Inicia MetaTrader 4 y ejecuta el Asesor Experto en cualquier gráfico.
Configura los parámetros desde el menú del EA.
El EA comenzará a operar automáticamente cuando se detecten señales de entrada.
Contribuciones
Este es un proyecto de código abierto, cualquier mejora o sugerencia es bienvenida. Puedes hacer un fork del repositorio, hacer tus cambios y luego enviar un pull request.

Licencia
Este proyecto se encuentra bajo la licencia MIT. Siente libre de usarlo, modificarlo y distribuirlo según las condiciones de la licencia.
