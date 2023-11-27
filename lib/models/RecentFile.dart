class RecentFile {
  final String? icon, supplier_name, supplier_code, contact, address;

  RecentFile(
      {this.icon,
      this.supplier_name,
      this.supplier_code,
      this.contact,
      this.address});
}

List demoRecentFiles = [
  RecentFile(
    icon: "assets/icons/xd_file.svg",
    supplier_name: "XD File",
    supplier_code: "01-03-2021",
    contact: "3.5mb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/Figma_file.svg",
    supplier_name: "Figma File",
    supplier_code: "27-02-2021",
    contact: "19.0mb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/doc_file.svg",
    supplier_name: "Document",
    supplier_code: "23-02-2021",
    contact: "32.5mb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/sound_file.svg",
    supplier_name: "Sound File",
    supplier_code: "21-02-2021",
    contact: "3.5mb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/media_file.svg",
    supplier_name: "Media File",
    supplier_code: "23-02-2021",
    contact: "2.5gb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/pdf_file.svg",
    supplier_name: "Sales PDF",
    supplier_code: "25-02-2021",
    contact: "3.5mb",
    address: "hjgsdahj",
  ),
  RecentFile(
    icon: "assets/icons/excel_file.svg",
    supplier_name: "Excel File",
    supplier_code: "25-02-2021",
    contact: "34.5mb",
    address: "hjgsdahj",
  ),
];
