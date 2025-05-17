import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_scaffold.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/hive_service.dart';
import '../widgets/shimmer_task_list.dart';
import '../services/sync_service.dart';

class FirstPage extends ConsumerStatefulWidget {
  const FirstPage({super.key});

  @override
  ConsumerState<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends ConsumerState<FirstPage> with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SyncService.listenToConnectivity(ref);
      if (HiveService.getIsFirstLaunch()) {
        SyncService.checkFirstLaunchAndSync(ref);
      } else {
        SyncService.syncUpdatedTasks(ref);
      }
    });
  }

  void _handleAddTodo(String value) {
    if (value.isNotEmpty) {
      ref.read(todoProvider.notifier).addTodo(value);
      _textController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final todos = ref.watch(todosListProvider);
    final isHiveEmpty = todos.isEmpty;
    final isLoading = ref.watch(syncStateProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GlassmorphicScaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text('Todo List', style: Theme.of(context).textTheme.headlineMedium),
          actions: const [
            ThemeToggleButton(),
            SizedBox(width: 8),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        child: Column(
          children: [
            Padding(
              padding: AppTheme.defaultPadding,
              child: Row(
                children: [
                  Expanded(
                    child: GlassmorphicTextField(
                      controller: _textController,
                      focusNode: _textFieldFocusNode,
                      hintText: 'Add a new task',
                      style: AppTheme.bodyStyle,
                      onSubmitted: _handleAddTodo,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GlassmorphicButton(
                    onPressed: () => _handleAddTodo(_textController.text),
                    child: const Icon(
                      Icons.add,
                      color: AppTheme.white,
                      size: AppTheme.defaultIconSize,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isLoading && !isHiveEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: isLoading && !isHiveEmpty
                  ? const LinearProgressIndicator(
                      minHeight: 2,
                      backgroundColor: Color(0x11000000),
                    )
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: isLoading && isHiveEmpty
                  ? const ShimmerTaskList()
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: AppTheme.defaultPadding,
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return TodoItem(
                            key: ValueKey(todo.id),
                            todoId: todo.id,
                          );
                        },
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
