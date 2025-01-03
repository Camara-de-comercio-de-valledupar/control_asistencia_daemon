// To parse this JSON data, do
//
//     final workPermit = workPermitFromJson(jsonString);

import 'dart:convert';

List<WorkPermit> workPermitFromJson(String str) =>
    List<WorkPermit>.from(json.decode(str).map((x) => WorkPermit.fromJson(x)));

String workPermitToJson(List<WorkPermit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkPermit {
  int id;
  String estado;
  DateTime fechaSalida;
  DateTime fechaEntrada;
  String horaSalida;
  String horaEntrada;
  int tipoPermisosId;
  int empleadosId;
  String otroMotivo;
  String remuneracion;
  String vistoAutoriza;
  String vistoJefe;
  int idJefe;
  String nombreTipo;

  WorkPermit({
    required this.id,
    required this.estado,
    required this.fechaSalida,
    required this.fechaEntrada,
    required this.horaSalida,
    required this.horaEntrada,
    required this.tipoPermisosId,
    required this.empleadosId,
    required this.otroMotivo,
    required this.remuneracion,
    required this.vistoAutoriza,
    required this.vistoJefe,
    required this.idJefe,
    required this.nombreTipo,
  });

  factory WorkPermit.fromJson(Map<String, dynamic> json) => WorkPermit(
        id: json["id"],
        estado: json["estado"],
        fechaSalida: DateTime.parse(json["fechaSalida"]),
        fechaEntrada: DateTime.parse(json["fechaEntrada"]),
        horaSalida: json["horaSalida"],
        horaEntrada: json["horaEntrada"],
        tipoPermisosId: json["TipoPermisos_id"],
        empleadosId: json["Empleados_id"],
        otroMotivo: json["otroMotivo"],
        remuneracion: json["remuneracion"],
        vistoAutoriza: json["vistoAutoriza"],
        vistoJefe: json["vistoJefe"],
        idJefe: json["idJefe"],
        nombreTipo: json["nombreTipo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estado": estado,
        "fechaSalida":
            "${fechaSalida.year.toString().padLeft(4, '0')}-${fechaSalida.month.toString().padLeft(2, '0')}-${fechaSalida.day.toString().padLeft(2, '0')}",
        "fechaEntrada":
            "${fechaEntrada.year.toString().padLeft(4, '0')}-${fechaEntrada.month.toString().padLeft(2, '0')}-${fechaEntrada.day.toString().padLeft(2, '0')}",
        "horaSalida": horaSalida,
        "horaEntrada": horaEntrada,
        "TipoPermisos_id": tipoPermisosId,
        "Empleados_id": empleadosId,
        "otroMotivo": otroMotivo,
        "remuneracion": remuneracion,
        "vistoAutoriza": vistoAutoriza,
        "vistoJefe": vistoJefe,
        "idJefe": idJefe,
        "nombreTipo": nombreTipo,
      };

  String get horaEntradaFormateada {
    // 1800 -> 06:00 PM
    int hora = int.parse(horaEntrada.substring(0, 2));
    final minutos = int.parse(horaEntrada.substring(2, 4));
    final amPm = hora < 12 ? 'AM' : 'PM';
    hora = hora > 12 ? hora - 12 : hora;
    final minutosFormateados = minutos.toString().padLeft(2, '0');
    final horaFormateada = hora.toString().padLeft(2, '0');

    return '$horaFormateada:$minutosFormateados $amPm';
  }

  String get horaSalidaFormateada {
    // 1800 -> 06:00 PM
    int hora = int.parse(horaSalida.substring(0, 2));
    final minutos = int.parse(horaSalida.substring(2, 4));
    final amPm = hora < 12 ? 'AM' : 'PM';
    hora = hora > 12 ? hora - 12 : hora;
    final minutosFormateados = minutos.toString().padLeft(2, '0');
    final horaFormateada = hora.toString().padLeft(2, '0');
    return '$horaFormateada:$minutosFormateados $amPm';
  }
}
