import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateProfitPdf(Map<String, dynamic> data) async {
    final pdf = pw.Document();

    // Mengambil data dengan aman (Null Safety)
    final String totalRevenue = data['total_revenue']?.toString() ?? 'Rp 0';
    final String netProfit = data['net_profit']?.toString() ?? 'Rp 0';
    final List bestSelling = data['best_selling'] ?? [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "LAPORAN PENDAPATAN",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Tanggal: ${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Ringkasan Keuangan
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Total Revenue:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(totalRevenue),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Net Profit (40%):",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(netProfit),
                ],
              ),
              pw.SizedBox(height: 30),

              pw.Text(
                "Daftar Menu Terlaris:",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              // Tabel Menu
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Rank', 'Menu', 'Terjual', 'Pendapatan'],
                  ...bestSelling.asMap().entries.map((e) {
                    var item = e.value;
                    return <String>[
                      (e.key + 1).toString(),
                      item['name'].toString(),
                      item['sold'].toString(),
                      item['amount'].toString(),
                    ];
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Langsung print atau simpan ke printer
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
