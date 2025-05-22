import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/todo_provider.dart';
import '../widgets/shimmer_task_list.dart';
import '../widgets/animated_todo_list.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/sync_service.dart' show syncStateProvider;

class FirstPage extends ConsumerStatefulWidget {
  const FirstPage({super.key});

  @override
  ConsumerState<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleAddTodo(String value) {
    if (value.isNotEmpty) {
      ref.read(todoProvider.notifier).addTodo(value);
      _textController.clear();
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final todos = ref.watch(todosListProvider);
    final isHiveEmpty = todos.isEmpty;
    final isLoading = ref.watch(syncStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.darkBackground : AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppTheme.darkSurface : AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          isDark
                              ? null
                              : Border.all(color: AppTheme.borderLight),
                    ),
                    child: const ThemeToggleButton(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : AppTheme.surfaceLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 24.0,
                        bottom: 8.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppTheme.darkBackground
                                  : AppTheme.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isDark
                                    ? AppTheme.darkBorder
                                    : AppTheme.borderLight,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                focusNode: _textFieldFocusNode,
                                style: Theme.of(context).textTheme.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: 'Add a new task',
                                  hintStyle: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: (isDark
                                            ? AppTheme.textLight
                                            : AppTheme.textDark)
                                        .withOpacity(0.5),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                onSubmitted: _handleAddTodo,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryPurple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => _handleAddTodo(_textController.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isLoading && !isHiveEmpty)
                      LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor:
                            isDark
                                ? const Color(0x11000000)
                                : const Color(0x11FFFFFF),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child:
                            isLoading && isHiveEmpty
                                ? const ShimmerTaskList()
                                : AnimatedTodoList(
                                  todos: todos,
                                  scrollController: _scrollController,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
