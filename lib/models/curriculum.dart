// To parse this JSON data, do
//
//     final curriculum = curriculumFromJson(jsonString);

import 'dart:convert';

import 'package:control_asistencia_daemon/lib.dart';

List<Curriculum> curriculumFromJson(String str) =>
    List<Curriculum>.from(json.decode(str).map((x) => Curriculum.fromJson(x)));

String curriculumToJson(List<Curriculum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Curriculum {
  final int id;
  final Nivelacademico nivelacademico;
  final String correo;
  final Telefono telefono;
  final String ext;
  final String foto;
  final int municipioId;
  final int empleadosId;
  final int valorcontrato;
  final dynamic objeto;
  final FondoPensiones fondoPensiones;
  final String nombres;
  final String apellidos;
  final String nombrearea;
  final String email;
  final String nombrecargo;
  final String municipio;
  final String departamento;
  final List<Experiencia> experiencias;
  final List<Formacionacademica> formacionacademica;

  Curriculum({
    required this.id,
    required this.nivelacademico,
    required this.correo,
    required this.telefono,
    required this.ext,
    required this.foto,
    required this.municipioId,
    required this.empleadosId,
    required this.valorcontrato,
    required this.objeto,
    required this.fondoPensiones,
    required this.nombres,
    required this.apellidos,
    required this.nombrearea,
    required this.email,
    required this.nombrecargo,
    required this.municipio,
    required this.departamento,
    required this.experiencias,
    required this.formacionacademica,
  });

  Curriculum copyWith({
    int? id,
    Nivelacademico? nivelacademico,
    String? correo,
    Telefono? telefono,
    String? ext,
    String? foto,
    int? municipioId,
    int? empleadosId,
    int? valorcontrato,
    dynamic objeto,
    FondoPensiones? fondoPensiones,
    String? nombres,
    String? apellidos,
    String? nombrearea,
    String? email,
    String? nombrecargo,
    String? municipio,
    String? departamento,
    List<Experiencia>? experiencias,
    List<Formacionacademica>? formacionacademica,
  }) =>
      Curriculum(
        id: id ?? this.id,
        nivelacademico: nivelacademico ?? this.nivelacademico,
        correo: correo ?? this.correo,
        telefono: telefono ?? this.telefono,
        ext: ext ?? this.ext,
        foto: foto ?? this.foto,
        municipioId: municipioId ?? this.municipioId,
        empleadosId: empleadosId ?? this.empleadosId,
        valorcontrato: valorcontrato ?? this.valorcontrato,
        objeto: objeto ?? this.objeto,
        fondoPensiones: fondoPensiones ?? this.fondoPensiones,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        nombrearea: nombrearea ?? this.nombrearea,
        email: email ?? this.email,
        nombrecargo: nombrecargo ?? this.nombrecargo,
        municipio: municipio ?? this.municipio,
        departamento: departamento ?? this.departamento,
        experiencias: experiencias ?? this.experiencias,
        formacionacademica: formacionacademica ?? this.formacionacademica,
      );

  factory Curriculum.fromJson(Map<String, dynamic> json) => Curriculum(
        id: json["id"],
        nivelacademico: nivelacademicoValues.map[json["nivelacademico"]]!,
        correo: json["correo"],
        telefono: telefonoValues.map[json["telefono"]]!,
        ext: json["ext"],
        foto: json["foto"],
        municipioId: json["municipio_id"],
        empleadosId: json["empleados_id"],
        valorcontrato: json["valorcontrato"],
        objeto: json["objeto"],
        fondoPensiones: fondoPensionesValues.map[json["fondo_pensiones"]]!,
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        nombrearea: json["nombrearea"],
        email: json["email"],
        nombrecargo: json["nombrecargo"],
        municipio: json["municipio"],
        departamento: json["departamento"],
        experiencias: List<Experiencia>.from(
            json["experiencias"].map((x) => Experiencia.fromJson(x))),
        formacionacademica: List<Formacionacademica>.from(
            json["formacionacademica"]
                .map((x) => Formacionacademica.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nivelacademico": nivelacademicoValues.reverse[nivelacademico],
        "correo": correo,
        "telefono": telefonoValues.reverse[telefono],
        "ext": ext,
        "foto": foto,
        "municipio_id": municipioId,
        "empleados_id": empleadosId,
        "valorcontrato": valorcontrato,
        "objeto": objeto,
        "fondo_pensiones": fondoPensionesValues.reverse[fondoPensiones],
        "nombres": nombres,
        "apellidos": apellidos,
        "nombrearea": nombrearea,
        "email": email,
        "nombrecargo": nombrecargo,
        "municipio": municipio,
        "departamento": departamento,
        "experiencias": List<dynamic>.from(experiencias.map((x) => x.toJson())),
        "formacionacademica":
            List<dynamic>.from(formacionacademica.map((x) => x.toJson())),
      };
}

class Experiencia {
  final int id;
  final DateTime fechainicio;
  final DateTime? fechafin;
  final String entidad;
  final String cargo;
  final String? valorHonorarios;
  final String? objeto;
  final ExperienciaEstado estado;
  final int hojasdevidaId;

  Experiencia({
    required this.id,
    required this.fechainicio,
    required this.fechafin,
    required this.entidad,
    required this.cargo,
    required this.valorHonorarios,
    required this.objeto,
    required this.estado,
    required this.hojasdevidaId,
  });

  Experiencia copyWith({
    int? id,
    DateTime? fechainicio,
    DateTime? fechafin,
    String? entidad,
    String? cargo,
    String? valorHonorarios,
    String? objeto,
    ExperienciaEstado? estado,
    int? hojasdevidaId,
  }) =>
      Experiencia(
        id: id ?? this.id,
        fechainicio: fechainicio ?? this.fechainicio,
        fechafin: fechafin ?? this.fechafin,
        entidad: entidad ?? this.entidad,
        cargo: cargo ?? this.cargo,
        valorHonorarios: valorHonorarios ?? this.valorHonorarios,
        objeto: objeto ?? this.objeto,
        estado: estado ?? this.estado,
        hojasdevidaId: hojasdevidaId ?? this.hojasdevidaId,
      );

  factory Experiencia.fromJson(Map<String, dynamic> json) => Experiencia(
        id: json["id"],
        fechainicio: DateTime.parse(json["fechainicio"]),
        fechafin:
            json["fechafin"] == null ? null : DateTime.parse(json["fechafin"]),
        entidad: json["entidad"],
        cargo: json["cargo"],
        valorHonorarios: json["valorHonorarios"],
        objeto: json["objeto"],
        estado: experienciaEstadoValues.map[json["estado"]]!,
        hojasdevidaId: json["hojasdevida_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // 2022-01-01
        "fechainicio": fechainicio.toIso8601String().substring(0, 10),
        // 2022-01-01
        "fechafin": fechafin?.toIso8601String().substring(0, 10),
        "entidad": entidad,
        "cargo": cargo,
        "valorHonorarios": valorHonorarios,
        "objeto": objeto,
        "estado": experienciaEstadoValues.reverse[estado],
        "hojasdevida_id": hojasdevidaId,
      };
}

enum ExperienciaEstado { ACTUALMENTE, TERMINADA }

final experienciaEstadoValues = EnumValues({
  "Actualmente": ExperienciaEstado.ACTUALMENTE,
  "Terminada": ExperienciaEstado.TERMINADA
});

enum FondoPensiones { UNDEFINED }

final fondoPensionesValues =
    EnumValues({"undefined": FondoPensiones.UNDEFINED});

class Formacionacademica {
  final int id;
  final String niveleducativo;
  final String areadeestudio;
  final FormacionacademicaEstado estado;
  final int hojasdevidaId;

  Formacionacademica({
    required this.id,
    required this.niveleducativo,
    required this.areadeestudio,
    required this.estado,
    required this.hojasdevidaId,
  });

  Formacionacademica copyWith({
    int? id,
    String? niveleducativo,
    String? areadeestudio,
    FormacionacademicaEstado? estado,
    int? hojasdevidaId,
  }) =>
      Formacionacademica(
        id: id ?? this.id,
        niveleducativo: niveleducativo ?? this.niveleducativo,
        areadeestudio: areadeestudio ?? this.areadeestudio,
        estado: estado ?? this.estado,
        hojasdevidaId: hojasdevidaId ?? this.hojasdevidaId,
      );

  factory Formacionacademica.fromJson(Map<String, dynamic> json) =>
      Formacionacademica(
        id: json["id"],
        niveleducativo: json["niveleducativo"],
        areadeestudio: json["areadeestudio"],
        estado: formacionacademicaEstadoValues.map[json["estado"]]!,
        hojasdevidaId: json["hojasdevida_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "niveleducativo": niveleducativo,
        "areadeestudio": areadeestudio,
        "estado": formacionacademicaEstadoValues.reverse[estado],
        "hojasdevida_id": hojasdevidaId,
      };
}

enum FormacionacademicaEstado { ACTIVO, CULMINADO, CURSANDO, EMPTY }

final formacionacademicaEstadoValues = EnumValues({
  "Activo": FormacionacademicaEstado.ACTIVO,
  "Culminado": FormacionacademicaEstado.CULMINADO,
  "Cursando": FormacionacademicaEstado.CURSANDO,
  "": FormacionacademicaEstado.EMPTY
});

enum Nivelacademico {
  BACHILLER,
  DOCTORADO,
  ESPECIALISTA,
  MAGSTER,
  PROFESIONAL,
  TCNICO,
  TECNOLGO
}

final nivelacademicoValues = EnumValues({
  "Bachiller": Nivelacademico.BACHILLER,
  "Doctorado": Nivelacademico.DOCTORADO,
  "Especialista": Nivelacademico.ESPECIALISTA,
  "Magíster": Nivelacademico.MAGSTER,
  "Profesional": Nivelacademico.PROFESIONAL,
  "Técnico": Nivelacademico.TCNICO,
  "Tecnológo": Nivelacademico.TECNOLGO
});

enum Telefono {
  THE_5581024,
  THE_5781103,
  THE_5781183,
  THE_5819928,
  THE_5819962,
  THE_5845413,
  THE_5867868,
  THE_5897868,
  THE_5897869,
  THE_5898976
}

final telefonoValues = EnumValues({
  "(5)-58-1024": Telefono.THE_5581024,
  "(5)-78-1103": Telefono.THE_5781103,
  "(5)-78-1183": Telefono.THE_5781183,
  "(5)-81-9928": Telefono.THE_5819928,
  "(5)-81-9962": Telefono.THE_5819962,
  "(5)-84-5413": Telefono.THE_5845413,
  "(5)-86-7868": Telefono.THE_5867868,
  "(5)-89-7868": Telefono.THE_5897868,
  "(5)-89-7869": Telefono.THE_5897869,
  "(5)-89-8976": Telefono.THE_5898976
});
