import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StocksCard extends StatelessWidget {
  final BoxConstraints constraint;
  final String stockName;
  final String stockLogo;
  final double stockPrice;

  const StocksCard({
    super.key,
    required this.constraint,
    required this.stockName,
    required this.stockLogo,
    required this.stockPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          title: Text(stockName, style: GoogleFonts.poppins(fontSize: constraint.maxWidth * 0.045, fontWeight: FontWeight.w600),),
          leading: SizedBox(
              width: constraint.maxWidth * 0.09,
              height: constraint.maxHeight * 0.08,
              child: Image.network(stockLogo)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('fs $stockPrice', style: GoogleFonts.poppins(fontSize: constraint.maxWidth * 0.035, fontWeight: FontWeight.w500),),
              _arrowSign(stockPrice),
            ],
          ),
        ),
      ),
    );
  }

  _arrowSign(double price) {
    if (price >= 0) {
      return const Icon(
        Icons.arrow_drop_up,
        color: Colors.green,
      );
    } else {
      return const Icon(
        Icons.arrow_drop_down,
        color: Colors.red,
      );
    }
  }
}
