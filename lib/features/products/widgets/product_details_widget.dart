import 'package:flutter/material.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/features/products/widgets/price_widget.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    super.key,
    required this.title,
    required this.description,
    required this.odoreading,
    required this.modelyear,
    required this.condition,
    required this.category,
    required this.price,
    required this.sellingprice,
    required this.fueltype,
    required this.onoffer,
  });

  final String title,
      description,
      odoreading,
      modelyear,
      condition,
      category,
      price,
      sellingprice,
      fueltype;
  final bool onoffer;

  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Title
          CustomTextWidget(
            text: title,
            color: Colors.black,
            textSize: 25,
            isTitle: true,
          ),
          SizedBox(
            height: size.height * 0.22,
            child: SingleChildScrollView(
              child: CustomTextWidget(
                maxLines: 10,
                fulldesc: true,
                text: description,
                color: Colors.black54,
                textSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          // Details: Odometer Reading, Model Year, Fuel Type, Condition, Category
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/odometer-for-kilometers-and-speed-control.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  CustomTextWidget(
                    text: odoreading,
                    color: Colors.black54,
                    textSize: 15,
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Image.asset(
                    'assets/images/calendar.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  CustomTextWidget(
                    text: modelyear,
                    color: Colors.black54,
                    textSize: 15,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/fueltype.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  CustomTextWidget(
                    text: fueltype,
                    color: Colors.black54,
                    textSize: 15,
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Image.asset(
                    'assets/images/condition.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  CustomTextWidget(
                    text: condition,
                    color: Colors.black54,
                    textSize: 15,
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Image.asset(
                    'assets/images/category.png',
                    height: 20,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  CustomTextWidget(
                    text: category,
                    color: Colors.black54,
                    textSize: 15,
                  ),
                ],
              ),
            ],
          ),
          // Product Price
          PriceWidget(
            price: price,
            salePrice: sellingprice,
            isOnSale: onoffer,
            textSize: 25,
          )
        ],
      ),
    );
  }
}
