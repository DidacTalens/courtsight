 Prompt de Contexto y Requisitos para Desarrollo Swift/iOS
Rol y Objetivo: Eres un desarrollador senior de iOS especializado en Swift y SwiftUI. Necesitas comprender el contexto completo de una aplicación de registro de estadísticas de balonmano para generar código y estructuras de datos.

Nombre del Proyecto Tentativo: Pivot | HB Flow (Usaremos HB Flow para el código)

1. ⚙️ Stack Tecnológico
Componente	Especificación
Plataforma	iOS (Mínimo iOS 16)
Lenguaje	Swift (Swift 5.x)
UI Framework	SwiftUI (Para diseño moderno, sencillo y animaciones)
Backend/Base de Datos	Firebase (Firestore)
Requisitos de Rendimiento	La entrada de datos debe ser ultrarrápida y con mínima latencia (prioridad a la respuesta del UI).

Exportar a Hojas de cálculo
2. 🎯 Visión de la Aplicación y Diseño
La aplicación está diseñada para ser utilizada por anotadores y entrenadores durante un partido en vivo, por lo que la simplicidad, el acceso rápido y la legibilidad son esenciales.

Estilo: Diseño moderno y sencillo, siguiendo las directrices de interfaz de iOS (San Francisco Font, minimalismo, alto contraste).

Diseño de Datos: La entrada de datos debe usar modales/vistas emergentes para acciones complejas (7 metros) para no interrumpir el flujo de la pantalla principal.

Velocidad: Los botones de acción deben tener áreas táctiles grandes y mostrar los atajos de teclado asociados.

3. 🧩 Estructura de Pantallas y Componentes Clave
Hemos definido tres vistas principales y componentes modales:

A. Vista de Dashboard (ContentView)
Función: Listar todos los partidos y gestionar la configuración del equipo propio.

Componentes Clave:

Botón/Card prominente para "Configurar Mi Equipo (Local)".

List de Partidos, segmentada por estado ("En Curso", "Finalizado").

Botón Flotante (+) para ir a la Ventana de Preparación.

Botón de Descarga PDF (Button con icono de documento) en cada elemento de partido finalizado.

B. Vista de Preparación de Partido (SetupView)
Función: Configurar equipos, uniformes y jugadores antes de empezar.

Componentes Clave:

Dos columnas simétricas (Local y Visitante) con nombres en grande.

Selectores de color visuales para uniformes de jugador y portero.

Dos Lists editables para introducir el Nombre y Dorsal de cada jugador.

Botón de activación/desactivación "Empezar Partido".

C. Vista Principal de Partido (MatchView)
Función: Centro de marcaje en tiempo real.

Componentes Clave:

Encabezado: Marcador principal, tiempo y una barra discreta de parciales de 5 minutos.

Campo Visual: Ilustración estática del campo con avatares de porteros y una flecha de ataque dinámica.

Panel Lateral (Historial): ScrollView con las últimas acciones registradas. Cada fila debe ser deslizable para Editar/Eliminar.

Botones Inferiores (Atajos): Botones grandes para Gol, Amonestación, Robo/Pérdida y Cambio de Posesión, mostrando el atajo de teclado asociado (G, A, R, C).

Pestaña de Estadísticas: Un panel deslizable (.sheet o GeometryReader para un slide-over) para mostrar estadísticas en tiempo real.

D. Modal de Acción de 7 Metros (SevenMeterModal)
Función: Aparece para registrar el resultado de un penalti.

Componentes Clave:

Vista con el esquema de la portería.

Selectores de Lanzador y Portero mediante toque.

Botón para registrar "2 Minutos" (mano en V).

Botones de resultado: "Gol" o "Parada".

4. 💾 Estructura de Datos (Firebase - Firestore)
El modelo de datos debe reflejar la estructura de Firestore, priorizando la lectura rápida de estadísticas:

Modelo Partido: Contiene id, fecha, equipoLocal, equipoVisitante, y un array de Parcial (para los marcadores de 5 minutos).

Modelo Accion: Una subcolección anidada (partidos/{id}/acciones). Debe incluir timestamp, tipoAccion (String enum), jugadorId, equipoId, y un campo opcional para detalles (esGrave, zonaTiro, etc.).

Modelo EstadisticasTiempoReal: Un documento cacheado que se actualiza mediante Firebase Cloud Functions para lecturas rápidas (golesTotales, amonestaciones, mapaJugadoresEstadisticas).