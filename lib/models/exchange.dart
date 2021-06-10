import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_ID_KEY = 'userId';
const String USERNAME_KEY = 'username';
const String PAYMENT_USERNAME_KEY = 'paymentUsername';
const String MEMO_KEY = 'memo';
const String CHIPS_KEY = 'chips';
const String TAKA_KEY = 'taka';
const String STEEM_KEY = 'steem';
const String PAYMENT_TYPE_KEY = 'paymentType';
const String MOBILE_KEY = 'mobile';
const String STATUS_KEY = 'status';
const String DETAILS_KEY = 'details';
const String DATE_TIME_KEY = 'dateTime'; 

class Exchange {
  String id;
  String userId;
  String username;
  String paymentUsername;
  String memo;
  int chips;
  double taka;
  double steem;
  String paymentType;
  String mobile;
  String status;
  String details;
  Timestamp dateTime;

  Exchange({
    this.id,
    this.userId,
    this.username,
    this.paymentUsername,
    this.memo,
    this.chips,
    this.taka,
    this.steem,
    this.paymentType,
    this.mobile,
    this.status,
    this.details,
    this.dateTime,
  });

  Exchange.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    userId = doc[USER_ID_KEY];
    username = doc[USERNAME_KEY];
    paymentUsername = doc[PAYMENT_USERNAME_KEY];
    memo = doc[MEMO_KEY];
    chips = doc[CHIPS_KEY];
    taka = doc[TAKA_KEY];
    steem = doc[STEEM_KEY];
    paymentType = doc[PAYMENT_TYPE_KEY];
    mobile = doc[MOBILE_KEY];
    status = doc[STATUS_KEY];
    details = doc[DETAILS_KEY];
    dateTime = doc[DATE_TIME_KEY];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      USER_ID_KEY: userId,
      USERNAME_KEY: username,
      PAYMENT_USERNAME_KEY: paymentUsername,
      MEMO_KEY: memo,
      CHIPS_KEY: chips,
      TAKA_KEY: taka,
      STEEM_KEY: steem,
      PAYMENT_TYPE_KEY: paymentType,
      MOBILE_KEY: mobile,
      STATUS_KEY: status,
      DETAILS_KEY: details,
      DATE_TIME_KEY: dateTime,
    };
  }
}
