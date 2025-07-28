import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Bills'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildBillingSummary(),
            const SizedBox(height: 16),
            _buildBillingHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingSummary() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Balance', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('₹1,250.00', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryItem('Due Date', 'Aug 25, 2025'),
                const SizedBox(width: 20),
                _buildSummaryItem('Last Payment', '₹1,100.00'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.payment),
                label: const Text('Pay Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBillingHistory() {
    final bills = [
      {'date': 'Jul 10, 2025', 'amount': '₹1,100.00', 'status': 'Paid'},
      {'date': 'Jun 10, 2025', 'amount': '₹1,050.00', 'status': 'Paid'},
      {'date': 'May 10, 2025', 'amount': '₹980.00', 'status': 'Paid'},
      {'date': 'Apr 10, 2025', 'amount': '₹920.00', 'status': 'Paid'},
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: bills.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => _buildBillItem(bills[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillItem(Map bill) {
    final String status = bill['status'] ?? '';
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.receipt, color: Colors.deepPurple),
      ),
      title: Text(bill['date'] ?? ''),
      subtitle: Text(bill['amount'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Chip(
        label: Text(status),
        backgroundColor: status == 'Paid'
          // ignore: deprecated_member_use
          ? Colors.green.withOpacity(0.2)
          // ignore: deprecated_member_use
          : Colors.red.withOpacity(0.2),
        labelStyle: TextStyle(
          color: status == 'Paid' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
