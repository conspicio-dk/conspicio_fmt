// Copyright (c) 2015, Bjarne Hansen. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library conspicio_fmt.example;

import 'package:conspicio_fmt/fmt.dart';
import 'package:intl/intl.dart';

main() {
  RegExp _mapParameters = new RegExp(r"(?:[^\\]|){([\w]+)(?:,(-?\d+))?(?::([^}]+))?}");
  var logfmt = r"{t:yyyy-MM-dd HH:mm:ss.SSS} [{l,-6}] {n,-10}: {m} {x}";
  _mapParameters.allMatches(logfmt).forEach( (Match m) => printMatch(m));


  print(format(logfmt, {"t": new DateTime.now(), "n": "logsvc", "l" : "WARN", "m": "Test", "x": null}));

  //testFormat();
  //testRegExp();
}



void testFormat()
{

  print(new NumberFormat("###,###,###,##0.00 \u00A4","da_DK").format(123.34));

  String s3 = r"This is a string with date={0,-12:yyyy-MM-ddTHH:mm:ss}, string={1,-12}, int={2:0000000}, double={3:#,###,###,##0.00} formatting marker.";
  print("\nFormat:");
  print(format(s3, [new DateTime.now(), "test", 12, 167.27, (s3) => s3.toLowerCase() ]));
}


void testRegExp()
{

  RegExp r1 = new RegExp(r"[^\\][{]");
  String s0 = r"This is a string with \ used to escape other chars such as \{ but not {.";
  print("\nMatch s0:");
  r1.allMatches(s0).forEach( (Match m) { printMatch(m);});


  RegExp rexp = new RegExp(r"[^\\]{(\d+)(,(-?\d+))?(:([^}]+))?}");

  String s1 = r"This is a string with {0} formatting marker.";
  String s2 = r"This is a string with {0,-12} formatting marker.";
  String s3 = r"This is a string with date={0,-12:yyyy-MM-ddTHH:mm:ss}, string={1,-12}, int={2:0000000}, double={3:#,###,###,##0.00} formatting marker.";

  print("\nMatch s1:");
  rexp.allMatches(s1).forEach( (Match m) { printMatch(m);});
  print("\nMatch s2:");
  rexp.allMatches(s2).forEach( (Match m) { printMatch(m);});
  print("\nMatch s3:");
  rexp.allMatches(s3).forEach( (Match m) { printMatch(m);});

}

void printMatch(Match m) {

  print("[${m.start},${m.end}]: groups=(${m.groupCount})");
  for (int i = 0; i <= m.groupCount; i++)
    print("  $i: ${m.group(i)}");
}