import 'package:flutter/foundation.dart';

bool isSimilarString(String a, String b) {
  a = a.trim().toLowerCase();
  a = a.replaceAll(RegExp(r'[^\w\s]'), ' ');
  List<String> segmentsA =
      a.split(" ").map((e) => e.trim().toLowerCase()).toList();
  if (segmentsA.isEmpty) {
    return false;
  }

  b = b.trim().toLowerCase();
  b = b.replaceAll(RegExp(r'[^\w\s]'), ' ');
  List<String> segmentsB =
      b.split(" ").map((e) => e.trim().toLowerCase()).toList();
  if (segmentsB.isEmpty) {
    return false;
  }

  final intersection = segmentsA.where((e) => segmentsB.contains(e)).toList();
  var umbral = segmentsB.length / 2;
  var inUmbral = (intersection.length >= umbral);
  if (kDebugMode) {
    print(
        "segmentsA: $segmentsA -> segmentsB: $segmentsB -> intersection: $intersection -> inUmbral: $inUmbral; umbral: $umbral");
  }

  return inUmbral;
}
