import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_history_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/exchange_util.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeHistory extends StatelessWidget {
  final ExchangeHistoryCubit _cubit;

  ExchangeHistory(this._cubit);
  
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
            appBar: AppBar(title: Text('Exchange History')),
            body: ListView.builder(
              padding: Paddings.pagePadding,
              itemCount: _cubit.exchanges.length,
              itemBuilder: (BuildContext context, int i) {
                return getExchangeHistoryRow(_cubit.exchanges[i]);
              },
            ),
          );
        }
      },
    );
  }

  Column getExchangeHistoryRow(Exchange exchange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chips: ${exchange.chips}'),
        SizedBox(height: 5),
        Text('Payment Type: ${exchange.paymentType}'),
        SizedBox(height: 5),
        Text('Mobile: ${exchange.mobile}'),
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
        SizedBox(height: 5),
        Text('Details: ${exchange.details}'),
        Divider(),
      ],
    );
  }

  Text _getExchangeStatus(String exchangeStatus) {
    Color textColor;

    if(exchangeStatus == ExchangeStatuses.processing) {
      textColor = Colors.yellow;
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
