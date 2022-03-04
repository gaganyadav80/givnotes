// Copyright (c) 2017-2019, daftspaniel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:math';

const unixNewLine = '\n';
const windowsnewLine = '\r\n';
const carriageReturn = '\r';

///String Processor - that's the theory.
class StringProcessor {
  ///Trim the supplied [String].
  String trimText(String src) {
    return src.trim();
  }

  ///Returns a [String] with each line trimmed.
  String trimLines(String text) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      out += segments[i].trim();
      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Calculate the Word Count for the [String].
  int getWordCount(String text) {
    var workingText = text;
    workingText = workingText
      ..replaceAll(unixNewLine, ' ')
      ..replaceAll('.', ' ')
      ..replaceAll(',', ' ')
      ..replaceAll(':', ' ')
      ..replaceAll(';', ' ')
      ..replaceAll('?', ' ');
    var words = workingText.split(' ');
    words.removeWhere((word) => word.isEmpty || word == " ");
    return min(words.length, text.length);
  }

  ///Count the number of lines in the [String] text.
  int getLineCount(String text) {
    return unixNewLine.allMatches(text).length;
  }

  ///Count the number of sentences in the [String] text.
  int getSentenceCount(String text) {
    var processedText =
        text.replaceAll('!', '.').replaceAll('?', '.').replaceAll('...', '.');
    var sentences = denumber(processedText).split('.');
    var sentenceCount = 0;
    for (int i = 0; i < sentences.length; i++) {
      if (sentences[i].trim().length > 1) sentenceCount++;
    }
    return sentenceCount;
  }

  ///Return [String] of supplied text repeated count times.
  String generateRepeatedString(String textToRepeat, num? count,
      [bool newLine = false]) {
    count ??= 1;

    return newLine
        ? (textToRepeat + unixNewLine) * count.toInt()
        : textToRepeat * count.toInt();
  }

  ///Returns a [String] made from content with all occurances of target
  ///replaced by replacement.
  String getReplaced(String content, String target, String replacement) {
    return content.replaceAll(target, replacement);
  }

  ///Returns a [String] alphabetically sorted.
  ///If multiline then split is by line.
  ///If single line then split is by space character.
  String sort(String text) {
    var delimiter = ' ';
    if (text.contains(unixNewLine)) {
      delimiter = unixNewLine;
    }

    return sortDelimiter(text, delimiter);
  }

  ///Returns a [String] sorted after being split by the supplied delimiter.
  String sortDelimiter(String text, String delimiter) {
    var segments = text.split(delimiter);
    var out = '';
    segments
      ..sort()
      ..forEach((line) => out += line + delimiter);
    return trimText(out);
  }

  ///Returns a [String] of the reverse of the supplied string.
  String reverse(String text) {
    var delimiter = text.contains(unixNewLine) ? unixNewLine : ' ';
    return reverseDelimiter(text, delimiter);
  }

  ///Returns a [String] reversed after being split by the supplied delimiter.
  String reverseDelimiter(String text, String delimiter) {
    var segments = text.split(delimiter);
    var out = '';

    for (var line in segments.reversed) {
      out += line + delimiter;
    }
    return trimText(out);
  }

  ///Returns a [String] with each line having a prefix added.
  String prefixLines(String text, String prefix) {
    var segments = getSegments(text);
    var out = '';
    for (int i = 0; i < segments.length; i++) {
      out += prefix + segments[i];
      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Returns a [String] with each line having a postfix added.
  String postfixLines(String text, String postfix) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      out += segments[i] + postfix;
      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Returns a [String] with each line duplicated.
  String dupeLines(String text) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      out += segments[i] * 2;
      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Returns a [String] with content with spaces instead of tabs.
  String convertTabsToSpace(String text, {int numberOfSpaces = 4}) {
    var spaces = ' ' * numberOfSpaces;
    return text.replaceAll('\t', spaces);
  }

  ///Returns a [String] with all content on a single line.
  String makeOneLine(String text) {
    return text.replaceAll(windowsnewLine, '').replaceAll(unixNewLine, '');
  }

  ///Returns a [String] with blank lines removed.
  String removeBlankLines(String text) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewLine)) {
          out += unixNewLine;
        }
      }
    }

    return out;
  }

  ///Returns a [String] with double blank lines reduced to single blank lines.
  String removeExtraBlankLines(String text) {
    while (text.contains('\n\n\n')) {
      text = text.replaceAll('\n\n\n', '\n\n');
    }

    return text;
  }

  ///Returns a [String] with lines double spaced.
  String doubleSpaceLines(String text) {
    return text.replaceAll(unixNewLine, '\n\n');
  }

  ///Returns a [String] with lines in a random order.
  String randomiseLines(String text) {
    var segments = getSegments(text);
    segments.shuffle();
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) out += segments[i];
      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Returns a [String] of a sequence of numbers each on a new line.
  String generateSequenceString(
      num startIndex, num repeatCount, num increment) {
    var out = '';
    var current = startIndex;
    for (int i = 0; i < repeatCount; i++) {
      out += current.round().toString() + unixNewLine;
      current += increment;
    }
    return out;
  }

  ///Returns a [String] with the input lines containing a [target] string removed.
  deleteLinesContaining(String text, String target) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty &&
          segments[i] != carriageReturn &&
          !segments[i].contains(target)) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewLine)) {
          out += unixNewLine;
        }
      } else if (segments[i].isEmpty || segments[i] != carriageReturn) {
        out += windowsnewLine;
      }
    }

    return out;
  }

  ///URI Encode a string.
  String uriEncode(String text) {
    return Uri.encodeFull(text);
  }

  ///URI Decode a string.
  String uriDecode(String text) {
    return Uri.decodeFull(text);
  }

  ///Return a [String] of the input text with each item (defined by the
  ///delimiter on new line).
  String split(String text, String delimiter) {
    var out = '';
    if (!text.contains(delimiter)) return text;

    text
        .split(delimiter)
        .forEach((String item) => out += "$item$windowsnewLine");

    return out;
  }

  ///Return a [String] of Unescaped HTML.
  // String htmlUnescape(String text) {
  //   return (new HtmlUnescape()).convert(text);
  // }

  ///Return a [String] of HTML converted from the input Markdown.
  // String convertMarkdownToHtml(String content) {
  //   return md.markdownToHtml(content, extensionSet: md.ExtensionSet.commonMark);
  // }

  ///Returns a [String] with the input lines containing a [target] string removed.
  String deleteLinesNotContaining(String text, String target) {
    var segments = getSegments(text);
    var out = '';

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty &&
          segments[i] != carriageReturn &&
          segments[i].contains(target)) {
        out += segments[i];
        if (i < (segments.length - 1) && text.contains(unixNewLine)) {
          out += unixNewLine;
        }
      } else if (segments[i].isEmpty || segments[i] != "\r") {
        out += windowsnewLine;
      }
    }

    return out;
  }

  ///Returns a [String] with the input lines with content numbered.
  String addNumbering(String text) {
    if (text.isEmpty) {
      return '';
    }
    var segments = getSegments(text);
    var out = '';
    var numberingIndex = 1;
    for (var i = 0; i < segments.length; i++) {
      if (segments[i].isNotEmpty) {
        out += '$numberingIndex. ' + segments[i] + unixNewLine;
        numberingIndex++;
      } else if (i + 1 != segments.length) {
        out += segments[i] + unixNewLine;
      }
    }

    return out;
  }

  ///Break [String] into segements by line separator.
  List<String> getSegments(String text) {
    return text.split(unixNewLine);
  }

  ///Returns a [String] with [leftTrim] characters removed for the left
  ///and [rightTrim] for the right.
  String splice(String text, int leftTrim, [int rightTrim = 0]) {
    var out = '';
    var segments = getSegments(text);

    for (int i = 0; i < segments.length; i++) {
      var line = segments[i];
      var currentLength = line.length;
      if (currentLength <= leftTrim || (line.length - rightTrim) < 1) {
        out += unixNewLine;
      } else if (rightTrim > 0) {
        if ((line.length - rightTrim) >= leftTrim) {
          out += line.substring(leftTrim, line.length - rightTrim);
        } else {
          out += unixNewLine;
        }
      } else {
        out += line.substring(leftTrim);
      }
      if (text.contains(unixNewLine)) {
        out += unixNewLine;
      }
    }
    return out;
  }

  ///Returns a [String] with the input multiple spaces all reduced to 1 space.
  String trimAllSpaces(String text) {
    var out = '';
    var segments = getSegments(text);

    for (int i = 0; i < segments.length; i++) {
      var line = '';
      var innerSegments = segments[i].split(' ');
      for (int j = 0; j < innerSegments.length; j++) {
        if (innerSegments[j].trim().isNotEmpty) {
          line += innerSegments[j].trim() + ' ';
        }
      }
      out += line.trim();

      if (i < (segments.length - 1)) {
        out += unixNewLine;
      }
    }

    return out;
  }

  ///Returns a [String] with the input lines sorted by length (ascending).
  String sortByLength(String text) {
    var out = '';
    var segments = getSegments(text);
    segments.sort((a, b) => a.length.compareTo(b.length));
    for (var i = 0; i < segments.length; i++) {
      out += segments[i] + unixNewLine;
    }
    return out;
  }

  ///Returns a [String] with input having 0123456789 removed.
  String denumber(String text) {
    for (var i = 0; i < 10; i++) {
      text = text.replaceAll('$i', '');
    }
    return text;
  }

  ///Returns a [String] with the line that incorporates the index at position
  ///duplicated.
  String duplicateLine(String text, int position) {
    if (position >= text.length) {
      position = text.length - 1;
    }
    if (text.lastIndexOf(unixNewLine) == -1 ||
        text[text.length - 1] != unixNewLine) {
      text = text + unixNewLine;
    }
    var start = max(text.lastIndexOf(unixNewLine, position), 0);
    var end = text.indexOf(unixNewLine, position);

    if (start == end && position > 0) {
      start = max(text.lastIndexOf(unixNewLine, position - 1), 0);
    }

    if (start + 1 < end) {
      var dupe = text.substring(start == 0 ? 0 : start + 1, end);
      text = text.substring(0, start) +
          (start == 0 ? '' : unixNewLine) +
          dupe +
          unixNewLine +
          dupe +
          text.substring(end);
    }
    return text;
  }
}
