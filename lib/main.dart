import 'package:flutter/material.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Country Code Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountryCodePickerScreen(),
    );
  }
}

class CountryCodePickerScreen extends StatefulWidget {
  const CountryCodePickerScreen({Key? key}) : super(key: key);

  @override
  State<CountryCodePickerScreen> createState() =>
      _CountryCodePickerScreenState();
}

class _CountryCodePickerScreenState extends State<CountryCodePickerScreen> {
  final controller = Get.put(CountryCodePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Code Picker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                // padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20)),
                      child: GestureDetector(
                        onTap: () async {
                          final code = await controller.countryPicker
                              .showPicker(context: context);
                          if (code != null) {
                            controller.selectedCountryCode.value = code;
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Obx(() {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ClipOval(
                                    child: CountryCodeFlagWidget(
                                        width: 30,
                                        fit: BoxFit.fill,
                                        alignment: Alignment.center,
                                        countryCode: controller
                                                .selectedCountryCode.value ??
                                            const CountryCode(
                                                name: 'ind',
                                                code: "IN",
                                                dialCode: '+91')),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.selectedCountryCode.value
                                          ?.dialCode ??
                                      '+91',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.keyboard_arrow_down_outlined),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Obx(
                () {
                  if (controller.selectedCountryCode.value != null) {
                    return Text(
                        "number :- ${controller.selectedCountryCode.value?.dialCode} ${controller.phoneController.value.text}");
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountryCodePickerController extends GetxController {
  final FlCountryCodePicker countryPicker = const FlCountryCodePicker();
  final TextEditingController phoneController = TextEditingController();
  Rxn<CountryCode> selectedCountryCode = Rxn<CountryCode>();
}
