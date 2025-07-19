import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_event.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_state.dart';
import 'package:shrm_homework_app/features/category/presentation/widgets/category_list_item.dart';
import 'package:shrm_homework_app/features/category/presentation/widgets/search_bar.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>()..add(const LoadCategories()),
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).myArticles), elevation: 0),
        body: const CategoriesView(),
      ),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return Column(
            children: [
              CategorySearchBar(
                value: state.searchQuery,
                onChanged: (query) {
                  context.read<CategoryBloc>().add(
                    SearchCategories(query: query),
                  );
                },
                onClear: () {
                  context.read<CategoryBloc>().add(const ClearSearch());
                },
              ),
              if (state.isSearching)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).foundOf(state.filteredCategories.length, state.allCategories.length),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child:
                    state.filteredCategories.isEmpty
                        ? _buildEmptyState(context, state.isSearching, state.searchQuery)
                        : RefreshIndicator(
                          onRefresh: () async {
                            context.read<CategoryBloc>().add(
                              const LoadCategories(),
                            );
                          },
                          child: ListView.separated(
                            separatorBuilder:
                                (context, index) => Divider(height: 1),
                            itemCount: state.filteredCategories.length,
                            itemBuilder: (context, index) {
                              return CategoryListItem(
                                category: state.filteredCategories[index],
                                searchQuery:
                                    state.isSearching
                                        ? state.searchQuery
                                        : null,
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        } else if (state is CategoryError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<CategoryBloc>().add(const LoadCategories());
            },
          );
        }
        return Center(child: Text(S.of(context).unknownState));
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching, String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.category_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? S.of(context).nothingFoundForQuery(searchQuery)
                : S.of(context).categoriesNotFound,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          if (isSearching) ...[
            const SizedBox(height: 8),
            Text(
              S.of(context).tryChangingSearchQuery,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
