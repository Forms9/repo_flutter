import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/RecentFile.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recents",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: const Text("Supplier",
                      style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: const Text("supplier_name",
                      style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: const Text("Contact",
                      style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: const Text("Address",
                      style: TextStyle(color: Colors.white)),
                ),
              ],

              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            // SvgPicture.asset(
            //   fileInfo.id ?? '',
            //   height: 30,
            //   width: 30,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                fileInfo.supplierName!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          fileInfo.supplierCode!,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      DataCell(Text(
        fileInfo.contact!,
        style: TextStyle(
          color: Colors.white,
        ),
      )),
      DataCell(Text(
        fileInfo.address!,
        style: TextStyle(
          color: Colors.white,
        ),
      )),
    ],
  );
}
