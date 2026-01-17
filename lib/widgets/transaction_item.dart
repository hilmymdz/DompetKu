import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';
    
    // WARNA MODERN VIBRANT
    // Emerald Green vs Rose Red
    final color = isExpense ? const Color(0xFFE11D48) : const Color(0xFF059669); 
    final iconBgColor = isExpense ? const Color(0xFFFFE4E6) : const Color(0xFFD1FAE5);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Radius sedikit lebih kotak agar modern
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Shadow sangat halus
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBgColor, 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isExpense ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded, // Icon panah modern
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 16,
            color: Color(0xFF1E293B), // Slate 800
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            DateFormat('dd MMM yyyy').format(transaction.date),
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                  .format(transaction.amount),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.more_vert_rounded, size: 20, color: Colors.grey[400]),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}