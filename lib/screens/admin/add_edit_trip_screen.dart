import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../widgets/admin/admin_ui.dart';
import '../../widgets/common/trip_facilities.dart';

class AddEditTripScreen extends StatefulWidget {
  final String? tripId;
  const AddEditTripScreen({super.key, this.tripId});
  @override
  State<AddEditTripScreen> createState() => _AddEditTripScreenState();
}
class _AddEditTripScreenState extends State<AddEditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _destination, _description, _price, _capacity;
  DateTime? _start, _end;
  String _category = 'Group', _imageAsset = 'assets/images/nature.jfif';
  String? _photo, _dateError, _facilityError;
  final Set<String> _facilities = {};
  bool _saving = false, _pickingImage = false, _missing = false;
  bool get _editing => widget.tripId != null;
  int get _duration => _start == null || _end == null ? 0
      : calendarDay(_end!).difference(calendarDay(_start!)).inDays + 1;
  @override
  void initState() {
    super.initState();
    final trip = widget.tripId == null ? null : AdminStore.instance.tripById(widget.tripId!);
    _missing = _editing && trip == null;
    _name = TextEditingController(text: trip?.name ?? '');
    _destination = TextEditingController(text: trip?.destination ?? '');
    _description = TextEditingController(text: trip?.description ?? '');
    _price = TextEditingController(text: trip?.price.toString() ?? '');
    _capacity = TextEditingController(text: trip?.capacity.toString() ?? '');
    if (trip != null) {
      _start = trip.startDate; _end = trip.endDate; _category = trip.category;
      _photo = trip.imageBase64; _imageAsset = trip.imageAsset;
      _facilities.addAll(trip.facilities);
    }
  }
  @override
  void dispose() {
    for (final controller in [_name, _destination, _description, _price, _capacity]) { controller.dispose(); }
    super.dispose();
  }
  Future<void> _pickImage() async {
    setState(() => _pickingImage = true);
    try {
      final image = await pickPhoto();
      if (mounted && image != null) setState(() => _photo = image);
    } catch (error) {
      if (mounted) notice(context, error is ArgumentError ? friendlyError(error) : 'Gagal membuka galeri. Periksa izin foto aplikasi.');
    } finally {
      if (mounted) setState(() => _pickingImage = false);
    }
  }
  Future<void> _pickDate(bool start) async {
    final today = calendarDay(AdminStore.instance.clock());
    var first = _editing ? DateTime(2000) : today;
    if (!start && _start != null) first = _start!;
    var initial = (start ? _start : _end) ?? _start ?? today;
    if (initial.isBefore(first)) initial = first;
    var last = DateTime(today.year + 20, 12, 31);
    if (initial.isAfter(last)) last = initial;
    final result = await showDatePicker(context: context, initialDate: initial,
        firstDate: first, lastDate: last);
    if (!mounted || result == null) return;
    setState(() {
      if (start) {
        _start = result;
        if (_end != null && _end!.isBefore(result)) _end = null;
      } else { _end = result; }
      _dateError = null;
    });
  }
  Future<void> _save() async {
    final valid = _formKey.currentState!.validate();
    setState(() {
      _dateError = _start == null || _end == null || _duration < 1 ? 'Pilih tanggal keberangkatan dan selesai yang valid.' : null;
      _facilityError = _facilities.isEmpty ? 'Pilih minimal satu fasilitas.' : null;
    });
    if (!valid || _dateError != null || _facilityError != null) return;
    setState(() => _saving = true);
    try {
      final trip = AdminTrip(id: widget.tripId ?? AdminStore.instance.newTripId(),
          name: _name.text.trim(), destination: _destination.text.trim(), description: _description.text.trim(),
          category: _category, startDate: _start!, endDate: _end!,
          price: int.parse(_price.text), capacity: int.parse(_capacity.text),
          facilities: tripFacilities.where((f) => _facilities.contains(f.label)).map((f) => f.label).toList(),
          imageBase64: _photo, imageAsset: _imageAsset);
      await AdminStore.instance.saveTrip(trip, editing: _editing);
      if (!mounted) return;
      notice(context, _editing ? 'Perubahan trip berhasil disimpan.' : 'Trip baru berhasil ditambahkan.');
      Navigator.pop(context, trip.id);
    } catch (error) {
      if (mounted) notice(context, friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
  Widget _field(String label, TextEditingController controller, {int lines = 1, bool number = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(controller: controller, enabled: !_saving, maxLines: lines,
        keyboardType: number ? TextInputType.number : lines > 1 ? TextInputType.multiline : TextInputType.text,
        inputFormatters: number ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(labelText: label, helperText: number && label == 'Price (Rp)' ? 'Angka saja, contoh: 1500000' : null),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return '$label wajib diisi';
          if (number) {
            final value = int.tryParse(v);
            if (value == null || value <= 0 || value > 1000000000000) return 'Masukkan angka positif yang valid';
            if (controller == _capacity && _editing && value < AdminStore.instance.reservedSeats(widget.tripId!)) {
              return 'Minimal ${AdminStore.instance.reservedSeats(widget.tripId!)} kursi sudah dipesan';
            }
          }
          return null;
        }),
  );
  @override
  Widget build(BuildContext context) => AdminPage(title: _editing ? 'Edit Trip' : 'Add New Trip',
    body: _missing ? const EmptyState(title: 'Trip tidak ditemukan', message: 'Kembali ke daftar trip.')
        : ListView(padding: const EdgeInsets.all(20), children: [
      Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminCard(onTap: _saving || _pickingImage ? null : _pickImage, child: Column(children: [
          ClipRRect(borderRadius: BorderRadius.circular(18), child: Image(
              image: _photo == null ? AssetImage(_imageAsset) : MemoryImage(base64Decode(_photo!)),
              height: 160, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, error, stack) => const SizedBox(height: 120, child: Icon(Icons.photo_outlined, size: 50)))),
          const SizedBox(height: 12), Text(_pickingImage ? 'Membuka galeri...' : 'Ketuk untuk mengubah cover trip'),
        ])),
        const SectionTitle('Basic Information'), _field('Trip Name', _name),
        _field('Destination', _destination), _field('Description', _description, lines: 4),
        const SectionTitle('Category & Facilities'),
        DropdownButtonFormField<String>(initialValue: _category,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: ['Group', 'Private'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: _saving ? null : (v) { if (v != null) setState(() => _category = v); }),
        const SizedBox(height: 16), Wrap(spacing: 8, runSpacing: 8,
            children: tripFacilities.map((f) => FilterChip(label: Text(f.label),
                avatar: Icon(f.icon, size: 18, color: f.color), selected: _facilities.contains(f.label),
                onSelected: _saving ? null : (selected) => setState(() {
                  if (selected) { _facilities.add(f.label); } else { _facilities.remove(f.label); }
                  _facilityError = null;
                }))).toList()),
        if (_facilityError != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_facilityError!, style: const TextStyle(color: Colors.red))),
        const SectionTitle('Schedule & Duration'),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: const Icon(Icons.flight_takeoff_rounded), title: const Text('Start Date'),
            subtitle: Text(_start == null ? 'Pilih tanggal keberangkatan' : dateLabel(_start!)),
            trailing: const Icon(Icons.calendar_month), onTap: _saving ? null : () => _pickDate(true)),
        const SizedBox(height: 12),
        ListTile(tileColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: const Icon(Icons.event_available), title: const Text('End Date'),
            subtitle: Text(_end == null ? 'Pilih tanggal selesai' : dateLabel(_end!)),
            trailing: const Icon(Icons.calendar_month), onTap: _saving ? null : () => _pickDate(false)),
        const SizedBox(height: 12), Text('Total Duration: $_duration hari (termasuk hari berangkat dan selesai)'),
        if (_dateError != null) Text(_dateError!, style: const TextStyle(color: Colors.red)),
        const SectionTitle('Pricing & Capacity'),
        _field('Price (Rp)', _price, number: true), _field('Total Quota', _capacity, number: true),
        if (_saving) const LinearProgressIndicator(), const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          OutlinedButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: _saving || _pickingImage ? null : _save,
              child: Text(_saving ? 'Menyimpan...' : _editing ? 'Save Changes' : 'Publish Trip')),
        ]),
        const SizedBox(height: 32),
      ])),
    ]),
  );
}
