import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

import 'package:auto_vault_user/features/authentication/providers/mobile_auth_provider.dart';
import 'package:auto_vault_user/services/utils.dart';

import 'package:provider/provider.dart';

class MobileNumber extends StatefulWidget {
  const MobileNumber({super.key});
  static const routename = '/mobverify';

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  final TextEditingController _mobileController = TextEditingController();

  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  Country selectedCountry = Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'India',
    example: 'India',
    displayName: 'India',
    displayNameNoCountryCode: 'IN',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    // Get the loading state from the MobileAuthProvider
    final isLoading =
        Provider.of<MobileAuthProvider>(context, listen: true).isLoading;

    // Set the cursor position at the end of the mobile number field
    _mobileController.selection = TextSelection.fromPosition(
      TextPosition(offset: _mobileController.text.length),
    );

    // Get the screen size using utility function
    final Size size = Utils(context).getScreenSize;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/phone 2.png',
                height: size.height * 0.1,
              ),
              const Text(
                'Enter your mobile number below to verify',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _mobileController.text = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14.0),
                    child: InkWell(
                      onTap: () {
                        // Show country picker when tapping on the flag icon
                        showCountryPicker(
                          context: context,
                          countryListTheme: const CountryListThemeData(
                            bottomSheetHeight: 300,
                          ),
                          onSelect: ((value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          }),
                        );
                      },
                      child: Text(
                        '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter Your Mobile number',
                ),
                controller: _mobileController,
                key: _formKey,
                textInputAction: TextInputAction.next,
                validator: (value) => value != null && value.length < 10
                    ? 'Enter valid Mobile Number'
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    // Initiate phone number verification when the button is pressed
                    isLoading ? null : sendPhoneNumber();
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Send OTP'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to send the phone number for verification
  void sendPhoneNumber() {
    String phoneNumber = _mobileController.text.trim();
    final provider = Provider.of<MobileAuthProvider>(context, listen: false);
    provider.signInWithPhone(
        context, '+${selectedCountry.phoneCode}$phoneNumber');
  }
}
