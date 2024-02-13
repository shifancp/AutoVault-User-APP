import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/screens/categorywise_feed.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    Key? key,
    required this.catText,
    required this.icon,
    required this.passedColor,
  }) : super(key: key);

  // Properties
  final String catText;
  final Color passedColor;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    // Get the screen size using the Utils class
    final Size size = Utils(context).getScreenSize;

    // InkWell is a widget that responds to taps
    return InkWell(
      onTap: () {
        // Navigate to the CategoryWiseFeed screen with the selected category
        Navigator.of(context)
            .pushNamed(CategoryWiseFeed.routeName, arguments: catText);
      },
      child: Container(
        width: size.width * 0.25,
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: passedColor, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // If you want to add an image background, uncomment the following lines
                // image: DecorationImage(
                //   image: AssetImage(imagePath),
                //   fit: BoxFit.fill,
                // ),
              ),
              // Display the category icon
              child: Icon(
                icon.icon,
                color: passedColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Display the category text using the CustomTextWidget
            CustomTextWidget(
              text: catText,
              color: Colors.black,
              textSize: 10,
              isTitle: true,
            ),
          ],
        ),
      ),
    );
  }
}
