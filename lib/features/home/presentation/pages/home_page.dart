import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/design_system/tokens/design_tokens.dart';
import 'package:flutter_template/di/injector.dart';
import 'package:flutter_template/features/home/application/usecases/get_home_data_usecase.dart';
import 'package:flutter_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_template/features/home/presentation/cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        getHomeDataUseCase: getIt<GetHomeDataUseCase>(),
      )..load(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state.status) {
            HomeStatus.initial || HomeStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
            HomeStatus.failure => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.failure?.message ?? '加载失败',
                      style: TextStyle(color: DesignTokens.errorColor),
                    ),
                    const SizedBox(height: DesignTokens.spaceMd),
                    FilledButton(
                      onPressed: () => context.read<HomeCubit>().refresh(),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            HomeStatus.success => RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: ListView(
                  padding: const EdgeInsets.all(DesignTokens.spaceMd),
                  children: [
                    Text(
                      state.data?.greeting ?? '',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: DesignTokens.spaceMd),
                    ...?state.data?.items.map(
                      (item) => Card(
                        margin: const EdgeInsets.only(
                          bottom: DesignTokens.spaceSm,
                        ),
                        child: ListTile(title: Text(item)),
                      ),
                    ),
                    if (state.data?.items.isEmpty ?? true)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(DesignTokens.spaceXl),
                          child: Text(
                            '暂无数据',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
