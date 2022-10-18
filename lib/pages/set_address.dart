import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricelist/providers/address_provider.dart';
import 'package:pricelist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SetAddress extends StatefulWidget {
  const SetAddress({Key? key}) : super(key: key);

  @override
  State<SetAddress> createState() => _SetAddressState();
}

class _SetAddressState extends State<SetAddress> {
  final _formkey = GlobalKey<FormState>();

  void showResult(int resType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resType == 1
            ? 'Check your internet connection'
            : 'Update successful!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.read<Address>().setUserID = context.read<UserState>().getUserID;

    context.read<Address>().readAddress(context.read<UserState>().getUserID);

    TextEditingController roomNumberController =
        TextEditingController(text: context.read<Address>().roomNumber);
    TextEditingController streetController =
        TextEditingController(text: context.read<Address>().street);
    TextEditingController barangayController =
        TextEditingController(text: "Brgy. Ampayon");
    TextEditingController cityController =
        TextEditingController(text: "Butuan City");
    TextEditingController moreDescriptionController =
        TextEditingController(text: context.read<Address>().moreDescription);

    bool x = context.select((Address okay) => okay.visible);

    Future<void> counter() {
      showResult(0);
      return Future.delayed(const Duration(seconds: 2));
    }

    void updateResult() {
      context.read<Address>().changeVisible();
      context.read<Address>().updateAddress(
            roomNumberController.text,
            streetController.text,
            barangayController.text,
            cityController.text,
            moreDescriptionController.text,
            context.read<UserState>().getUserID,
            context,
          );
    }

    //bool x = (context.watch<Address>().visible == true) ? true : false;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        backgroundColor: const Color(0xff27ae60),
        title: Text(
          'EDIT ADDRESS',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(11.0),
          ),
        ),
        actions: <Widget>[
          Container(
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.edit)),
        ],
      ),
      body: Stack(children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _formkey,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(19.0, 15.0, 19.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //container for floor
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: TextFormField(
                              style: GoogleFonts.inter(),
                              controller: roomNumberController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                labelText: 'Building/Floor/House No.',
                                hintStyle: GoogleFonts.inter(fontSize: 14),
                              ),
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                          //Container for street
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: TextFormField(
                              style: GoogleFonts.inter(),
                              controller: streetController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                labelText: 'Street/Purok',
                                hintStyle: GoogleFonts.inter(fontSize: 14),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          //Container for barangay
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: TextFormField(
                              style: GoogleFonts.inter(),
                              controller: barangayController,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                labelText: 'Barangay (default)',
                                hintStyle: GoogleFonts.inter(fontSize: 14),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          //Container for city
                          Container(
                            margin: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: TextFormField(
                              style: GoogleFonts.inter(),
                              readOnly: true,
                              controller: cityController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                labelText: 'City (default)',
                                hintStyle: GoogleFonts.inter(fontSize: 14),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),

                          //Container for more description
                          Container(
                            margin:
                                const EdgeInsets.fromLTRB(8.0, 11.0, 8.0, 80.0),
                            child: TextFormField(
                              style: GoogleFonts.inter(),
                              controller: moreDescriptionController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                hintText: 'Add Description \n\n\n',
                                hintStyle: GoogleFonts.inter(),
                              ),
                              validator: (value) {
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //A free space container
                    // Container(
                    //   padding: const EdgeInsets.all(57.0),
                    // ),
                    //A container with one border and text button
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: x,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            color: Colors.white,
            child: Center(
                child: SpinKitRing(
              color: Colors.green,
              size: MediaQuery.of(context).size.height * 0.01 * 10,
            )),
          ),
        ),
      ]),
      floatingActionButton: Visibility(
        visible: (x == true) ? false : true,
        child: FloatingActionButton.extended(
          onPressed: () async {
            
            FocusManager.instance.primaryFocus?.unfocus();
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
              if (_formkey.currentState!.validate()) {
                
                updateResult();
                await counter();
              }
            } else {
              showResult(1);
            }
          },
          label: Text(
            'Save Changes',
            style: GoogleFonts.inter(),
          ),
          icon: const Icon(Icons.check),
          backgroundColor: const Color(0xff27ae60),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
