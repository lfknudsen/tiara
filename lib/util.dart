String formatBytes(BigInt i) {
  if (i < BigInt.from(double.maxFinite)) {
    return formatDecimal(i.toDouble());
  }

  String unit = "B";
  if (i > BigInt.from(10000)) {
    i = BigInt.from(i / BigInt.from(1000));
    unit = "KB";
  }
  if (i > BigInt.from(10000)) {
    i = BigInt.from(i / BigInt.from(1000));
    unit = "MB";
  }
  if (i > BigInt.from(10000)) {
    i = BigInt.from(i / BigInt.from(1000));
    unit = "GB";
  }
  if (i > BigInt.from(10000)) {
    i = BigInt.from(i / BigInt.from(1000));
    unit = "TB";
  }
  return "$i $unit";
}

String formatDecimal(double i) {
  String unit = " B";
  if (i > 10000.0) {
    i *= 0.001;
    unit = "KB";
  }
  if (i > 10000.0) {
    i *= 0.001;
    unit = "MB";
  }
  if (i > 10000.0) {
    i *= 0.001;
    unit = "GB";
  }
  if (i > 10000.0) {
    i *= 0.001;
    unit = "TB";
  }

  String truncated = i.toStringAsFixed(2); 
  if (truncated.endsWith('.00')) {
    truncated = truncated.substring(0, truncated.length - 3);
  }
  return "$truncated $unit";
}

String escapeName(String filename) {
  filename = filename.replaceAll('\\', '\\\\');
  filename = filename.replaceAll('"', '\\"');
  filename = filename.replaceAll('\r', '%0D');
  filename = filename.replaceAll('\n', '%0A');
  return filename;
}