class ReportModel {
  int? id;
  String? title;
  String? address;
  String? summary;
  String? scanVideoPath;
  String? pdfReport;
  DateTime? createdAt;

  ReportModel({
    this.id,
    this.title,
    this.address,
    this.summary,
    this.scanVideoPath,
    this.pdfReport,
    this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'] as int?,
    title: map['title'] as String?,
    address: map['address'] as String?,
    summary: map['summary'] as String?,
    scanVideoPath: map['scanVideoPath'] as String?,
    pdfReport: map['pdfReport'] as String?,
    createdAt: DateTime.parse(map["createdAt"]),
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'address': address,
      'summary': summary,
      'scanVideoPath': scanVideoPath,
      'pdfReport': pdfReport,
      'createdAt': createdAt?.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }
}