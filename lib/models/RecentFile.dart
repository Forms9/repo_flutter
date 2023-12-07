class RecentFile {
  final String? id, supplierName, supplierCode, contact, address;

  RecentFile(
      {this.id,
      this.supplierName,
      this.supplierCode,
      this.contact,
      this.address});
}

List demoRecentFiles = [
  RecentFile(
    id: "443",
    supplierName: "RAKESH TEXTILES",
    supplierCode: "A-201",
    contact: "9839241377",
    address: "",
  ),
  RecentFile(
    id: "444",
    supplierName: "SAKARIA SILK & SAREE",
    supplierCode: "A-202",
    contact: "9845010227",
    address: "",
  ),
  RecentFile(
    id: "445",
    supplierName: "MISHRIMAL RANAWAT",
    supplierCode: "B-203",
    contact: "9886377766",
    address: "",
  ),
];
