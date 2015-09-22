// Copyright (c) 2015, Bjarne Hansen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library conspicio_fmt.base;
import 'package:intl/intl.dart';

abstract class Formatable {
  String format(String format);
}

final RegExp _listParameters = new RegExp(r"(?:[^\\]|){(\d+)(?:,(-?\d+))?(?::([^}]+))?}");
final RegExp _mapParameters = new RegExp(r"(?:[^\\]|){([\w]+)(?:,(-?\d+))?(?::([^}]+))?}");


String format(String format, dynamic parameters)
{
  if (parameters is List)
    return _formatList(format, parameters as List);
  else if (parameters is Map)
    return _formatMap(format, parameters as Map);
  else
    throw new FormatException("format(format, paramters) expexted parameters to be of type List or Map.");
}

String _formatMap(String format, [Map parameters]) {
  StringBuffer buf = new StringBuffer();
  int end = 0;


  _mapParameters.allMatches(format).forEach((Match m) {
    String key;
    int width;
    String pfmt;
    var fmt;

    // Collect match information.
    key = m.group(1);
    if (!parameters.containsKey(key))
      throw new FormatException("Invalid parameter key ${m.group(0)} in $format. Not found in parameters map.");
    if (m.group(2) != null) width = int.parse(m.group(2));
    if (m.group(3) != null) pfmt = m.group(3);

    // Determine type of formatter.
    if (parameters[key] is num) {
      if (pfmt == null)
        fmt = new NumberFormat().format;
      else
        fmt = new NumberFormat(pfmt).format;
    }
    else if (parameters[key] is DateTime) {
      if (pfmt == null)
        fmt = new DateFormat().format;
      else
        fmt = new DateFormat(pfmt).format;
    }
    else if (parameters[key] is Formatable)
      fmt = (parameters[key] as Formatable).format(pfmt);
    else
      fmt = (Object o) => o == null ? "" : o.toString();

    // Do actual formatting.
    if (m.start - end > 0 ) buf.write(format.substring(end, m.start + 1));
    if (width != null) {
      buf.write(_align(fmt(parameters[key]), width));
    }
    else
      buf.write(fmt(parameters[key]));
    end = m.end;
  });

  // Add any additional constant part of the
  if (end < format.length) buf.write(format.substring(end));

  return buf.toString();
}

String _formatList(String format, [List parameters])
{
  StringBuffer buf = new StringBuffer();
  int end = 0;

  _listParameters.allMatches(format).forEach( (Match m) {
    int index, width;
    String pfmt;
    var fmt;

    // Collect match information.
    index = int.parse(m.group(1));
    if (index >= parameters.length)
      throw new FormatException("Invalid parameter index ${m.group(0)} in $format. Only ${parameters.length} available.");
    if (m.group(2) != null) width = int.parse(m.group(2));
    if (m.group(3) != null) pfmt = m.group(3);

    // Determine type of formatter.
    if (parameters[index] is num)
    {
      if (pfmt == null)
        fmt = new NumberFormat().format;
      else
        fmt = new NumberFormat(pfmt).format;
    }
    else if (parameters[index] is DateTime)
    {
      if (pfmt == null)
        fmt = new DateFormat().format;
      else
        fmt = new DateFormat(pfmt).format;
    }
    else if (parameters[index] is Formatable)
      fmt = (parameters[index] as Formatable).format(pfmt);
    else
      fmt = (Object o) => o == null ? "" : o.toString();

    // Do actual formatting.
    if (m.start - end > 0) buf.write(format.substring(end, m.start + 1));
    if (width != null)
      buf.write(_align(fmt(parameters[index]), width));
    else
      buf.write(fmt(parameters[index]));
    end = m.end;
  });

  // Add any additional constant part of the
  if (end < format.length) buf.write(format.substring(end));

  return buf.toString();

}

String _align(String s, [int width = 0, String padding = ' '])
{
  if (s == null) return "";
  if (width >= 0) {
    return s.padLeft(width, padding);
  }
  else {
    return s.padRight(width.abs(), padding);
  }
}

