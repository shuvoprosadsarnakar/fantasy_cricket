import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/pages/exchange/cubits/exchange_updater_cubit.dart' as euCubit;
import 'package:fantasy_cricket/pages/exchange/cubits/exchanges_list_cubit.dart';
import 'package:fantasy_cricket/pages/exchange/exchange_updater.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/exchange_statuses.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangesList extends StatelessWidget {
  final ExchangesListCubit _cubit;

  ExchangesList(this._cubit);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Exchanges List')),
            body: ListView.builder(
              padding: Paddings.pagePadding,
              itemCount: _cubit.exchanges.length,
              itemBuilder: (BuildContext context, int i) {
                return getExchangeRow(context, _cubit.exchanges[i]);
              },
            ),
          );
        }
      },
    );
  }

  InkWell getExchangeRow(BuildContext context, Exchange exchange) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chips: ${exchange.chips}'),
          SizedBox(height: 5),
          Text('Payment Type: ${exchange.paymentType}'),
          SizedBox(height: 5),

          if(exchange.paymentType != PaymentTypes.steem && 
            exchange.paymentType != PaymentTypes.binance)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Mobile: ${exchange.mobile}'),
                SizedBox(height: 5),
                Text('Taka: ${exchange.taka.toStringAsFixed(2)}')
              ],
            ),
          
          if(exchange.paymentType == PaymentTypes.steem ||
            exchange.paymentType == PaymentTypes.binance)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${exchange.paymentType} Username: '
                  '${exchange.paymentUsername}'),
                SizedBox(height: 5),
                Text('Steem: ${exchange.steem.toStringAsFixed(2)}'),
              ],
            ),
          
          if(exchange.paymentType == PaymentTypes.binance)
            Column(
              children: <Widget>[
                SizedBox(height: 5),
                Text('Memo: ${exchange.memo}'),
              ],
            ),
          
          SizedBox(height: 5),
          Text('Date & Time: ' + 
            exchange.dateTime.toDate().toString().substring(0, 16)),
          SizedBox(height: 5),
          Row(
            children: [
              Text('Status: '),
              _getExchangeStatus(exchange.status),
            ],
          ),
          if(exchange.details.isNotEmpty)
            SizedBox(height: 5),
          if(exchange.details.isNotEmpty) 
            Text('Details: ${exchange.details}'),
          Divider(),
        ],
      ),
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ExchangeUpdater(euCubit.ExchangeUpdaterCubit(exchange));
          },
        ));
        _cubit.refreshUi();
      },
    );
  }

  Text _getExchangeStatus(String exchangeStatus) {
    Color textColor;

    if(exchangeStatus == ExchangeStatuses.processing) {
      textColor = Colors.yellow.shade800;
    } else if(exchangeStatus == ExchangeStatuses.successfull) {
      textColor = Colors.green;
    } else {
      textColor = Colors.red;
    }

    return Text(
      exchangeStatus,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}

abstract class PaymentTypes {
  static final String bKash = 'bKash';
  static final String nagad = 'Nagad';
  static final String rocket = 'Rocket';
  static final String mobileRecharge = 'Mobile Recharge';
  static final String steem = 'Steem';
  static final String binance = 'Binance';
}
