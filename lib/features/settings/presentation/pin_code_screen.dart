import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

enum PinCodeMode {
  setup,
  edit,
  verify,
}

@RoutePage()
class PinCodeScreen extends StatefulWidget {
  final PinCodeMode mode;
  final String? title;
  final VoidCallback? onSuccess;
  final VoidCallback? onBiometricAuth;

  const PinCodeScreen({
    super.key,
    required this.mode,
    this.title,
    this.onSuccess,
    this.onBiometricAuth,
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}
class _PinCodeScreenState extends State<PinCodeScreen> {
  final _storage = const FlutterSecureStorage();
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  final _focusNode = FocusNode();
  
  bool _isConfirmStep = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _enteredPin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _screenTitle {
    if (widget.title != null) return widget.title!;
    
    switch (widget.mode) {
      case PinCodeMode.setup:
        return _isConfirmStep 
            ? S.of(context).confirmPinCode 
            : S.of(context).setupPinCode;
      case PinCodeMode.edit:
        return _isConfirmStep 
            ? S.of(context).confirmNewPinCode 
            : S.of(context).enterNewPinCode;
      case PinCodeMode.verify:
        return S.of(context).enterPinCode;
    }
  }

  String get _instructionText {
    switch (widget.mode) {
      case PinCodeMode.setup:
        return _isConfirmStep 
            ? S.of(context).confirmYourPinCode 
            : S.of(context).createFourDigitPinCode;
      case PinCodeMode.edit:
        return _isConfirmStep 
            ? S.of(context).confirmYourNewPinCode 
            : S.of(context).enterYourNewPinCode;
      case PinCodeMode.verify:
        return S.of(context).enterYourPinCode;
    }
  }

  void _onPinChanged(String value) {
    setState(() {
      _errorMessage = null;
    });

    if (value.length == 4) {
      _handlePinComplete(value);
    }
  }

  Future<void> _handlePinComplete(String pin) async {
    setState(() {
      _isLoading = true;
    });

    try {
      switch (widget.mode) {
        case PinCodeMode.setup:
          await _handleSetupMode(pin);
          break;
        case PinCodeMode.edit:
          await _handleEditMode(pin);
          break;
        case PinCodeMode.verify:
          await _handleVerifyMode(pin);
          break;
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      _clearPin();
    }
  }

  Future<void> _handleSetupMode(String pin) async {
    if (!_isConfirmStep) {
      setState(() {
        _enteredPin = pin;
        _isConfirmStep = true;
        _isLoading = false;
      });
      _clearPin();
    } else {
      if (pin == _enteredPin) {
        await _storage.write(key: 'pin', value: pin);
        _showSuccessAndExit();
      } else {
        throw Exception(S.of(context).pinCodesDoNotMatch);
      }
    }
  }

  Future<void> _handleEditMode(String pin) async {
    if (!_isConfirmStep) {
      setState(() {
        _enteredPin = pin;
        _isConfirmStep = true;
        _isLoading = false;
      });
      _clearPin();
    } else {
      if (pin == _enteredPin) {
        await _storage.write(key: 'pin', value: pin);
        _showSuccessAndExit();
      } else {
        throw Exception(S.of(context).pinCodesDoNotMatch);
      }
    }
  }

  Future<void> _handleVerifyMode(String pin) async {
    final storedPin = await _storage.read(key: 'pin');
    if (pin == storedPin) {
      _showSuccessAndExit();
    } else {
      throw Exception(S.of(context).incorrectPinCode);
    }
  }

  void _showSuccessAndExit() {
    setState(() {
      _isLoading = false;
    });
    
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    }
    
    context.router.pop(true);
  }

  void _clearPin() {
    _pinController.clear();
    _confirmController.clear();
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < _pinController.text.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
                ? Theme.of(context).primaryColor 
                : Theme.of(context).dividerColor,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instructionText,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildPinDots(),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              // Скрытое поле ввода для получения фокуса
              Opacity(
                opacity: 0,
                child: TextField(
                  controller: _pinController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: _onPinChanged,
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            if (widget.mode == PinCodeMode.verify && widget.onBiometricAuth != null)
              Column(
                children: [
                  IconButton(
                    onPressed: widget.onBiometricAuth,
                    icon: const Icon(Icons.fingerprint, size: 48),
                    tooltip: S.of(context).useFaceIdTouchId,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (widget.mode == PinCodeMode.edit || _isConfirmStep)
              TextButton(
                onPressed: () {
                  if (_isConfirmStep) {
                    setState(() {
                      _isConfirmStep = false;
                      _enteredPin = '';
                      _errorMessage = null;
                    });
                    _clearPin();
                  } else {
                    context.router.pop();
                  }
                },
                child: Text(
                  _isConfirmStep 
                      ? S.of(context).back 
                      : S.of(context).cancel,
                ),
              ),
          ],
        ),
      ),
    );
  }
}