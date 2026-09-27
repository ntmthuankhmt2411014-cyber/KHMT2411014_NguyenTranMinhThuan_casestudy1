import 'package:flutter/material.dart';
import 'trang_giao_dich.dart';
import 'them_giao_dich.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeContent(),
    Center(child: Text('Giao dịch', style: TextStyle(fontSize: 24))),
    Center(child: Text('Thống kê', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 36),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF263238),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(),
              const SizedBox(height: 20),
              const BalanceCard(),
              const SizedBox(height: 24),
              const SummarySection(),
              const SizedBox(height: 32),
              const TransactionHeader(),
              const SizedBox(height: 12),
              const TransactionList(),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 32),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Quản lý thu chi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 32),
            ),
            Positioned(
              right: 2,
              top: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 330,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4D8CF7),
            Color(0xFF1769E0),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'SỐ DƯ HIỆN TẠI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.visibility, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  '5.000.000 đ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _dot(),
                    const SizedBox(width: 10),
                    _dot(),
                    const SizedBox(width: 10),
                    _dot(),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        shape: BoxShape.circle,
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SummaryCard(
            title: 'TỔNG THU NHẬP',
            amount: '8.000.000 đ',
            icon: Icons.arrow_downward,
            iconColor: Color(0xFF2EAD4B),
            backgroundColor: Color(0xFFEAF8EB),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: SummaryCard(
            title: 'TỔNG CHI TIÊU',
            amount: '3.000.000 đ',
            icon: Icons.arrow_upward,
            iconColor: Color(0xFFE53935),
            backgroundColor: Color(0xFFFFEFF0),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor.withOpacity(0.18),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Giao dịch gần đây',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1769E0),
            ),
          ),
        ),
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  static const List<TransactionData> transactions = [
    TransactionData(
      title: 'Ăn trưa',
      category: 'Ăn uống',
      date: '03/09/2024',
      amount: '-50.000 đ',
      icon: Icons.restaurant,
      color: Color(0xFFFF6D00),
    ),
    TransactionData(
      title: 'Xăng xe',
      category: 'Di chuyển',
      date: '03/09/2024',
      amount: '-100.000 đ',
      icon: Icons.directions_car,
      color: Color(0xFF2196F3),
    ),
    TransactionData(
      title: 'Lương tháng 9',
      category: 'Thu nhập',
      date: '01/09/2024',
      amount: '+8.000.000 đ',
      icon: Icons.attach_money,
      color: Color(0xFF2EAD4B),
    ),
    TransactionData(
      title: 'Mua sắm',
      category: 'Mua sắm',
      date: '31/08/2024',
      amount: '-300.000 đ',
      icon: Icons.shopping_cart,
      color: Color(0xFF9C27B0),
    ),
    TransactionData(
      title: 'Học phí',
      category: 'Giáo dục',
      date: '30/08/2024',
      amount: '-500.000 đ',
      icon: Icons.school,
      color: Color(0xFF009688),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          );
        },
        itemBuilder: (context, index) {
          return TransactionItem(
            transaction: transactions[index],
          );
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionData transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // "amount" đang có dạng "-50.000 đ" hoặc "+8.000.000 đ"
        // -> tách dấu +/- để biết là Thu nhập hay Chi tiêu,
        // rồi bỏ hết ký tự không phải số để lấy phần số tiền thuần.
        final bool isIncome = transaction.amount.trim().startsWith('+');
        final String amountOnly =
        transaction.amount.replaceAll(RegExp(r'[^0-9.]'), '');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionFormScreen(
              title: 'Sửa giao dịch',
              initialType:
              isIncome ? TransactionType.income : TransactionType.expense,
              initialCategory: categories.firstWhere(
                    (c) => c.name == transaction.category,
                orElse: () => categories.first,
              ),
              initialAmount: amountOnly,
              initialDate: transaction.date,
              initialNote: transaction.title,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: transaction.color,
              child: Icon(
                transaction.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          transaction.category,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        transaction.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              transaction.amount,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: transaction.amount.startsWith('+')
                    ? const Color(0xFF2EAD4B)
                    : const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionData {
  final String title;
  final String category;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;

  const TransactionData({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
  });
}