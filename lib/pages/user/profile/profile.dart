import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_form_cubit.dart' as efCubit;
import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_history_cubit.dart' as ehCubit;
import 'package:fantasy_cricket/pages/user/profile/cubits/profile_cubit.dart';
import 'package:fantasy_cricket/pages/user/profile/earning_history.dart';
import 'package:fantasy_cricket/pages/user/profile/exchange_form.dart';
import 'package:fantasy_cricket/pages/user/profile/exchange_history.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  final ProfileCubit _cubit;

  Profile(this._cubit);

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
          return  ListView(
              padding: Paddings.pagePadding,
              children: [
                getUsername(context),
                SizedBox(height: 30),

                getProfileInfo(
                  context: context,
                  title: 'Total Earned Chips',
                  value: _cubit.user.earnedChips.toString(),
                  buttonText: 'Earning History',
                  page: EarningHistory(_cubit.user),
                ),
                Divider(height: 50),

                getProfileInfo(
                  context: context,
                  title: 'Total Exchanged Chips',
                  value: _cubit.getExchangedChips().toString(),
                  buttonText: 'Exchanging History',
                  page: ExchangeHistory(
                    ehCubit.ExchangeHistoryCubit(_cubit.user.id)),
                ),
                Divider(height: 50),

                getProfileInfo(
                  context: context,
                  title: 'Remaining Chips',
                  value: _cubit.user.remainingChips.toString(),
                  buttonText: 'Exchange Chips',
                  page: ExchangeForm(efCubit.ExchangeFormCubit(_cubit.user)),
                ),
              ],
            
          );
        }
      },
    );
  }

  Text getUsername(BuildContext context) {
    return Text(
      _cubit.user.username,
      style: Theme.of(context).textTheme.headline3,
    );
  }

  Column getProfileInfo({
    BuildContext context,
    String title,
    String value,
    String buttonText,
    Widget page,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return page;
              },
            ));
            _cubit.refreshUi();
          },
          child: Text(
            buttonText,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
