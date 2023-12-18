// ignore: unnecessary_import
import 'package:objectbox/objectbox.dart';
import 'package:reporting_app/main.dart';
import 'package:intl/intl.dart';
import 'package:reporting_app/objectbox.g.dart';

@Entity()
class User {
  int id;
  String username;
  String password;
  String type;
  String store;

  User({
    this.id = 0,
    required this.username,
    required this.password,
    required this.type,
    required this.store,
  });
}

@Entity()
class ProductData {
  int id;
  int? serverId;
  String? inwardNo;
  String? uniqueNo;
  String? productName;
  String? supplier;
  String? color;
  double? qty;
  double? height;
  double? width;
  double? depth;
  String? size;
  String? headline;
  String? description;
  String? description2;
  String? supSlNp;
  String? material;
  String? finish;
  String? type;
  String? photoLink;
  String? photoLinkMain;
  double? rate;
  String? calculation;
  String? cipher;
  String? createdDate;
  double? add1;
  double? add2;
  double? add1a;
  double? add2a;
  String? billNo;
  double? greturn;
  double? labelQty;
  String? packingNo;
  double? packedQuantity;
  String? cartonNo;
  String? invoiceNo;
  String? transportBy;
  String? distpatchNo;

  ProductData(
      {this.id = 0,
      this.serverId,
      this.inwardNo,
      this.uniqueNo,
      this.productName,
      this.supplier,
      this.color,
      this.qty,
      this.height,
      this.width,
      this.depth,
      this.size,
      this.headline,
      this.description,
      this.description2,
      this.supSlNp,
      this.material,
      this.finish,
      this.type,
      this.photoLink,
      this.photoLinkMain,
      this.rate,
      this.calculation,
      this.cipher,
      this.createdDate,
      this.add1,
      this.add2,
      this.add1a,
      this.add2a,
      this.billNo,
      this.greturn,
      this.labelQty,
      this.packingNo,
      this.packedQuantity,
      this.cartonNo,
      this.invoiceNo,
      this.transportBy,
      this.distpatchNo});
}

@Entity()
class DispatchData {
  int id;
  String dispatchNumber;
  DateTime dispatchCreatedDate;

  DispatchData({
    this.id = 0,
    required this.dispatchNumber,
    required this.dispatchCreatedDate,
  });
}

@Entity()
class SaleNumberData {
  int id;
  String saleNumber;
  DateTime saleCreatedDate;

  SaleNumberData({
    this.id = 0,
    required this.saleNumber,
    required this.saleCreatedDate,
  });
}

final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

@Entity()
class SaleData {
  int id;
  String saleNumber;
  DateTime saleCreatedDate;
  String saleTotal;
  String saleDiscount;
  String saleCard;
  String saleCash;
  String salePoints;
  String saleBalance;
  List<String> data;
  bool isNoExch;

  SaleData({
    this.id = 0,
    required this.saleNumber,
    required this.saleCreatedDate,
    required this.saleTotal,
    required this.saleDiscount,
    required this.saleCard,
    required this.saleCash,
    required this.salePoints,
    required this.saleBalance,
    required this.data,
    required this.isNoExch,
  });

  Map toJson() => {
        'saleNumber': saleNumber,
        'storeName': cUser.store + terminal,
        'salesCreatedDate': formatter.format(saleCreatedDate),
        'saleTotal': saleTotal,
        'saleDiscount': saleDiscount,
        'saleCard': saleCard,
        'saleCash': saleCash,
        'salePoints': salePoints,
        'saleBalance': saleBalance,
        'data': data,
        'isNotExchange': isNoExch,
      };

  String getIndex(int index) {
    switch (index) {
      case 0:
        return saleNumber == "" ? " " : saleNumber;
      case 1:
        return saleTotal == ""
            ? " "
            : double.parse(saleTotal).toStringAsFixed(2);
      case 2:
        return (double.parse(saleTotal) - double.parse(saleDiscount))
            .toStringAsFixed(2);
      case 3:
        {
          if (saleCard != "" && saleCash != "" && salePoints != "") {
            return "CASH, CARD, POINTS";
          }
          if (saleCard != "" && saleCash != "" && salePoints == "") {
            return "CASH, CARD";
          }

          if (saleCard == "" && saleCash != "" && salePoints != "") {
            return "CASH, POINTS";
          }

          if (saleCard != "" && saleCash == "" && salePoints != "") {
            return "CARD, POINTS";
          }
          if (saleCard == "" && saleCash != "" && salePoints == "") {
            return 'CASH';
          }
          if (saleCard != "" && saleCash == "" && salePoints == "") {
            {
              return "CARD";
            }
          }
          if (saleCard == "" && saleCash == "" && salePoints != "") {
            {
              return "POINTS";
            }
          }
        }
    }
    return " ";
  }
}

@Entity()
class DailySaleData {
  int id;
  double saleCard;
  double saleCash;
  double salePoints;
  DateTime saleCreatedDate;

  DailySaleData({
    this.id = 0,
    required this.saleCard,
    required this.saleCash,
    required this.salePoints,
    required this.saleCreatedDate,
  });
}

@Entity()
class POSNumber {
  int id;
  int posNumber;

  POSNumber({
    this.id = 0,
    required this.posNumber,
  });
}

@Entity()
class SaleMode {
  int id;
  bool mode;

  SaleMode({
    this.id = 0,
    required this.mode,
  });
}

class ObjectBox {
  late final Store store;
  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
