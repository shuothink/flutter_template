enum AppEnvType { dev, staging, prod }

class AppEnv {
  AppEnv._();

  static const String _envValue = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'prod',
  );

  static AppEnvType get current {
    switch (_envValue.toLowerCase()) {
      case 'dev':
        return AppEnvType.dev;
      case 'staging':
        return AppEnvType.staging;
      case 'prod':
      default:
        return AppEnvType.prod;
    }
  }

  // TODO: 替换为你的 API 地址
  static String get baseUrl {
    switch (current) {
      case AppEnvType.dev:
        return 'https://dev-api.example.com/';
      case AppEnvType.staging:
        return 'https://staging-api.example.com/';
      case AppEnvType.prod:
        return 'https://api.example.com/';
    }
  }
}
