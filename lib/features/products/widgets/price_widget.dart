import 'package:flutter/material.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';

class PriceWidget extends StatelessWidget {
  // Constructor for PriceWidget
  const PriceWidget({
    Key? key,
    required this.price,
    required this.salePrice,
    required this.isOnSale,
    this.textSize = 15,
  }) : super(key: key);

  // Properties
  final String price, salePrice;
  final bool isOnSale;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    // Use FittedBox to ensure the text fits within the available space
    return FittedBox(
      child: Row(
        children: [
          // Display the sale price or regular price based on whether it's on sale
          CustomTextWidget(
            text: isOnSale ? 'INR $salePrice' : 'INR $price',
            color: isOnSale ? Colors.green : Colors.black,
            textSize: textSize,
          ),
          const SizedBox(
            width: 5,
          ),
          // Display the regular price with a line-through if it's on sale
          Visibility(
            visible: isOnSale ? true : false,
            child: Text(
              'INR $price',
              style: TextStyle(
                fontSize: textSize,
                color: Colors.black,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
