import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final navBarButtonActive = Color.fromARGB(255, 24, 29, 23);
final navBarButtonInactive = Color.fromARGB(255, 86, 106, 79);
final navBarBackgroundColour = Color.fromARGB(255, 159, 212, 156);

/// Change this to change the icons used by the programme.
IconSet iconset = CupertinoIconSet();

abstract class IconSet {
  abstract final IconData app;
  abstract final IconData code;
  abstract final IconData plaintext;
  abstract final IconData textdoc;
  abstract final IconData audio;
  abstract final IconData video;
  abstract final IconData image;
  abstract final IconData pdf;
  abstract final IconData fontfile;
  abstract final IconData zip;
  abstract final IconData other;
}

class MaterialsIconSet implements IconSet {
  @override
  IconData get app => Icons.computer;

  @override
  IconData get audio => Icons.audio_file;

  @override
  IconData get code => Icons.tag;

  @override
  IconData get image => Icons.image;

  @override
  IconData get other => Icons.description;

  @override
  IconData get pdf => Icons.picture_as_pdf;

  @override
  IconData get plaintext => Icons.abc;

  @override
  IconData get textdoc => Icons.abc;

  @override
  IconData get video => Icons.video_file;

  @override
  IconData get zip => Icons.folder_zip;

  @override
  IconData get fontfile => Icons.text_fields;
}

class MaterialsOutlinedIconSet implements IconSet {
  @override
  IconData get app => Icons.computer_outlined;

  @override
  IconData get audio => Icons.audio_file_outlined;

  @override
  IconData get code => Icons.tag_outlined;

  @override
  IconData get image => Icons.image_outlined;

  @override
  IconData get other => Icons.description_outlined;

  @override
  IconData get pdf => Icons.picture_as_pdf_outlined;

  @override
  IconData get plaintext => Icons.abc_outlined;

  @override
  IconData get textdoc => Icons.abc_outlined;

  @override
  IconData get video => Icons.video_file_outlined;

  @override
  IconData get zip => Icons.folder_zip_outlined;

  @override
  IconData get fontfile => Icons.text_fields_outlined;
}

class CupertinoIconSet implements IconSet {
  @override
  IconData get app => CupertinoIcons.gear;

  @override
  IconData get audio => CupertinoIcons.music_note;

  @override
  IconData get code => CupertinoIcons.chevron_left_slash_chevron_right;

  @override
  IconData get image => Icons.image_outlined;

  @override
  IconData get other => CupertinoIcons.doc;

  @override
  IconData get pdf => CupertinoIcons.doc_richtext;

  @override
  IconData get plaintext => CupertinoIcons.doc_text;

  @override
  IconData get textdoc => CupertinoIcons.doc_text;

  @override
  IconData get video => CupertinoIcons.film;

  @override
  IconData get zip => Icons.folder_zip_outlined;

  @override
  IconData get fontfile => Icons.text_fields_outlined;
}