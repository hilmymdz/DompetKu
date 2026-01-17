import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../helpers/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddEditScreen({super.key, this.transaction});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late double amount;
  String type = 'expense';
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      title = widget.transaction!.title;
      amount = widget.transaction!.amount;
      type = widget.transaction!.type;
      date = widget.transaction!.date;
    } else {
      title = '';
      amount = 0;
    }
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final transaction = TransactionModel(
        id: widget.transaction?.id,
        title: title,
        amount: amount,
        date: date,
        type: type,
      );

      if (widget.transaction == null) {
        await DatabaseHelper.instance.create(transaction);
      } else {
        await DatabaseHelper.instance.update(transaction);
      }

      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Tambah Transaksi' : 'Edit Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Toggle Jenis Transaksi
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'expense', label: Text('Pengeluaran'), icon: Icon(Icons.outbond)),
                  ButtonSegment(value: 'income', label: Text('Pemasukan'), icon: Icon(Icons.input)),
                ],
                selected: {type},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Input Judul
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => value != null && value.isEmpty ? 'Judul tidak boleh kosong' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 16),

              // Input Jumlah
              TextFormField(
                initialValue: widget.transaction != null ? amount.toStringAsFixed(0) : '',
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value != null && double.tryParse(value) == null ? 'Masukkan angka valid' : null,
                onSaved: (value) => amount = double.parse(value!),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              FilledButton.icon(
                onPressed: _saveTransaction,
                icon: const Icon(Icons.save),
                label: const Text('SIMPAN TRANSAKSI'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}