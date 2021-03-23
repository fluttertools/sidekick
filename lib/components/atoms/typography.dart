import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Paragraph extends StatelessWidget {
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  const Paragraph(this.text, {this.maxLines, this.overflow, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            height: 1.3,
            fontSize: 12,
          ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class Caption extends StatelessWidget {
  final String text;
  const Caption(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }
}

class TypographyHeadline extends StatelessWidget {
  final String text;
  const TypographyHeadline(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class StdoutText extends StatelessWidget {
  final String text;
  const StdoutText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: GoogleFonts.ibmPlexMono().copyWith(
        fontSize: 12,
        color: Colors.cyan,
      ),
    );
  }
}

class TextStderr extends StatelessWidget {
  final String text;
  const TextStderr(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.ibmPlexMono().copyWith(color: Colors.deepOrange),
    );
  }
}

class Heading extends StatelessWidget {
  final String text;
  const Heading(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
    );
  }
}

class Subheading extends StatelessWidget {
  final String text;
  const Subheading(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }
}
