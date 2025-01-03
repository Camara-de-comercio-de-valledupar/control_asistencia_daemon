abstract class AppConfig {
  static const String version = '1.0.5-gs';
  static const String name = "Aplicativo Funcionarios";
}

mixin AppLocale {
  static const String title = 'title';

  static const Map<String, dynamic> EN = {title: 'Localization'};
  static const Map<String, dynamic> ES = {title: 'Localización'};
  static const Map<String, dynamic> KM = {title: 'ការធ្វើមូលដ្ឋានីយកម្ម'};

  static const Map<String, dynamic> JA = {title: 'ローカリゼーション'};
}
