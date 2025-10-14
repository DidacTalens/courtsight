Feature: Gestión y Marcaje de Partidos de Balonmano

  Como negocio (Entrenador/Club)
  Quiero una aplicación precisa y rápida
  Para mejorar el análisis táctico y la toma de decisiones en tiempo real.

  Background: El usuario ha iniciado sesión y tiene permisos de Anotador.

# --- I. Criterios para la Pantalla de Partido (Marcaje) ---

  Scenario: Marcador y Tiempo Siempre Visibles
    Given El partido está En Curso con marcador 5-4.
    When La aplicación muestra la Pantalla de Partido.
    Then El marcador, el tiempo de juego y los nombres de los equipos son grandes y visibles en el encabezado.

  Scenario: Visualización de Parciales de 5 Minutos
    Given El partido está en el minuto 12:30 y el marcador es 7-6.
    When El usuario mira el encabezado de la pantalla.
    Then Se muestra el marcador parcial del bloque de 5-10 minutos (ej: 5-4) en la barra de parciales.

  Scenario: Uso de Atajos de Teclado para Registro Rápido
    Given El jugador #14 tiene la posesión y el campo está activo.
    When El anotador pulsa la tecla 'G' (para Gol).
    Then Se despliega inmediatamente la selección de jugadores para asignar el Gol.

  Scenario: Edición de una Acción Errónea
    Given El jugador #7 ha sido marcado con una Pérdida en el minuto 10.
    When El usuario selecciona la acción en el Panel de Acciones Recientes.
    Then Se permite editar la acción (ej: cambiar de 'Pérdida' a 'Robo') o eliminarla por completo.

  Scenario: Indicador de Posesión (Flecha de Ataque)
    Given El equipo Local está atacando (la flecha apunta hacia el Visitante).
    When El anotador pulsa el botón de "Cambio de Posesión".
    Then La flecha de ataque sobre la pista cambia de dirección y apunta hacia la portería del Local.

  Scenario: Acceso Rápido a Estadísticas en Tiempo Real
    Given El usuario está en la Pantalla de Partido y quiere analizar el rendimiento.
    When El usuario pulsa el botón de gráfico en el borde derecho.
    Then El panel de estadísticas en tiempo real se desliza desde la derecha, sin cerrar la pantalla de marcaje.

# --- II. Criterios para la Acción de "7 Metros" (Modal Emergente) ---

  Scenario: Asignación Obligatoria de Roles en 7 Metros
    Given El anotador pulsa "Gol" y selecciona la opción de 7 metros.
    When Se abre la pantalla emergente de 7 Metros.
    Then Se debe asignar obligatoriamente al Lanzador y al Portero antes de finalizar la acción.

  Scenario: Registro Correcto de Parada y Fallo
    Given El Lanzador (#10) y el Portero (#1) han sido seleccionados en el modal de 7 metros.
    When El anotador pulsa el botón "Parada".
    Then El modal se cierra y la estadística de Parada se añade al Portero (#1) y el Lanzamiento fallado al Lanzador (#10).

  Scenario: Combinación de Sanción (2 Minutos) y Resultado
    Given Se está registrando un 7 Metros fallado.
    When El anotador pulsa el botón de "Mano en V" y luego "Parada".
    Then Se añade una exclusión de 2 minutos al jugador sancionado y se registra la acción de Parada.

# --- III. Criterios para la Ventana de Preparación de Partido ---

  Scenario: Configuración Visual de Uniformes
    Given El usuario toca el icono de la camiseta de jugador del Equipo Local.
    When El usuario selecciona el color rojo del selector.
    Then El icono de camiseta se pinta dinámicamente de color rojo y el color queda registrado para el Equipo Local.

  Scenario: Habilitación del Botón de Inicio
    Given El usuario ha introducido solo el nombre del equipo local y la duración del partido.
    When El usuario mira el botón "Empezar Partido".
    Then El botón "Empezar Partido" está deshabilitado hasta que se rellenen los jugadores mínimos y el nombre del visitante.

  Scenario: Gestión del Roster
    Given El listado de jugadores tiene 10 entradas.
    When El usuario pulsa el botón de añadir (+) y luego el de eliminar (X) en una fila.
    Then Se añade una nueva fila para introducir un jugador y luego se elimina la fila seleccionada del listado.

# --- IV. Criterios para la Pantalla Principal (Dashboard) ---

  Scenario: Acceso a la Configuración del Equipo Propio
    Given El usuario mira la Pantalla Principal.
    When El usuario pulsa el botón "Configurar Mi Equipo (Local)".
    Then Navega directamente a la vista de edición de Roster y Uniformes del equipo guardado como base.

  Scenario: Descarga de Informe de Estadísticas
    Given El partido "Local vs Visitante" ha Finalizado.
    When El usuario pulsa el icono de descarga de PDF en la tarjeta de ese partido.
    Then Se inicia la generación y descarga del informe de estadísticas detalladas del partido.

  Scenario: Creación de Nuevo Partido
    Given El usuario está revisando el historial de partidos.
    When El usuario pulsa el Botón Flotante (+) en la esquina inferior.
    Then Navega a la Ventana de Preparación de Partido para configurar un nuevo encuentro.