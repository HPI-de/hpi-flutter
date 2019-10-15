import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Almost identical to [Markdown], but this widget allows you to set a custom
/// [ScrollableMarkdown.scrollController].
class ScrollableMarkdown extends MarkdownWidget {
  const ScrollableMarkdown({
    Key key,
    String data,
    MarkdownStyleSheet styleSheet,
    SyntaxHighlighter syntaxHighlighter,
    MarkdownTapLinkCallback onTapLink,
    Directory imageDirectory,
    this.padding: const EdgeInsets.all(16),
    this.scrollController,
  }) : super(
          key: key,
          data: data,
          styleSheet: styleSheet,
          syntaxHighlighter: syntaxHighlighter,
          onTapLink: onTapLink,
          imageDirectory: imageDirectory,
        );

  /// The amount of space by which to inset the children.
  final EdgeInsets padding;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, List<Widget> children) {
    return new ListView(
      padding: padding,
      children: children,
      controller: scrollController,
    );
  }
}
