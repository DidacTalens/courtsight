Feature: Gestión Completa y Marcaje de Partidos de Balonmano (HB Flow)

  Como Analista / Entrenador
  Quiero un registro de partido rápido y sin errores
  Para optimizar las tácticas y analizar el rendimiento del equipo.

  Background: El usuario ha accedido a la aplicación y tiene credenciales de anotador.

# --- I. Criterios para la Pantalla de Inicio (Dashboard) ---

  Scenario: Listado Completo y Navegación
    Given El usuario tiene partidos registrados (Jugados y Por Jugar).
    When La aplicación carga la Pantalla de Inicio.
    Then Se muestra una única lista con todos los partidos, claramente diferenciados por estado.
    And Al hacer clic sobre un partido, el usuario navega a la Ventana de Preparación/Continuación.

  Scenario: Creación Rápida de Partido
    Given El usuario está en la Pantalla de Inicio.
    When El usuario pulsa el Botón Flotante de Añadir (+).
    Then El sistema navega a la Ventana de Preparación de Partido.

  Scenario: Gestión del Equipo Local
    Given El usuario necesita actualizar la plantilla base.
    When El usuario pulsa el Botón de "Editar Equipo Local".
    Then El sistema permite modificar el nombre del equipo y la lista de jugadores con sus dorsales.

  Scenario: Descarga de Informe de Estadísticas
    Given Un partido ha sido marcado como "Completado".
    When El usuario pulsa el Botón de Descargar PDF en la tarjeta de ese partido.
    Then Se inicia la generación y descarga del informe de estadísticas detalladas.

# --- II. Criterios para la Ventana de Preparación de Partido ---

  Scenario: Configuración de Nombres y Colores de Uniforme
    Given El usuario está en la Ventana de Preparación.
    When El usuario edita los nombres de ambos equipos.
    Then El nombre se refleja en grande en la parte superior.
    And El sistema permite seleccionar el color de la camiseta de manga corta (jugadores) y manga larga (porteros) para ambos equipos.

  Scenario: Lista de Jugadores y Dorsales
    Given El usuario está en la sección de lista de jugadores.
    When El usuario introduce el nombre de un jugador y su dorsal.
    Then El dato se registra correctamente en el roster del equipo.

  Scenario: Inicio del Partido
    Given Todos los campos obligatorios (Nombres, Colores, Jugadores Mínimos) han sido completados.
    When El usuario pulsa el Botón de "Enviar a Vista de Partido".
    Then El sistema navega a la Vista de Partido y prepara el estado inicial.

# --- III. Criterios para la Vista de Partido (Estado Inicial y Visualización) ---

  Scenario: Estado Inicial del Marcaje
    Given Se inicia la Vista de Partido por primera vez.
    Then El Marcador es 0-0.
    And El Tiempo es 0:00.
    And La Flecha de Posesión apunta a la derecha por defecto.
    And No hay porteros seleccionados activamente.

  Scenario: Visualización de Elementos Clave
    Given La Vista de Partido está activa.
    Then Se muestran los nombres de los equipos con una barra de color de la camiseta de manga corta debajo de cada nombre.
    And El Marcador, el Tiempo Transcurrido y el Marcador en Parciales de 5' son visibles.

  Scenario: Gestión y Visualización del Portero Activo
    Given El usuario ha asignado los colores de manga larga a los porteros.
    When El usuario hace clic sobre la camiseta de portero en la pista.
    Then Se abre la opción para cambiar el nombre del portero activo.
    And El color y la camiseta de manga larga se muestran en la pista para el portero seleccionado.

# --- IV. Criterios para Modales de Acción (Detalles) ---

  Scenario: Registro Completo de 7 Metros
    Given El usuario pulsa la acción de 7 Metros.
    When El usuario selecciona al Portero y al Lanzador, pulsa el botón de Amonestación (opcional), y selecciona "Gol".
    Then Se registra la acción en el historial.
    And La estadística de Gol y Lanzamiento (y Amonestación) se asigna a los jugadores correctos.

  Scenario: Registro de Amonestación/Sanción
    Given El usuario pulsa la acción de Amonestación.
    When El usuario selecciona al jugador sancionado de la lista y el tipo de sanción (Amarilla, Roja, 2min, Azul).
    Then La sanción se registra en el historial.
    And La estadística de la tarjeta o exclusión se aplica al jugador seleccionado.

  Scenario: Registro de Lanzamiento (General)
    Given El usuario pulsa la acción de Lanzamiento.
    When El usuario selecciona al Jugador que ha lanzado y pulsa "Parada".
    Then La estadística de Parada se asigna al Portero activo.
    And La estadística de Lanzamiento fallado se asigna al Jugador que lanzó.

  Scenario: Registro de Cambio de Posesión (Robo/Pérdida)
    Given El usuario pulsa la acción de Cambio de Posesión.
    When El usuario selecciona el jugador que 'Perdió' la pelota y el jugador que 'Recuperó' (si aplica) y confirma.
    Then La estadística de Pérdida se asigna al jugador correspondiente.
    And La estadística de Robo se asigna al jugador correspondiente.
    And La flecha de ataque cambia de dirección en la Vista de Partido.

  Scenario: Registro de Tiempo Muerto
    Given El tiempo del partido está corriendo.
    When El usuario pulsa la acción de "Tiempo Muerto".
    Then El cronómetro se detiene automáticamente.
    And El tiempo muerto se registra para el equipo que estaba atacando en ese momento.