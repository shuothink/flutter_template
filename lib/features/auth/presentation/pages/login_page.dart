import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/design_system/tokens/design_tokens.dart';
import 'package:flutter_template/di/injector.dart';
import 'package:flutter_template/features/auth/application/usecases/login_usecase.dart';
import 'package:flutter_template/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_template/features/auth/presentation/bloc/login_event.dart';
import 'package:flutter_template/features/auth/presentation/bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(loginUseCase: getIt<LoginUseCase>()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            context.go(RouterNames.homePath);
          }
          if (state.status == LoginStatus.failure && state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.failure!.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == LoginStatus.loading;
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spaceLg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 64,
                      color: DesignTokens.primaryColor,
                    ),
                    const SizedBox(height: DesignTokens.spaceXl),
                    Text(
                      '登录',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: DesignTokens.spaceXl),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: '请输入账号',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: DesignTokens.spaceMd),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: '请输入密码',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(context),
                    ),
                    const SizedBox(height: DesignTokens.spaceLg),
                    FilledButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('登录'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<LoginBloc>().add(LoginSubmitted(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }
}
