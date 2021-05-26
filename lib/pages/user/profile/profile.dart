import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_form_cubit.dart'
    as efCubit;
import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_history_cubit.dart'
    as ehCubit;
import 'package:fantasy_cricket/pages/user/profile/cubits/profile_cubit.dart';
import 'package:fantasy_cricket/pages/user/profile/earning_history.dart';
import 'package:fantasy_cricket/pages/user/profile/exchange_form.dart';
import 'package:fantasy_cricket/pages/user/profile/exchange_history.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/strings/ad_units.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Profile extends StatefulWidget {
  final ProfileCubit _cubit;

  Profile(this._cubit);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  @override
  void initState() {
    super.initState();
    createAndLoadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget._cubit,
      builder: (BuildContext context, CubitState state) {
        if (state == CubitState.loading) {
          return Loading();
        } else if (state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return ListView(
            padding: Paddings.pagePadding,
            children: [
              getUsername(context),
              SizedBox(height: 40),
              getProfileInfo(
                context: context,
                title: 'Total Earned Chips',
                value: widget._cubit.user.earnedChips.toString(),
                buttonText: 'Earning History',
                page: EarningHistory(widget._cubit.user),
                iconData: Icons.history_outlined,
              ),
              Divider(height: 50),
              getProfileInfo(
                context: context,
                title: 'Total Exchanged Chips',
                value: widget._cubit.getExchangedChips().toString(),
                buttonText: 'Exchange History',
                page: ExchangeHistory(
                    ehCubit.ExchangeHistoryCubit(widget._cubit.user.id)),
                iconData: Icons.history_outlined,
              ),
              Divider(height: 50),
              getProfileInfo(
                context: context,
                title: 'Remaining Chips',
                value: widget._cubit.user.remainingChips.toString(),
                buttonText: 'Exchange Chips',
                page:
                    ExchangeForm(efCubit.ExchangeFormCubit(widget._cubit.user)),
                iconData: Icons.money_outlined,
              ),
              Divider(height: 50),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  Text getUsername(BuildContext context) {
    return Text(
      widget._cubit.user.username,
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: ColorPallate.ebonyClay,
        shadows: [
          Shadow(
            blurRadius: 1,
            offset: Offset(1, 1),
            color: ColorPallate.pomegranate,
          ),
        ],
      ),
    );
  }

  Column getProfileInfo({
    BuildContext context,
    String title,
    String value,
    String buttonText,
    Widget page,
    IconData iconData,
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
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => page,
                ));
            widget._cubit.refreshUi();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconData,
                color: ColorPallate.ebonyClay,
              ),
              SizedBox(width: 3),
              Text(
                buttonText,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void createAndLoadAd() {
    _bannerAd = BannerAd(
      adUnitId: banner,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: AdListener(
        onAdLoaded: (_) {
          print('Banner ad loaded');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }
}
