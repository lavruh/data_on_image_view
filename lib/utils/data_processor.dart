import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;

class DataProcessor {
  Map<String, Map<String, String>> getData(File f) {
    Map<String, Map<String, String>> result = {};
    if (p.extension(f.path) == '.csv') {
      final dataString = f.readAsStringSync();
      final data = const CsvToListConverter().convert(dataString);
      for (final row in data) {
        if (row[0] == 'config') {
          final m = {'config': row[1].toString()};
          result.update(row[0].toString(), (value) {
            value.addAll(m);
            return value;
          }, ifAbsent: () => m);
        } else if (row.length == 3) {
          final m = {row[1].toString(): row[2].toString()};
          result.update(row[0].toString(), (value) {
            value.addAll(m);
            return value;
          }, ifAbsent: () => m);
        }
      }
    }
    if (p.extension(f.path) == '.json') {}
    return result;
  }
}
