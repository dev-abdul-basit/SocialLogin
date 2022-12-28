import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../components/app_bar_header.dart';
import '../../components/custom_btm_bar.dart';
import '../../components/primary_button.dart';
import '../../constants.dart';
import '../../enum.dart';
import 'package:dio/dio.dart';
import '../../helper/global_config.dart';
import '../../models/user_model.dart';
import '../notifications/notifications_screen.dart';
import 'package:data_table_2/data_table_2.dart';

import 'package:intl/intl.dart' as intl;

class PortfolioScreen extends StatefulWidget {
  static String routeName = "/portfolio";
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  var isLoading = false;
  //Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');

  var userData = [];
  List<UserModel> userModel = <UserModel>[];
//API
  var coinLists;
  var _listCoin = [];
  // final formatter = intl.NumberFormat.decimalPattern();
  final formatter = intl.NumberFormat("#,##0.0######"); // for price change
  final percentageFormat = intl.NumberFormat("##0.0#"); // for price change
  Timer? _timer;
  int _itemPerPage = 1, _currentMax = 10;
   bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  void refreshWithTimer(_startTime, runTimer) {
    // isTimerRun = true;
    const oneMin = Duration(minutes: 1);
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (runTimer == false) {
        timer.cancel();
        print('Timer turned off');
      } else {
        if (_startTime == 0) {
          getCoinList();
          // refreshWithTimer(30, true);
        } else {
          // setState(() {
          setState(() {
            _startTime--;

            print("Timer $_startTime");
          });
        }
      }
    });
  }

  getCoinList() async {
    Dio dio = Dio();
    Response response;
    try {
      response = await dio.get(
          "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=$_itemPerPage&sparkline=false");
      print("Response data : ${response.data}");
      // _listCoin = _response.data;
      if (_listCoin == null) {
        _listCoin = List.generate(10, (i) => response.data[i]);
      } else {
        int j = 0;
        for (int i = _currentMax; i < _currentMax + 10; i++) {
          _listCoin.add(response.data[j]);
          j++;
        }
      }
      print("Success");
      // updatePrice();
      setState(() {
        
      });
      _isLoading = false;

      setState(() {});
    } on DioError catch (e) {
      String errorMessage = e.response!.data.toString();
      print("Error message : $errorMessage");
      switch (e.type) {
        case DioErrorType.connectTimeout:
          break;
        case DioErrorType.sendTimeout:
          break;
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.response:
          errorMessage = e.response!.data["error"];
          break;
        case DioErrorType.cancel:
          break;
        case DioErrorType.other:
          break;
      }
      _isLoading = false;
      setState(() {});
    }
  }

  _getMoreData() {
    print("Load more data");
    _itemPerPage = _itemPerPage + 1;
    _currentMax = _currentMax + 10;
    getCoinList();
  }

//field for dialog

// Function to calculate Profit.
  double profit(double cp, bp) {
    double profit = bp - cp;
    return profit;
  }

  // Function to calculate Loss.
  double loss(double cp, bp) {
    double loss = cp - bp;
    return loss;
  }

  @override
  void initState() {
    super.initState();

    user = _auth.currentUser;
    if (user != null) {
      getCurrentUser();
      //GETTING COINS
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
      getCoinList();
    } else {
      print('No User Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: _isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                CustomAppBar(
                  notiPress: () {
                    Navigator.pushNamed(context, NotificationScreen.routeName);
                  },
                  image: box!.get('photoUrl') == 'empty'
                      ? userImage
                      : box!.get('photoUrl'),
                  name: box!.get('name') == 'empty' ? '' : box!.get('name'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: DataTable2(
                      headingRowColor: MaterialStateProperty.all(kPrimaryColor),
                      headingTextStyle: const TextStyle(color: kPrimaryBGColor),
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      showBottomBorder: true,

                      //minWidth: 600,
                      columns: [
                        DataColumn2(
                          size: ColumnSize.L,
                          //onSort: (columnIndex, ascending) {},
                          label: Row(
                            children: [
                              const Text('Pair/Vol'),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.compare_arrows_outlined,
                              //     color: kPrimaryBGColor,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const DataColumn2(
                          size: ColumnSize.M,
                          label: Text('Buy Price'),
                        ),
                        const DataColumn2(
                          size: ColumnSize.M,
                          label: Text('Current Price'),
                        ),
                        const DataColumn2(
                          size: ColumnSize.M,
                          label: Text('Profit/Loss'),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        userModel.length,
                        (index) => DataRow(
                          cells: [
                            //pair-vol
                            DataCell(
                              Container(
                                // height: 50,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                // margin: EdgeInsets.symmetric(vertical: 5),

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_listCoin[0]['symbol'].toUpperCase()}/USD",
                                          style: const TextStyle(
                                            color: kPrimaryBGColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        (_listCoin[0]['price_change_24h'] > 0)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                      Icons.arrow_drop_up_sharp,
                                                      color: Colors.green[600]),
                                                  Text(
                                                    // "${_listCoin[i]['price_change_24h']}",
                                                    (_listCoin[0][
                                                                'current_price'] <
                                                            2)
                                                        ? formatter.format(
                                                            _listCoin[0][
                                                                'price_change_24h'])
                                                        : percentageFormat
                                                            .format(_listCoin[0]
                                                                [
                                                                'price_change_24h']),
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11),
                                                  ),
                                                  Text(
                                                    " (${percentageFormat.format(_listCoin[0]['price_change_percentage_24h'])}%)",
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      color: Colors.red),
                                                  Text(
                                                    // "${_listCoin[i]['price_change_24h']}",
                                                    (_listCoin[0][
                                                                'current_price'] <
                                                            2)
                                                        ? formatter.format(
                                                            _listCoin[0][
                                                                'price_change_24h'])
                                                        : percentageFormat
                                                            .format(_listCoin[0]
                                                                [
                                                                'price_change_24h']),
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10.5),
                                                  ),
                                                  Text(
                                                    " (${percentageFormat.format(_listCoin[0]['price_change_percentage_24h'])}%)",
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                    //  Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            //Buy Price
                            DataCell(
                              Text(
                                "\$ ${userModel[index].price2}",
                                style: const TextStyle(
                                    fontSize: 13.5, color: kPrimaryBGColor),
                              ),
                            ),
                            //Current Price
                            DataCell(
                              Container(
                                width: 80,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "\$ ${formatter.format(_listCoin[0]['current_price'])}",
                                        style: const TextStyle(
                                            fontSize: 13.5,
                                            color: kPrimaryBGColor),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      children: [
                                        const Text("High",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: kPrimaryBGColor)),
                                        const Spacer(),
                                        Text(
                                          "\$${_listCoin[0]['high_24h']}",
                                          style: const TextStyle(
                                              fontSize: 9, color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Low",
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: kPrimaryBGColor)),
                                        const Spacer(),
                                        Text(
                                          "\$${_listCoin[0]['low_24h']}",
                                          style: const TextStyle(
                                              fontSize: 9, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Profit Loss
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                // margin: EdgeInsets.symmetric(vertical: 5),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (userModel[index].price2 != '--')
                                      if (_listCoin[0]['current_price'] <
                                          double.parse(userModel[index].price2))
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "\$${profit(_listCoin[0]['current_price'], double.parse(userModel[index].price2)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  fontSize: 13.5,
                                                  color: kPrimaryBGColor),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.arrow_drop_up_sharp,
                                                    color: Colors.green[600]),
                                                Text(
                                                  ((profit(
                                                                  _listCoin[0][
                                                                      'current_price'],
                                                                  double.parse(
                                                                      userModel[
                                                                              index]
                                                                          .price2)) /
                                                              _listCoin[0][
                                                                  'current_price']) *
                                                          100)
                                                      .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.green),
                                                ),
                                                const Text(
                                                  " %",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      else if (_listCoin[0]['current_price'] >
                                          double.parse(userModel[index].price2))
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "\$${loss(_listCoin[0]['current_price'], double.parse(userModel[index].price2)).toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                  fontSize: 13.5,
                                                  color: kPrimaryBGColor),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    Icons.arrow_drop_down_sharp,
                                                    color: Colors.red[600]),
                                                Text(
                                                  ((loss(
                                                                  _listCoin[0][
                                                                      'current_price'],
                                                                  double.parse(
                                                                      userModel[
                                                                              index]
                                                                          .price2)) /
                                                              _listCoin[0][
                                                                  'current_price']) *
                                                          100)
                                                      .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.red),
                                                ),
                                                const Text(
                                                  " %",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                  ],
                                ),
                              ),
                            ),
                            //Edit
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.portfolio),
    );
  }
  //Get Users

  Future<void> getCurrentUser() async {
    _databaseReference.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      userData.clear();
      userModel.clear();

      for (var data in snapshot.children) {
        userData.add(data.value);
      }
      if (mounted) {
        setState(() {
          if (snapshot.exists && userData.isNotEmpty) {
            for (int x = 0; x < userData.length; x++) {
              if (userData[x]['id'] == user!.uid.toString()) {
                String id = userData[x]['id'].toString();
                String name = userData[x]['userName'];
                String phone = userData[x]['phone'];
                String email = userData[x]['email'];

                String photoUrl = userData[x]['photoUrl'];
                String status = userData[x]['status'];
                String token = userData[x]['token'];
                String price2 = userData[x]['price2'];
                String profitLoss = userData[x]['profitLoss'];
                String plStatus = userData[x]['plStatus'];

                userModel.add(UserModel.editwithId(
                  id,
                  name,
                  phone,
                  email,
                  photoUrl,
                  status,
                  token,
                  price2,
                  profitLoss,
                  plStatus,
                ));
              }
            }
            isLoading = true;
          } else {
            isLoading = false;
          }
        });
      }
    });
  }
}
