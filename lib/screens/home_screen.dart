import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_item.dart';
import '../widgets/summary_card.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  bool _isLoading = true;
  String _filterType = 'Bulan Ini';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.readAllTransactions();
    setState(() {
      _allTransactions = data;
      _isLoading = false;
      _applyFilter(_filterType);
    });
  }

  void _deleteTransaction(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaksi berhasil dihapus'),
          backgroundColor: const Color(0xFF1E293B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _applyFilter(String type) {
    final now = DateTime.now();
    List<TransactionModel> result = [];

    switch (type) {
      case 'Hari Ini':
        result = _allTransactions.where((t) {
          return t.date.day == now.day &&
                 t.date.month == now.month &&
                 t.date.year == now.year;
        }).toList();
        break;
      case 'Bulan Ini':
        result = _allTransactions.where((t) {
          return t.date.month == now.month &&
                 t.date.year == now.year;
        }).toList();
        break;
      case 'Tahun Ini':
        result = _allTransactions.where((t) {
          return t.date.year == now.year;
        }).toList();
        break;
      case 'Semua':
      default:
        result = List.from(_allTransactions);
        break;
    }

    setState(() {
      _filterType = type;
      _filteredTransactions = result;
    });
  }

  double get _totalIncome {
    return _filteredTransactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _totalExpense {
    return _filteredTransactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DompetKu',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Chip Area
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: ['Hari Ini', 'Bulan Ini', 'Tahun Ini', 'Semua'].map((filter) {
                      final isSelected = _filterType == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) _applyFilter(filter);
                            },
                            // Style Chip Modern
                            backgroundColor: Colors.white,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected 
                                ? Colors.white 
                                : const Color(0xFF64748B), // Slate 500
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected 
                                  ? Colors.transparent 
                                  : Colors.grey.withOpacity(0.2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            showCheckmark: false,
                            elevation: 0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SummaryCard(
                    income: _totalIncome,
                    expense: _totalExpense,
                  ),
                ),

                const SizedBox(height: 20),

                // List Transaksi
                Expanded(
                  child: _filteredTransactions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wallet_outlined, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada transaksi',
                                style: TextStyle(color: Colors.grey[400], fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80, top: 0),
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = _filteredTransactions[index];
                            return TransactionItem(
                              transaction: transaction,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditScreen(transaction: transaction),
                                  ),
                                );
                                if (result == true) _loadData();
                              },
                              onDelete: () => _deleteTransaction(transaction.id!),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditScreen()),
          );
          if (result == true) _loadData();
        },
        label: const Text('Tambah'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: const Color(0xFF2563EB), // Primary Blue
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}