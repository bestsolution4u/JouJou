import 'package:flutter/material.dart';
import 'package:joujou_lounge/bloc_data/cart_bloc.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/cart_model.dart';
import 'package:joujou_lounge/screen/cart_screen.dart';
import 'package:joujou_lounge/screen/menu_screen.dart';
import 'package:joujou_lounge/widget/label_widget.dart';
import 'package:badges/badges.dart';

class MenuCartScreen extends StatefulWidget {
  final bool _showCart;

  MenuCartScreen(this._showCart);

  @override
  _MenuCartScreenState createState() => _MenuCartScreenState();
}

class _MenuCartScreenState extends State<MenuCartScreen> {
  bool _showCart, _isInitial = true;
  ScrollController _mainScrollController;
  CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _showCart = widget._showCart;
    _mainScrollController = ScrollController();
    _cartBloc = CartBloc.init();
    _cartBloc.fetchCartContents();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToInitial());
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            controller: _mainScrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: CartScreen(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: MenuScreen(),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  LabelButtonWidget(
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 36),
                      _onBackPressed),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: _cartBloc.cartContents,
                    builder: (context, snapshot) {
                      if (_showCart) {
                        return _buildMenuButton();
                      } else {
                        CartModel cart = snapshot.data;
                        return _buildCartButton(cart);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToInitial() {
    if (_mainScrollController.hasClients) {
      if (_isInitial) {
        double position = _mainScrollController.position.minScrollExtent;
        if (!_showCart)
          position = _mainScrollController.position.maxScrollExtent;
        _mainScrollController.animateTo(position,
            duration: Duration(milliseconds: 1), curve: Curves.fastOutSlowIn);
        _isInitial = false;
      }
    }
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  Widget _buildMenuButton() {
    return LabelButtonWidget(
        Icon(Icons.restaurant, color: Colors.white, size: 36), _openMenu);
  }

  void _openMenu() {
    _mainScrollController.animateTo(
        _mainScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
    setState(() {
      _showCart = !_showCart;
    });
  }

  Widget _buildCartButton(CartModel cart) {
    return LabelButtonWidget(Badge(
      badgeContent: Text(cart != null ? "${cart.getTotalItemCount()}" : "0", style: TextStyle(color: Colors.white, fontSize: 18)),
      badgeColor: Styles.badgeColor,
      child: Icon(Icons.shopping_cart, color: Colors.white, size: 36),
    ), _openCart);
  }

  void _openCart() {
    _mainScrollController.animateTo(
        _mainScrollController.position.minScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
    setState(() {
      _showCart = !_showCart;
    });
  }
}
