import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class NewBatteryFormData {
  final String name;
  final String brand;
  final int cellCount;
  final int capacityMah;
  final int cRating;
  final DateTime purchaseDate;

  const NewBatteryFormData({
    required this.name,
    required this.brand,
    required this.cellCount,
    required this.capacityMah,
    required this.cRating,
    required this.purchaseDate,
  });
}

// ─── View ─────────────────────────────────────────────────────────────────────

class AddNewBatteryView extends StatefulWidget {
  final void Function(NewBatteryFormData data)? onSave;

  const AddNewBatteryView({super.key, this.onSave});

  @override
  State<AddNewBatteryView> createState() => _AddNewBatteryViewState();
}

class _AddNewBatteryViewState extends State<AddNewBatteryView> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _brandFocus = FocusNode();
  final _capacityFocus = FocusNode();
  final _cRatingFocus = FocusNode();

  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _capacityCtrl = TextEditingController();
  final _cRatingCtrl = TextEditingController();

  int _selectedCellCount = 4;
  DateTime? _purchaseDate;
  bool _isSaving = false;

  final List<int> _defaultCells = [4, 6, 8];
  final List<int> _customCells = [];

  List<int> get _allCells => [..._defaultCells, ..._customCells];

  @override
  void dispose() {
    _nameFocus.dispose();
    _brandFocus.dispose();
    _capacityFocus.dispose();
    _cRatingFocus.dispose();
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _capacityCtrl.dispose();
    _cRatingCtrl.dispose();
    super.dispose();
  }

  // ── Date Picker ─────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    _dismissKeyboard();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? now,
      firstDate: DateTime(2010),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00C853),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  // ── Custom Cell Count ────────────────────────────────────────────────────────

  Future<void> _addCustomCellCount() async {
    _dismissKeyboard();
    final ctrl = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Custom Cell Count',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          autofocus: true,
          decoration: _inputDecoration('e.g. 12'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          TextButton(
            onPressed: () {
              final v = int.tryParse(ctrl.text);
              if (v != null && v >= 1 && v <= 24) Navigator.pop(ctx, v);
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Color(0xFF00C853),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (result != null && !_allCells.contains(result)) {
      setState(() {
        _customCells.add(result);
        _selectedCellCount = result;
      });
    }
  }

  void _dismissKeyboard() => FocusScope.of(context).unfocus();

  // ── Save ─────────────────────────────────────────────────────────────────────

  Future<void> _onSave() async {
    _dismissKeyboard();

    // Trigger validation on all fields including purchase date
    final formValid = _formKey.currentState?.validate() ?? false;

    // Check purchase date separately (not a TextFormField)
    if (_purchaseDate == null) {
      setState(() {}); // rebuild to show date error
    }

    if (!formValid || _purchaseDate == null) return;

    setState(() => _isSaving = true);

    // Simulate async save
    await Future.delayed(const Duration(milliseconds: 600));

    widget.onSave?.call(
      NewBatteryFormData(
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim(),
        cellCount: _selectedCellCount,
        capacityMah: int.parse(_capacityCtrl.text),
        cRating: int.parse(_cRatingCtrl.text),
        purchaseDate: _purchaseDate!,
      ),
    );

    if (mounted) setState(() => _isSaving = false);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: _buildAppBar(),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              SizedBox(height: 8.h),

              // ── Battery Name ──
              _SectionLabel('Battery Name'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_brandFocus),
                decoration: _inputDecoration('e.g. Daily Basher Pack'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Battery name is required';
                  }
                  if (v.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              // ── Brand ──
              _SectionLabel('Brand'),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _brandCtrl,
                focusNode: _brandFocus,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_capacityFocus),
                decoration: _inputDecoration('e.g. Tattu, CNHL, Ovonic'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Brand is required';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              // ── Cell Count ──
              _SectionLabel('Cell Count'),
              SizedBox(height: 10.h),
              _buildCellCountSelector(),

              SizedBox(height: 20.h),

              // ── Capacity + C Rating ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('Capacity (mAh)'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _capacityCtrl,
                          focusNode: _capacityFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          onFieldSubmitted: (_) => FocusScope.of(
                            context,
                          ).requestFocus(_cRatingFocus),
                          decoration: _inputDecoration('1300'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final n = int.tryParse(v);
                            if (n == null || n < 100 || n > 99999) {
                              return '100–99999';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('C Rating'),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _cRatingCtrl,
                          focusNode: _cRatingFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onFieldSubmitted: (_) => _dismissKeyboard(),
                          decoration: _inputDecoration('100'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final n = int.tryParse(v);
                            if (n == null || n < 1 || n > 2000) {
                              return '1–2000';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // ── Purchase Date ──
              _SectionLabel('Purchase Date'),
              SizedBox(height: 8.h),
              _buildDateField(),

              SizedBox(height: 20.h),

              // ── Info Card ──
              _buildInfoCard(),

              SizedBox(height: 32.h),

              // ── Save Button ──
              _buildSaveButton(),

              SizedBox(height: 12.h),

              // ── Cancel ──
              Center(
                child: TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Add New Battery',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A1A2E),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.battery_charging_full_rounded,
            color: Colors.blueGrey.shade300,
            size: 26,
          ),
        ),
      ],
    );
  }

  // ── Cell Count Selector ──────────────────────────────────────────────────────

  Widget _buildCellCountSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._allCells.map(
          (c) => _CellChip(
            label: '${c}S',
            isSelected: _selectedCellCount == c,
            onTap: () => setState(() => _selectedCellCount = c),
          ),
        ),
        _CellChip(
          label: '+',
          isSelected: false,
          isAdd: true,
          onTap: _addCustomCellCount,
        ),
      ],
    );
  }

  // ── Date Field ───────────────────────────────────────────────────────────────

  Widget _buildDateField() {
    final hasError =
        _purchaseDate == null && (_formKey.currentState?.validate() == false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    (_purchaseDate == null &&
                        _formKey.currentState != null &&
                        !(_formKey.currentState?.validate() ?? true))
                    ? const Color(0xFFE53935)
                    : const Color(0xFFDDDDDD),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _purchaseDate != null
                        ? (DateFormat(
                            'MM/dd/yyyy',
                          ).format(_purchaseDate!)).toString()
                        : 'mm/dd/yyyy',
                    style: TextStyle(
                      fontSize: 15,
                      color: _purchaseDate != null
                          ? const Color(0xFF1A1A2E)
                          : Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.blueGrey.shade300,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_purchaseDate == null && _formKey.currentState != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 14),
            child: Text(
              'Purchase date is required',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  // ── Info Card ────────────────────────────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF00C853),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Battery Setup',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'PackPulse will automatically start tracking the cycle count and health percentage for this battery after your first flight log.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.55),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Save Button ──────────────────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: _isSaving ? null : _onSave,
        icon: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save_rounded, color: Colors.white, size: 20),
        label: Text(
          _isSaving ? 'Saving...' : 'Save Battery',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          disabledBackgroundColor: const Color(0xFF00C853).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

// ─── Cell Count Chip ──────────────────────────────────────────────────────────

class _CellChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isAdd;
  final VoidCallback onTap;

  const _CellChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 64,
        height: 46,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00C853).withOpacity(0.1)
              : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00C853) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? const Color(0xFF00C853)
                  : isAdd
                  ? Colors.black.withOpacity(0.4)
                  : const Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}

// ─── Input Decoration Helper ──────────────────────────────────────────────────

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: Colors.black.withOpacity(0.28), fontSize: 15),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF00C853), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
    ),
    errorStyle: const TextStyle(fontSize: 12, height: 1.2),
    filled: true,
    fillColor: Colors.white,
  );
}
