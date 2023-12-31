import 'package:flutter/material.dart';
import '../constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color, titleColor;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
    this.titleColor,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Search Barcode",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "1.9GB",
    color: primaryColor,
    percentage: 35,
    titleColor: Colors.white,
  ),
  CloudStorageInfo(
    title: "Search Supplier",
    numOfFiles: 1328,
    svgSrc: "assets/icons/google_drive.svg",
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    percentage: 35,
    titleColor: Colors.white,
  ),
  CloudStorageInfo(
    title: "Take Pic",
    numOfFiles: 1328,
    svgSrc: "assets/icons/one_drive.svg",
    totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    percentage: 10,
    titleColor: Colors.white,
  ),
  CloudStorageInfo(
    title: "Update Price",
    numOfFiles: 5328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
    titleColor: Colors.white,
  ),
  CloudStorageInfo(
    title: "Analyis",
    numOfFiles: 5328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
    titleColor: Colors.white,
  ),
];
