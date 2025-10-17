import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:zeekr/ui.dart';
import 'package:zeekr/util.dart';

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
    _ipAddressController = TextEditingController(text: '192.168.0.1');
    _subnetMaskController = TextEditingController(text: '255.255.255.0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              TextFormField(
                validator:
                    (value) =>
                        value == null || !ExpUtil.ipAddress.hasMatch(value)
                            ? '格式错误'
                            : null,
                onSaved: (newValue) {
                  debugPrint('ipAddress saved: $newValue');
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('IP地址'),
                ),
                initialValue: '192.168.0.1',
                // controller: _ipAddressController,
              ),
              IpAddressFormField(
                validator:
                    (value) =>
                        value == null || !ExpUtil.ipAddress.hasMatch(value)
                            ? '格式错误'
                            : null,
                onSaved: (newValue) {
                  debugPrint('subnetMask saved: $newValue');
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('子网掩码'),
                ),
                // initialValue: '255.255.255.0',
                // controller: _subnetMaskController,
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
