// keys
const String USER_ID_KEY = 'userId';
const String CHIPS_KEY = 'chips';
const String PAYMENT_TYPE_KEY = 'paymentType';
const String MOBILE_KEY = 'mobile';
const String STATUS_KEY = 'status';
const String DETAILS_KEY = 'details';

class Exchange {
  String id;
  String userId;
  int chips;
  String paymentType;
  String mobile;
  String status;
  String details;

  Exchange({
    this.id,
    this.userId,
    this.chips,
    this.paymentType,
    this.mobile,
    this.status,
    this.details,
  });

  Exchange.fromMap(Map<String, dynamic> doc, String docId) {
    id = docId;
    userId = doc[USER_ID_KEY];
    chips = doc[CHIPS_KEY];
    paymentType = doc[PAYMENT_TYPE_KEY];
    mobile = doc[MOBILE_KEY];
    status = doc[STATUS_KEY];
    details = doc[DETAILS_KEY];
  }

  Map<String, dynamic> toMap() {
    return {
      USER_ID_KEY: userId,
      CHIPS_KEY: chips,
      PAYMENT_TYPE_KEY: paymentType,
      MOBILE_KEY: mobile,
      STATUS_KEY: status,
      DETAILS_KEY: details,
    };
  }
}
