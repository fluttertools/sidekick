import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paragraph
class Paragraph extends StatelessWidget {
  /// Constructor
  const Paragraph(
    this.text, {
    this.maxLines,
    this.overflow,
    Key? key,
  }) : super(key: key);

  /// Text
  final String text;

  /// Max lines
  final int? maxLines;

  /// Overflow
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            height: 1.3,
            fontSize: 12,
          ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Caption
class Caption extends StatelessWidget {
  /// Constructor
  const Caption(
    this.text, {
    Key? key,
  }) : super(key: key);

  /// Text for caption
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }
}

/// Stdout text
class ConsoleText extends StatelessWidget {
  /// Constructor
  const ConsoleText(
    this.text, {
    Key? key,
    this.maxLines = 1,
    this.color,
  }) : super(key: key);

  /// Content for stdout
  final String text;

  final int maxLines;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: GoogleFonts.ibmPlexMono().copyWith(
        fontSize: 12,
        color: color ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

/// Console text info

/// Heading
class Heading extends StatelessWidget {
  /// Constructor
  const Heading(
    this.text, {
    Key? key,
  }) : super(key: key);

  /// Content
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 18),
    );
  }
}

/// Subheading
class Subheading extends StatelessWidget {
  /// Constructor
  const Subheading(
    this.text, {
    Key? key,
  }) : super(key: key);

  /// content
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
