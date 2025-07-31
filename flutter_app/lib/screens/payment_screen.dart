import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/cart_provider.dart';

class PaymentScreen extends StatefulWidget {
  final List<Game> cartItems;

  const PaymentScreen({super.key, required this.cartItems});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  String selectedPaymentMethod = 'card';
  bool saveCard = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Color scheme
  final Color darkBackground = Color(0xFF0A0E21);
  final Color primaryPink = Color(0xFFFFD9F5);
  final Color accentBlue = Color(0xFF60D3F3);
  final Color secondaryPink = Color(0xFFFAB4E5);
  final Color cardBackground = Color(0xFF1a1a1a);
  final Color textColor = Color(0xFFffffff);
  final Color subtextColor = Color(0xFFb0b0b0);

  // Calculate total price
  double get totalPrice {
    double total = 0;
    for (var item in widget.cartItems) {
      total += item.price;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: darkBackground,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                'Payment',
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentBlue.withOpacity(0.1),
                      primaryPink.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[800]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryPink.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${widget.cartItems.length} ${widget.cartItems.length == 1 ? 'item' : 'items'}',
                                    style: TextStyle(
                                      color: primaryPink,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            ...widget.cartItems
                                .map((game) => Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white10,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                game.image_url,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(
                                                    Icons.videogame_asset,
                                                    color: Colors.white54,
                                                    size: 24,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  game.name,
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 2),
                                                if (game.category != null &&
                                                    game.category!.isNotEmpty)
                                                  Text(
                                                    game.category![0],
                                                    style: TextStyle(
                                                      color: accentBlue,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '\$${game.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: primaryPink,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            if (widget.cartItems.length > 1) ...[
                              Divider(color: Colors.grey[700], height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      color: subtextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryPink, secondaryPink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryPink.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.payment,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Amount to Pay',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '\$${totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Game${widget.cartItems.length > 1 ? 's' : ''} Purchase',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentBlue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Secure',
                              style: TextStyle(
                                fontSize: 12,
                                color: accentBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPaymentOption(
                              'card',
                              'Credit Card',
                              Icons.credit_card,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildPaymentOption(
                              'wallet',
                              'Wallet',
                              Icons.account_balance_wallet,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildPaymentOption(
                              'bank',
                              'Bank',
                              Icons.account_balance,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: selectedPaymentMethod == 'card' ? null : 0,
                        child: selectedPaymentMethod == 'card'
                            ? _buildCardDetailsSection()
                            : SizedBox.shrink(),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: selectedPaymentMethod != 'card' ? null : 0,
                        child: selectedPaymentMethod != 'card'
                            ? _buildOtherPaymentSection()
                            : SizedBox.shrink(),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accentBlue, Color(0xFF4DC4E8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: accentBlue.withOpacity(0.4),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            if (selectedPaymentMethod == 'card') {
                              if (_formKey.currentState?.validate() ?? false) {
                                _processPayment();
                              }
                            } else {
                              _processPayment();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Pay \$${totalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[800]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentBlue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.verified_user,
                                color: accentBlue,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Secure Payment',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Your payment is protected with 256-bit SSL encryption',
                                    style: TextStyle(
                                      color: subtextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    bool isSelected = selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? accentBlue.withOpacity(0.15) : cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentBlue : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentBlue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentBlue.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? accentBlue : subtextColor,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? accentBlue : subtextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailsSection() {
    return Container(
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card, color: accentBlue, size: 24),
              SizedBox(width: 12),
              Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildTextField(
            controller: _cardNumberController,
            label: 'Card Number',
            hint: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.credit_card,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter card number';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildTextField(
            controller: _cardHolderController,
            label: 'Cardholder Name',
            hint: 'John Doe',
            prefixIcon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter cardholder name';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _expiryController,
                  label: 'Expiry Date',
                  hint: 'MM/YY',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_today,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.security,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: saveCard,
                  onChanged: (value) {
                    setState(() {
                      saveCard = value ?? false;
                    });
                  },
                  activeColor: accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Save this card for future payments',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherPaymentSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.0),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accentBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              selectedPaymentMethod == 'wallet'
                  ? Icons.account_balance_wallet
                  : Icons.account_balance,
              size: 48,
              color: accentBlue,
            ),
          ),
          SizedBox(height: 20),
          Text(
            selectedPaymentMethod == 'wallet'
                ? 'Digital Wallet Payment'
                : 'Bank Transfer Payment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            selectedPaymentMethod == 'wallet'
                ? 'You will be redirected to complete the payment securely'
                : 'Banking details will be provided after confirmation',
            style: TextStyle(color: subtextColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: textColor, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: subtextColor, size: 20)
            : null,
        labelStyle: TextStyle(color: subtextColor, fontSize: 14),
        hintStyle: TextStyle(color: subtextColor.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[600]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Color(0xFF2a2a2a),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  String _getGameCodeFromDB(String gameName) {
    final gameData = {
      "Microsoft Flight Simulator (2020)": [
        "mfsA9K3X2T",
        "mfsB7YQ1NZ",
        "mfsL4W8V0E",
        "mfsT3RM6PA",
        "mfsC2Z8DNL",
        "mfsX1QWER9",
        "mfsU5VBNM2",
        "mfsK8HJ7TR",
        "mfsZ6PLM3A",
        "mfsD9XC4YU"
      ],
      "Forza Horizon 5": [
        "fhA7X9T2PQ",
        "fhM3L8WZ1E",
        "fhK5Q2N7YD",
        "fhZ6RP1XMB",
        "fhB8VC3JNL",
        "fhD9YU4TWE",
        "fhL1MK7ZQA",
        "fhU2XN9EPV",
        "fhC3WQ6RBT",
        "fhT0JZ8MLN"
      ],
      "Left 4 Dead 2": [
        "lfdtX9A7Q1",
        "lfdtM3BZ8K",
        "lfdtT6Y2WP",
        "lfdtC7VNX0",
        "lfdtL4QEM9",
        "lfdtD1KJZ5",
        "lfdtU8RPNW",
        "lfdtZ3XCV6",
        "lfdtB5WQTA",
        "lfdtY0MLN2"
      ],
      "Grand Theft Auto V": [
        "gtaX7P2M9L",
        "gtaL4WQ8ZK",
        "gtaT1CVN6YE",
        "gtaM3BZ5XQA",
        "gtaY9JRL2NT",
        "gtaB6WEM0KZ",
        "gtaD8XCNV1P",
        "gtaU2LZQ7WB",
        "gtaZ5MKJE4T",
        "gtaC3YPT9XN"
      ],
      "Ready or Not": [
        "rotA7X2M9Q",
        "rotL8WZ1KJ",
        "rotT3PNV6C",
        "rotM9QE5XB",
        "rotY2CJK7L",
        "rotB6WTA0NZ",
        "rotX1VRD8P",
        "rotD4MLQZ5E",
        "rotU3NEK9WY",
        "rotZ5XC7BTL"
      ],
      "Euro Truck Simulator 2": [
        "etsX9L2MQA",
        "etsB7WZ1TVC",
        "etsK5JPN8RY",
        "etsL3QXEM0D",
        "etsT6YCB9WN",
        "etsM2ZRJ4KP",
        "etsD1VXQ7NE",
        "etsU8PLMW3X",
        "etsC4WBTY9N",
        "etsZ0NKJE5A"
      ],
      "Cyberpunk 2077": [
        "cpX7L9MA2Q",
        "cpT3WZ1VKC",
        "cpB6QPN8RYD",
        "cpM5XEL0JNT",
        "cpY2CVBN9WA",
        "cpD8ZRJ4KXE",
        "cpU1WQTY7LM",
        "cpZ4PMJN3VX",
        "cpK9XNE5LTA",
        "cpC0BTYW6MQ"
      ],
      "Hollow Knight": [
        "hkA9X7M2QL",
        "hkT4WZ1CBK",
        "hkL8PNV6YQ",
        "hkM3QE5XND",
        "hkB6JRKZ0W",
        "hkY2CVTN9PA",
        "hkD1XEM7QLK",
        "hkU5WQZ3NYX",
        "hkZ0PLMJ4TE",
        "hkC7BTYVX9N"
      ],
      "Blasphemous": [
        "blaX7M2Q9L",
        "blaT4Z1WCKE",
        "blaL8PNV6YQ",
        "blaM3XE5QND",
        "blaB6JR0KZW",
        "blaY2CV9TNA",
        "blaD1EM7XLK",
        "blaU5WQ3ZNY",
        "blaZ0PMJ4TE",
        "blaC7BTVX9N"
      ],
      "Alien: Isolation": [
        "asX9M2QL7T",
        "asT4WZC1BK",
        "asL8PNY6QV",
        "asM3QE0XND",
        "asB6JRKZW9",
        "asY2CVTNA5",
        "asD1EMX7LK",
        "asU5WQZ3NY",
        "asZ0PM4JTE",
        "asC7BT9VXN"
      ],
    };
    final codes = gameData[gameName] ?? [];
    return codes.isNotEmpty ? codes[0] : _generateGameKey();
  }

  String _generateGameKey() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String key = '';

    for (int i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) {
        key += '-';
      }
      key += chars[(random + i) % chars.length];
    }

    return key;
  }

  Future<Map<String, String>> _saveGamesToFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      Map<String, String> gameCodes = {};

      for (Game game in widget.cartItems) {
        String gameCode = _getGameCodeFromDB(game.name);
        gameCodes[game.name] = gameCode;

        await firestore.collection('purchased_games').add({
          'userId': user.uid,
          'game_id': game.id,
          'name': game.name,
          'image_url': game.image_url,
          'price': game.price,
          'category': game.category,
          'description': game.description,
          'code': gameCode,
          'purchase_date': FieldValue.serverTimestamp(),
          'transaction_id': '#TXN${DateTime.now().millisecondsSinceEpoch}',
        });
      }

      return gameCodes;
    } catch (e) {
      print('Lỗi khi lưu game vào Firestore: $e');
      throw e;
    }
  }

  void _processPayment() async {
    String gameNames = widget.cartItems.length == 1
        ? widget.cartItems.first.name
        : '${widget.cartItems.length} games';

    try {
      Map<String, String> gameCodes = await _saveGamesToFirestore();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentBlue.withOpacity(0.3),
                          primaryPink.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.check_circle, color: accentBlue, size: 48),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Bạn đã mua thành công $gameNames.',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtextColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF2a2a2a),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: accentBlue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.vpn_key, color: accentBlue, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Game Codes:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...gameCodes.entries
                            .map((entry) => Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          entry.key,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: subtextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: primaryPink.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            entry.value,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: primaryPink,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mã game đã được lưu trong phần cài đặt!',
                    style: TextStyle(
                      fontSize: 12,
                      color: accentBlue,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentBlue, Color(0xFF4DC4E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/library');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Xem Thư Viện',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 24),
                  Text(
                    'Lỗi Thanh Toán',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Đã có lỗi xảy ra trong quá trình xử lý thanh toán. Vui lòng thử lại sau.',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtextColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentBlue, Color(0xFF4DC4E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Đóng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
