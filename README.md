# Flutter Template

基于 Clean Architecture + Bloc/Cubit + go_router + GetIt + Dio 的 Flutter 项目模板。

从实际生产项目中抽象而来，提供完整的启动管道、分层架构、网络层、状态管理、依赖注入、主题系统等基础设施，开箱即用。

## 技术栈

| 职责 | 方案 | 包 |
|------|------|----|
| 状态管理 | Bloc / Cubit | `flutter_bloc` |
| 路由 | 声明式路由 | `go_router` |
| 依赖注入 | Service Locator | `get_it` |
| 网络请求 | Dio + 拦截器 | `dio` + `pretty_dio_logger` |
| 本地存储 | Hive KV | `ifl` |
| 值相等 | Equatable | `equatable` |

## 项目结构

```
lib/
├── main.dart                     # 入口：极简，只做 runApp
│
├── app/                          # 应用壳层
│   ├── app.dart                  # MaterialApp.router 配置
│   ├── router/                   # 路由（go_router）
│   │   ├── names.dart            #   路由常量
│   │   └── pages.dart            #   路由注册
│   ├── theme/                    # 主题系统
│   │   ├── app_theme.dart        #   主题构建器（亮/暗）
│   │   ├── themes.dart           #   主题集合
│   │   └── theme_mode_controller #   主题切换控制器
│   └── boot/                     # 启动管道
│       ├── boot_bloc.dart        #   启动编排
│       ├── boot_page.dart        #   启动页 UI
│       ├── boot_init_pipeline.dart  # 管道执行器
│       ├── boot_init_step.dart   #   步骤定义
│       └── steps/                #   具体初始化步骤
│
├── core/                         # 基础设施（与业务无关）
│   ├── config/                   # 环境变量 + 常量
│   ├── foundation/               # Result<T>、Failure 体系、Logger
│   ├── network/                  # Dio 客户端 + 请求执行器
│   └── utils/                    # Storage 等工具
│
├── di/                           # 依赖注入
│   ├── injector.dart             # 入口
│   └── modules/                  # 按模块注册
│
├── design_system/                # 设计系统（与业务无关）
│   ├── tokens/                   # 设计令牌（颜色/字体/间距/圆角）
│   └── components/               # 通用 UI 组件
│
└── features/                     # 业务功能模块
    ├── auth/                     # 示例：登录（Bloc 模式）
    └── home/                     # 示例：首页（Cubit 模式）
```

## 为什么这么设计

### 1. Boot Pipeline（启动管道）

**问题：** `main.dart` 里堆满初始化代码，难以维护，也无法控制失败策略。

**方案：** 所有初始化（DI、存储、网络、鉴权）拆成独立 Step，由 Pipeline 编排执行：
- **组内并行**：同一组的步骤同时执行（如偏好恢复和网络预热可并行）
- **组间串行**：后一组依赖前一组的结果（如鉴权依赖 DI 完成）
- **fatal / degradable**：关键步骤失败则中断启动并显示重试；非关键步骤失败则降级跳过

`main.dart` 只有 3 行有效代码，所有初始化逻辑集中在 `boot/steps/` 下。

### 2. Clean Architecture 四层分离

每个 Feature 遵循统一的分层结构：

```
features/<feature>/
├── domain/           # 领域层：Entity + Repository 接口
├── application/      # 应用层：UseCase（业务编排）
├── data/             # 数据层：DataSource + Model + Repository 实现
└── presentation/     # 表现层：Page + Bloc/Cubit + Widget
```

**依赖方向：** presentation → application → domain ← data

- `domain` 层不依赖任何外部包，定义纯粹的业务概念
- `application` 层只依赖 `domain`，编排业务流程
- `data` 层实现 `domain` 定义的接口，处理 API 和本地存储
- `presentation` 层通过 Bloc/Cubit 调用 UseCase

### 3. Result + Failure 错误处理

**问题：** `try/catch` 散落各处，错误类型不统一。

**方案：** `Result<T>` 密封类 + `Failure` 类型体系：

```dart
final result = await loginUseCase(username: 'admin', password: '123456');
result.when(
  success: (user) => print('登录成功: ${user.username}'),
  failure: (error) => print('登录失败: ${error.message}'),
);
```

所有错误统一为 `Failure` 子类（`NetworkFailure`、`ServerFailure`、`ValidationFailure` 等），UI 层只需做模式匹配。

### 4. GetIt 模块化依赖注入

每个业务领域一个 Module 文件，在 `injector.dart` 中按顺序注册：

```dart
await CoreModule.register(getIt);    // 基础设施优先
await AuthModule.register(getIt);    // 然后是各业务模块
await HomeModule.register(getIt);
```

新增 Feature 时只需：创建 Module → 在 injector 中注册。

### 5. 设计令牌与主题分层

```
design_system/tokens/   →  原子级令牌（颜色值、间距、圆角），与业务无关
app/theme/              →  组装令牌为 ThemeData，与应用相关
```

换肤只需修改 `design_tokens.dart` 中的颜色值，所有 UI 自动更新。

## 快速开始

### 方式一：直接使用

```bash
# 1. 克隆项目
git clone <repo-url> my_app
cd my_app

# 2. 全局替换包名
#    把 flutter_template 替换为你的包名（如 my_app）
#    涉及文件：pubspec.yaml + 所有 lib/ 下的 import

# 3. 安装依赖
flutter pub get

# 4. 运行
flutter run
```

### 方式二：复制核心模块到已有项目

最小可用集合（**必须复制**）：

| 模块 | 路径 | 说明 |
|------|------|------|
| 启动管道 | `lib/app/boot/` | 完整复制 |
| 基础设施 | `lib/core/` | 完整复制 |
| DI 框架 | `lib/di/injector.dart` + `di/modules/core_module.dart` | 核心注入 |
| 路由 | `lib/app/router/` | 完整复制 |
| 主题 | `lib/app/theme/` + `lib/design_system/tokens/` | 完整复制 |
| 应用入口 | `lib/main.dart` + `lib/app/app.dart` | 完整复制 |

可选复制：

| 模块 | 路径 | 说明 |
|------|------|------|
| 设计组件 | `lib/design_system/components/` | 按需取用 |
| Feature 示例 | `lib/features/auth/` 或 `lib/features/home/` | 作为新 Feature 的脚手架参考 |

## 新增一个 Feature

以新增「个人中心」功能为例：

### Step 1：创建目录结构

```
lib/features/profile/
├── domain/
│   ├── entities/
│   │   └── profile_entity.dart
│   └── repositories/
│       └── profile_repository.dart
├── application/
│   └── usecases/
│       └── get_profile_usecase.dart
├── data/
│   ├── datasources/
│   │   └── profile_remote_data_source.dart
│   └── repositories_impl/
│       └── profile_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── profile_cubit.dart
    │   └── profile_state.dart
    └── pages/
        └── profile_page.dart
```

### Step 2：注册依赖

创建 `lib/di/modules/profile_module.dart`：

```dart
class ProfileModule {
  ProfileModule._();

  static Future<void> register(GetIt getIt) async {
    getIt.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(const RequestExecutor()),
    );
    getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
    );
    getIt.registerFactory<GetProfileUseCase>(
      () => GetProfileUseCase(getIt<ProfileRepository>()),
    );
  }
}
```

在 `injector.dart` 中添加：

```dart
await ProfileModule.register(getIt);
```

### Step 3：添加路由

在 `router/names.dart` 中添加常量，在 `router/pages.dart` 中注册 GoRoute。

### Step 4：创建页面

```dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        getProfileUseCase: getIt<GetProfileUseCase>(),
      )..load(),
      child: const _ProfilePageContent(),
    );
  }
}
```

## 自定义清单

模板中所有需要自定义的地方均标注了 `TODO`，可全局搜索 `TODO` 查看：

| 文件 | 自定义内容 |
|------|-----------|
| `core/config/env.dart` | API 地址（dev/staging/prod） |
| `core/network/network_client.dart` | Token 过期业务码 |
| `core/network/request_impl.dart` | API 响应格式（数据字段名） |
| `design_system/tokens/design_tokens.dart` | 品牌主色 |
| `app/app.dart` | 应用名称、Locale 配置 |
| `app/boot/boot_page.dart` | 启动页 Logo |
| `features/auth/data/datasources/` | 登录 API 路径 |
| `features/home/data/datasources/` | 首页 API 路径 |

## 环境切换

通过 `--dart-define` 切换环境：

```bash
# 开发环境
flutter run --dart-define=APP_ENV=dev

# 预发布环境
flutter run --dart-define=APP_ENV=staging

# 生产环境（默认）
flutter run --dart-define=APP_ENV=prod
```

VS Code 配置示例（`.vscode/launch.json`）：

```json
{
  "configurations": [
    {
      "name": "Dev",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_ENV=dev"]
    },
    {
      "name": "Prod",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=APP_ENV=prod"]
    }
  ]
}
```

## 示例 Feature 对照

模板提供两种状态管理模式的完整示例：

| 模式 | Feature | 适用场景 |
|------|---------|---------|
| **Bloc**（Event → State） | `features/auth/` | 有明确用户事件的场景（表单提交、多种操作） |
| **Cubit**（方法调用 → State） | `features/home/` | 简单数据加载场景（加载、刷新） |

## 依赖一览

```yaml
# 核心
flutter_bloc: ^8.1.6    # 状态管理
go_router: ^14.2.7      # 路由
get_it: ^8.0.3          # 依赖注入
equatable: ^2.0.7       # 值相等

# 网络
dio: 5.4.0              # HTTP 客户端
pretty_dio_logger: 1.3.1 # 请求日志

# 存储
ifl: ^0.0.3             # Hive KV 存储

# 工具
intl: 0.20.2            # 国际化/格式化
flutter_svg: ^2.0.10+1  # SVG 支持
package_info_plus: ^8.1.0 # 应用信息
```
