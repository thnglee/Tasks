import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_scaffold.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';

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
  bool get wantKeepAlive => true;

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
      // Scroll to bottom after adding new todo
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
    // Watch the todos list instead of the raw map
    final todosLength = ref.watch(todosListProvider).length;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GlassmorphicScaffold(
        extendBody: true,
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
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Consumer(
                  builder: (context, ref, _) {
                    final todos = ref.watch(todosListProvider);
                    return ListView.builder(
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
}
