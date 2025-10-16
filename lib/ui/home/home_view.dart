import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:zeekr/ui.dart';

// import 'animated_flutter_logo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _ipAddressController;
  late final TextEditingController _subnetMaskController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _ipAddressController = TextEditingController(text: '192.168.40.85');
    _subnetMaskController = TextEditingController(text: '255.255.254.0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              _formKey.currentState!.reset();
              final i = _formKey.currentState!.validate();
              if (!i) return;
              _formKey.currentState!.save();
            },
            icon: Icon(Symbols.save),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        // child: FractionallySizedBox(
        //   widthFactor: 0.5,
        //   heightFactor: 0.5,
        //   child: AnimatedFlutterLogo(),
        // ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              TextFormField(
                validator:
                    (value) => value == null || value.isEmpty ? 'Null' : null,
                onSaved: (newValue) {
                  debugPrint('ipAddress saved: $newValue');
                },
                // controller: _ipAddressController,
                initialValue: '111',
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('IP地址'),
                ),
              ),
              IpAddressFormField(
                validator:
                    (value) => value == null || value.isEmpty ? 'Null' : null,
                onSaved: (newValue) {
                  debugPrint('subnetMask saved: $newValue');
                },
                initialValue: '192',
                // controller: _subnetMaskController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('子网掩码'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ipAddressController.dispose();
    _subnetMaskController.dispose();
    super.dispose();
  }
}
