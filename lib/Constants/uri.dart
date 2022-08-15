// ignore_for_file: constant_identifier_names

class URI {
  URI._();

  //192.168.0.104
  //192.168.1.35
  static const String BASE_URI = 'http://192.168.1.35:5000/';
  //Account
  static const String USER_LOGIN = 'api/v1/Account/Login';
  static const String USER_REGISTER = 'api/v1/Account/RegisterCustomer';
  static const String GET_CODE_VERIFY_PHONE = 'api/v1/Account/VerifyPhone?phoneNum=';
  static const String GET_CODE_VERIFY_PHONE_FORGOT_PASSWORD = 'api/v1/Account/VerifyPhoneChangePassword?phoneNum=';
  static const String GET_CODE_VERIFY_EMAIL = 'api/v1/Account/GetCodeVerifyEmail?email=';
  static const String CHANGE_PHONE_NUMBER = 'api/v1/Account/ChangePhoneNumber';
  static const String CHANGE_EMAIL = 'api/v1/Account/ChangeOrAddEmail';
  static const String GET_LOGGED_IN_USER =  'api/v1/Customer/GetCustomer?id=';
  static const String CHANGE_CUSTOMER_INFO = 'api/v1/Customer/CustomerChangeInfo';
  static const String CHANGE_PASSWORD = 'api/v1/Account/ChangePassword';
  static const String FORGOT_PASSWORD = 'api/v1/Account/CheckCodeVerifyForPhone';
  static const String CHECK_CHANGE_INFO = 'api/v1/Account/CheckChangeInfo';

  //Product
  static const String GET_PRODUCT = 'api/v1/Product/GetAllProduct';
  static const String GET_CATEGORY = 'api/v1/Product/GetAllCategories';
  static const String GET_SUB_CATEGORY = 'api/v1/Product/GetAllSubCategoriesbyCategoryId';
  static const String GET_UNIT = 'api/v1/Product/GetAllUnit';
  static const String GET_DISCOUNT = 'api/v1/Product/GetAllDiscount';

  static const String GET_PROVINCES = 'api/v1/Support/GetAllProvince';
  static const String GET_DISTRICTS_BY_PROVINCE =
      'api/v1/Support/GetAllDistrictbyProvince?id=';
  static const String GET_CWTS_BY_DISTRICT =
      'api/v1/Support/GetAllCWTbyDistrict?id=';
  static const String GET_LOCATION_BY_CWT =
      'api/v1/Support/GetLocationByCwtid?id=';

  //order
  static const String ADD_ORDER = 'api/v1/Order/AddOrder';
  static const String GET_ORDER = 'api/v1/Order/GetAllOrderIncludeOderDetailbyCustomerId?id=';
}
