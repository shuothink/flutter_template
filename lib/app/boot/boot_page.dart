import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/app/boot/boot_bloc.dart';
import 'package:flutter_template/app/boot/boot_event.dart';
import 'package:flutter_template/app/boot/boot_state.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/design_system/tokens/design_tokens.dart';

class BootPage extends StatelessWidget {
  const BootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BootBloc()..add(const BootStarted()),
      child: const _BootPageContent(),
    );
  }
}

class _BootPageContent extends StatelessWidget {
  const _BootPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BootBloc, BootState>(
      listener: (context, state) {
        if (state.status == BootStatus.success) {
          context.go(state.nextRoute ?? RouterNames.homePath);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: 替换为你的启动 Logo
                Icon(
                  Icons.rocket_launch_rounded,
                  size: 80,
                  color: DesignTokens.primaryColor,
                ),
                const SizedBox(height: 24),
                if (state.status == BootStatus.loading) ...[
                  const SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '正在初始化...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (state.status == BootStatus.failure) ...[
                  Text(
                    state.errorMessage ?? '启动失败',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: DesignTokens.errorColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.read<BootBloc>().add(const BootRetried());
                    },
                    child: const Text('重试'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
