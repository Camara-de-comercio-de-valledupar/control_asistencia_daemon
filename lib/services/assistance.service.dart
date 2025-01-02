import 'package:control_asistencia_daemon/lib.dart';

/// Servicio de Asistencia para manejar las operaciones relacionadas con la asistencia.
///
/// Este servicio utiliza un cliente HTTP para comunicarse con el servidor y realizar
/// operaciones como la creación de registros de asistencia.
class AssistanceService {
  /// Cliente HTTP utilizado para realizar las solicitudes.
  final HttpClient _client;

  /// Instancia única de [AssistanceService].
  static AssistanceService? _instance;

  /// Constructor privado para crear una instancia de [AssistanceService].
  ///
  /// Este constructor recibe un [HttpClient] que se utilizará para las solicitudes HTTP.
  AssistanceService(this._client);

  /// Obtiene la instancia única de [AssistanceService].
  ///
  /// Si la instancia aún no ha sido creada, se crea una nueva utilizando el [HttpClient].
  /// Retorna la instancia única de [AssistanceService].
  static AssistanceService getInstance() {
    _instance ??= AssistanceService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  /// Crea un registro de asistencia para un miembro específico.
  ///
  /// Este método realiza una solicitud POST al servidor para crear un registro de asistencia
  /// para el miembro con el ID proporcionado.
  ///
  /// Parámetros:
  /// - [memberId]: ID del miembro para el cual se creará el registro de asistencia.
  ///
  /// Retorna una cadena que representa la respuesta del servidor.
  Future<String> createAssistance({
    required int memberId,
  }) async {
    final response = await _client.post<String>("/storeEntradaSalida", {
      "Empleados_id": memberId,
    });

    return response;
  }
}
