import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ScrollableMarkdown extends MarkdownWidget {
  /// Creates a scrolling widget that parses and displays Markdown.
  const ScrollableMarkdown({
    Key key,
    String data,
    MarkdownStyleSheet styleSheet,
    SyntaxHighlighter syntaxHighlighter,
    MarkdownTapLinkCallback onTapLink,
    Directory imageDirectory,
    this.padding: const EdgeInsets.all(16.0),
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
