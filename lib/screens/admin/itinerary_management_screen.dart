import 'package:flutter/material.dart';
import '../../core/admin/admin_models.dart';
import '../../core/admin/admin_store.dart';
import '../../core/theme/app_colors.dart';
import '../../models/itinerary_model.dart';
import '../../services/itinerary_service.dart';
import '../../widgets/admin/admin_ui.dart';

class ItineraryManagementScreen extends StatefulWidget {
  final String? initialTripId;

  const ItineraryManagementScreen({super.key, this.initialTripId});

  @override
  State<ItineraryManagementScreen> createState() =>
      _ItineraryManagementScreenState();
}

class _ItineraryManagementScreenState extends State<ItineraryManagementScreen> {
  String? _selectedTripId;

  @override
  void initState() {
    super.initState();
    _selectedTripId = widget.initialTripId;
  }

  Future<void> _openFormDialog(
    BuildContext context,
    AdminTrip trip, {
    ItineraryModel? existing,
  }) async {
    final formKey = GlobalKey<FormState>();
    final dayController = TextEditingController(
      text: (existing?.dayNumber ?? 1).toString(),
    );
    final timeController = TextEditingController(
      text: existing?.timeSlot ?? '08:00 - 10:00',
    );
    final titleController = TextEditingController(
      text: existing?.title ?? '',
    );
    final locationController = TextEditingController(
      text: existing?.location ?? '',
    );
    final descController = TextEditingController(
      text: existing?.description ?? '',
    );
    bool isSaving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existing == null ? 'Tambah Agenda Trip' : 'Edit Agenda Trip',
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: dayController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hari ke- (Day)',
                          hintText: 'Contoh: 1',
                        ),
                        validator: (v) {
                          final n = int.tryParse(v?.trim() ?? '');
                          if (n == null || n < 1) {
                            return 'Masukkan angka hari minimal 1';
                          }
                          if (n > trip.durationDays) {
                            return 'Maksimal ${trip.durationDays} hari sesuai durasi trip';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: timeController,
                        decoration: const InputDecoration(
                          labelText: 'Waktu / Jam',
                          hintText: 'Contoh: 08:00 - 10:00 WIB',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Waktu wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Kegiatan',
                          hintText: 'Contoh: Sunrise Trekking Sipolha',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Judul kegiatan wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: 'Titik Lokasi (Opsional)',
                          hintText: 'Contoh: Dermaga Sipolha',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Singkat (Opsional)',
                          hintText: 'Detail aktivitas peserta...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setDialogState(() => isSaving = true);

                          final item = ItineraryModel(
                            id: existing?.id ??
                                'IT-${DateTime.now().millisecondsSinceEpoch}',
                            tripId: trip.id,
                            dayNumber: int.parse(dayController.text.trim()),
                            timeSlot: timeController.text.trim(),
                            title: titleController.text.trim(),
                            location: locationController.text.trim(),
                            description: descController.text.trim(),
                          );

                          try {
                            await ItineraryService.saveItinerary(item);
                            if (!mounted) return;
                            Navigator.pop(dialogContext);
                            notice(
                              this.context,
                              existing == null
                                  ? 'Agenda itinerary ditambahkan.'
                                  : 'Agenda itinerary diperbarui.',
                            );
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            if (!mounted) return;
                            notice(this.context, friendlyError(e));
                          }
                        },
                  child: Text(isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteItem(BuildContext context, ItineraryModel item) async {
    final ok = await confirmAction(
      context,
      title: 'Hapus agenda?',
      message: 'Agenda "${item.title}" pada Hari ${item.dayNumber} akan dihapus.',
      confirmLabel: 'Hapus',
    );
    if (!ok || !mounted) return;

    try {
      await ItineraryService.deleteItinerary(item.tripId, item.id);
      if (!mounted) return;
      notice(context, 'Agenda berhasil dihapus.');
    } catch (e) {
      if (!mounted) return;
      notice(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdminStore.instance,
      builder: (context, _) {
        final store = AdminStore.instance;
        final trips = store.trips;

        if (trips.isEmpty) {
          return const AdminPage(
            title: 'Itinerary Management',
            body: EmptyState(
              title: 'Belum ada trip',
              message: 'Buat trip terlebih dahulu untuk mengatur jadwalnya.',
            ),
          );
        }

        final activeTrip = (_selectedTripId != null
                ? store.tripById(_selectedTripId!)
                : null) ??
            trips.first;

        return AdminPage(
          title: 'Itinerary Management',
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.islandPink,
            foregroundColor: AppColors.white,
            onPressed: () => _openFormDialog(context, activeTrip),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Agenda'),
          ),
          body: StreamBuilder<List<ItineraryModel>>(
            stream: ItineraryService.itinerariesStream(activeTrip.id),
            builder: (context, snapshot) {
              final items = snapshot.data ?? const <ItineraryModel>[];

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                children: [
                  const SectionTitle('Pilih Paket Trip'),
                  DropdownButtonFormField<String>(
                    value: activeTrip.id,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: trips
                        .map(
                          (t) => DropdownMenuItem<String>(
                            value: t.id,
                            child: Text(
                              '${t.name} (${t.durationDays} Hari)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedTripId = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailRow('Destinasi', activeTrip.destination),
                        DetailRow('Durasi Trip', '${activeTrip.durationDays} Hari'),
                        DetailRow('Total Agenda', '${items.length} kegiatan'),
                      ],
                    ),
                  ),
                  const SectionTitle('Susunan Kegiatan'),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (snapshot.hasError)
                    EmptyState(
                      title: 'Gagal memuat itinerary',
                      message: '${snapshot.error}',
                    )
                  else if (items.isEmpty)
                    const EmptyState(
                      title: 'Belum ada itinerary',
                      message:
                          'Tekan tombol "+ Tambah Agenda" di bawah untuk menyusun jadwal perjalanan.',
                    )
                  else
                    ...items.map(
                      (item) => AdminCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatusBadge(label: 'Day ${item.dayNumber}'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.timeSlot,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Edit',
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  onPressed: () => _openFormDialog(
                                    context,
                                    activeTrip,
                                    existing: item,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Hapus',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteItem(context, item),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (item.location.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    size: 15,
                                    color: AppColors.islandPink,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      item.location,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (item.description.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}