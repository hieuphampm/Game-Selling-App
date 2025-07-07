import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  // Custom colors from your palette
  final Color primaryPink = Color(0xFFFFD9F5);
  final Color accentBlue = Color(0xFF60D3F3);
  final Color secondaryPink = Color(0xFFFAB4E5);
  final Color backgroundColor = Color(0xFF0D0D0D);

  // Sample transaction data
  List<Transaction> transactions = [
    Transaction(
      gameName: "Cyberpunk 2077",
      amount: 59.99,
      date: "2 days ago",
      status: "Completed",
    ),
    Transaction(
      gameName: "The Witcher 3",
      amount: 29.99,
      date: "1 week ago",
      status: "Completed",
    ),
    Transaction(
      gameName: "FIFA 24",
      amount: 69.99,
      date: "2 weeks ago",
      status: "Pending",
    ),
    Transaction(
      gameName: "Call of Duty MW3",
      amount: 79.99,
      date: "3 weeks ago",
      status: "Completed",
    ),
    Transaction(
      gameName: "Minecraft",
      amount: 26.95,
      date: "1 month ago",
      status: "Failed",
    ),
    Transaction(
      gameName: "Red Dead Redemption 2",
      amount: 39.99,
      date: "1 month ago",
      status: "Completed",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return _buildTransactionCard(transactions[index]);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    Color statusColor;

    switch (transaction.status) {
      case "Completed":
        statusColor = Colors.green;
        break;
      case "Pending":
        statusColor = Colors.orange;
        break;
      case "Failed":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Game Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.games, color: accentBlue, size: 24),
          ),

          SizedBox(width: 15),

          // Game Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.gameName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  transaction.date,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),

          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${transaction.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                transaction.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Transaction Model
class Transaction {
  final String gameName;
  final double amount;
  final String date;
  final String status;

  Transaction({
    required this.gameName,
    required this.amount,
    required this.date,
    required this.status,
  });
}

// Usage in your main app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment History Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PaymentHistoryScreen(),
    );
  }
}
