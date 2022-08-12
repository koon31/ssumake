import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/API/cwt_API.dart';
import 'package:ssumake/API/district_API.dart';
import 'package:ssumake/API/update_user_API.dart';
import 'package:ssumake/Model/Location/location_model.dart';
import 'package:ssumake/Model/User/update_user_model.dart';

import '../API/location_API.dart';
import '../API/login_API.dart';
import '../API/province_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Constants/global_var.dart';
import '../Model/Location/cwt_model.dart';
import '../Model/Location/district_model.dart';
import '../Model/Location/province_model.dart';
import '../Model/User/user_model.dart';

class UpdateUserBody extends StatefulWidget {
  const UpdateUserBody({Key? key}) : super(key: key);

  @override
  State<UpdateUserBody> createState() => _UpdateUserBodyState();
}

class _UpdateUserBodyState extends State<UpdateUserBody> {
  final GlobalKey<FormState> _formKeyUpdate = GlobalKey<FormState>();

  Gender _gender = Gender.Male;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  //Dropdown menu Location
  List<DropdownMenuItem<ProvinceModel>> _valueProvinceList =
      List<DropdownMenuItem<ProvinceModel>>.empty();
  List<ProvinceModel> _provinceList = List<ProvinceModel>.empty();

  List<DropdownMenuItem<DistrictModel>> _valueDistrictList =
      List<DropdownMenuItem<DistrictModel>>.empty();
  List<DistrictModel> _districtList = List<DistrictModel>.empty();

  List<DropdownMenuItem<CWTModel>> _valueCWTList =
      List<DropdownMenuItem<CWTModel>>.empty();
  List<CWTModel> _cwtList = List<CWTModel>.empty();

  //Location list
  late ProvinceModel _valueProvince = ProvinceModel.empty();
  late DistrictModel _valueDistrict = DistrictModel.empty();
  late CWTModel _valueCWT = CWTModel.empty();

  late UserModel user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getLoggedUserInfo();
      loadLocationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKeyUpdate,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: kDefaultPadding / 2 * 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.03),
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: const Icon(
                      Icons.person,
                      size: 140,
                    )),
                GestureDetector(
                  onTap: () =>
                      ShowModalBottomSheet.showCheckPassword(context, true),
                  child: Consumer<User>(builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 2.4,
                          vertical: kDefaultPadding / 2),
                      child: Container(
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding / 5 * 3),
                          child: IntrinsicHeight(
                            child: Row(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    right: kDefaultPadding / 5 * 3),
                                child: Icon(
                                  Icons.phone,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                value.user!.phoneNumber!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 17),
                              ),
                              const Spacer(),
                              const VerticalDivider(
                                  thickness: 1, color: Colors.grey),
                              const Text(
                                'Đổi SĐT',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 17),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () =>
                      ShowModalBottomSheet.showCheckPassword(context, false),
                  child: Consumer<User>(builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 2.4,
                          vertical: kDefaultPadding / 2),
                      child: Container(
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding / 5 * 3),
                          child: IntrinsicHeight(
                            child: Row(children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    right: kDefaultPadding / 5 * 3),
                                child: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                              ),
                              Text(
                                value.user!.email!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 17),
                              ),
                              const Spacer(),
                              const VerticalDivider(
                                  thickness: 1, color: Colors.grey),
                              const Text(
                                'Đổi Email',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 17),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                RoundedInputField(
                  controller: _nameController,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2.4),
                  child: Row(
                    children: <Widget>[
                      for (var gender in Gender.values)
                        Row(children: [
                          Radio(
                            value: gender,
                            activeColor: Colors.black,
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                print(value);
                                _gender = value as Gender;
                              });
                            },
                          ),
                          Text(gender.name)
                        ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2.4,
                      vertical: kDefaultPadding / 2),
                  child: DropdownButtonFormField<ProvinceModel>(
                    elevation: 10,
                    isDense: true,
                    menuMaxHeight: 300,
                    dropdownColor: kPrimaryLightColor,
                    items: _valueProvinceList.isNotEmpty
                        ? _valueProvinceList
                        : null,
                    value: _valueProvince != ProvinceModel.empty() ||
                            _valueProvinceList.isNotEmpty
                        ? _valueProvince
                        : null,
                    onChanged: (ProvinceModel? selectedProvince) {
                      if (selectedProvince != _valueProvince) {
                        _valueProvince = selectedProvince!;
                        provinceChanged();
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: kPrimaryLightColor,
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: kPrimaryColor,
                      ),
                      hintText: _valueProvince.name!,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2.4,
                      vertical: kDefaultPadding / 2),
                  child: DropdownButtonFormField<DistrictModel>(
                    elevation: 10,
                    menuMaxHeight: 300,
                    dropdownColor: kPrimaryLightColor,
                    items: _districtList.isNotEmpty ? _valueDistrictList : null,
                    value: _valueDistrict != DistrictModel.empty() ||
                            _valueDistrictList.isNotEmpty
                        ? _valueDistrict
                        : null,
                    onChanged: (DistrictModel? selectedDistrict) {
                      if (selectedDistrict != _valueDistrict) {
                        _valueDistrict = selectedDistrict!;
                        updateCWT();
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: kPrimaryLightColor,
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: kPrimaryColor,
                      ),
                      hintText: _valueDistrict.name!,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2.4,
                      vertical: kDefaultPadding / 2),
                  child: DropdownButtonFormField<CWTModel>(
                    elevation: 10,
                    menuMaxHeight: 300,
                    dropdownColor: kPrimaryLightColor,
                    items: _valueCWTList.isNotEmpty ? _valueCWTList : null,
                    value: _valueCWT != CWTModel.empty() ||
                            _valueCWTList.isNotEmpty
                        ? _valueCWT
                        : null,
                    onChanged: (CWTModel? selectedCWT) {
                      setState(() {
                        if (selectedCWT != _valueCWT) {
                          _valueCWT = selectedCWT!;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor: kPrimaryLightColor,
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: kPrimaryColor,
                      ),
                      hintText: _valueCWT.name!,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RoundedInputField(
                  controller: _addressController,
                  hintText: "Số nhà, toà nhà, tên đường",
                  icon: Icons.location_on,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng điền đầy đủ thông tin';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomButtonLarge(
                  text: "Cập Nhật Thông Tin",
                  press: () {
                    if (_formKeyUpdate.currentState!.validate()) {
                      onClickUpdateCustomerInfo();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 2.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButtonMedium(
                        text: "Cập nhật SĐT",
                        press: () {
                          ShowModalBottomSheet.showCheckPassword(
                              context, true);
                        },
                      ),
                      CustomButtonMedium(
                        text: "Cập nhật Email",
                        press: () {
                          ShowModalBottomSheet.showCheckPassword(
                              context, false);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: MediaQuery.of(context).viewInsets),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onClickUpdateCustomerInfo() async {
    try {
      UpdateUserModel uU = UpdateUserModel(
          customerId: user.id,
          address: _addressController.text,
          gender: _gender == Gender.Male ? 1 : 0,
          fullname: _nameController.text,
          cwtId: _valueCWT.cwtId);
      final result = await UpdateUserAPI.updateCustomerInfo(uU);
      print(result);
      if (result == 200) {
        DisplayToast.displaySuccessToast(
            context, 'Đổi thông tin cá nhân thành công');
        Timer(const Duration(seconds: 2), () {
          getLoggedInUser();
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        });
      } else {
        DisplayToast.displayErrorToast(
            context, 'Đổi thông tin cá nhân thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(
          context, 'Đổi thông tin cá nhân thất bại fail');
    }
  }

  void getLoggedUserInfo() {
    user = Provider.of<User>(context, listen: false).user!;
    _phoneController.text = user.phoneNumber!;
    _nameController.text = user.fullname!;
    _gender = user.gender == 1 ? Gender.Male : Gender.Female;
    print(user.token);
  }

  Future<void> updateCWT() async {
    try {
      if (_valueDistrict != DistrictModel.empty()) {
        var provider = Provider.of<CWTList>(context, listen: false);
        String? stringCWTs = await CWTAPI
            .getCWTsByDistrictId(_valueDistrict.districtId.toString());
        if (stringCWTs != null) {
          provider.removeAllCWTs();
          provider.getAllCWTsFromAPI(stringCWTs);
        }
        _cwtList = provider.cwts;
        _valueCWTList = _cwtList
            .map((cwt) => DropdownMenuItem<CWTModel>(
                  child: Text(cwt.name!),
                  value: cwt,
                ))
            .toList();
        if (_cwtList.isNotEmpty) {
          if (_cwtList.first != _valueCWT) {
            _valueCWT = _cwtList.first;
          }
        }
      }
      Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Không thể lấy thông tin Phường/Xã/Thị trấn 1');
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> updateDistrict() async {
    try {
      if (_valueProvince != ProvinceModel.empty()) {
        var provider = Provider.of<DistrictList>(context, listen: false);
        String? stringDistricts = await DistrictAPI.getDistrictsByProvinceId(
            _valueProvince.provinceId.toString());
        if (stringDistricts != null) {
          provider.removeAllDistricts();
          provider.getAllProvincesByProvinceIdFromAPI(stringDistricts);
        }
        _districtList = provider.districts;
        _valueDistrictList = _districtList
            .map((d) => DropdownMenuItem<DistrictModel>(
                  child: Text(d.name!),
                  value: d,
                ))
            .toList();
        if (_districtList.isNotEmpty) {
          if (_districtList.first != _valueDistrict) {
            _valueDistrict = _districtList.first;
          }
        }
      }
      Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Không thể lấy thông tin Quận/Huyện 1');
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> updateProvince() async {
    try {
      var provider = Provider.of<ProvinceList>(context, listen: false);
      String? stringProvinces = await ProvinceAPI.getProvinces();
      if (stringProvinces != null) {
        provider.removeAllProvinces();
        provider.getAllProvincesFromAPI(stringProvinces);
      }
      _provinceList = provider.provinces;
      _valueProvinceList = _provinceList.isNotEmpty
          ? _provinceList
              .map((p) => DropdownMenuItem<ProvinceModel>(
                    child: Text(p.name!),
                    value: p,
                  ))
              .toList()
          : List<DropdownMenuItem<ProvinceModel>>.empty();
      if (_provinceList.isNotEmpty) {
        if (_provinceList.first != _valueProvince) {
          _valueProvince = _provinceList.first;
        }
      }
      Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Không thể lấy Tỉnh/Thành phố 2');
    } finally {
      if (mounted) setState(() {});
    }
  }

  loadLocationData() async {
    await updateProvince();
    await updateDistrict();
    await updateCWT();
    await getUserLocation();
  }

  provinceChanged() async {
    await updateDistrict();
    await updateCWT();
  }

  districtChanged() async {
    await updateCWT();
  }

  getUserLocation() async {
    String? address = user.address;
    LocationModel? location =
        Provider.of<Location>(context, listen: false).location;
    if (location != null &&
        user.address != null &&
        user.address!.isNotEmpty &&
        address != null &&
        address.isNotEmpty) {
      //if (location.cwt!=null && location.district!=null && location.province!=null) address += ', ' + location.cwt! + ', ' + location.district! + ', ' + location.province!;
      _valueProvince = _provinceList.firstWhereOrNull((element) {
        return element.name! == location.province;
      })!;
      await updateDistrict();
      _valueDistrict = _districtList.firstWhereOrNull((element) {
        return element.name! == location.district;
      })!;
      await updateCWT();
      _valueCWT = _cwtList.firstWhereOrNull((element) {
        return element.name! == location.cwt;
      })!;
      _addressController.text = address;
      if (mounted) setState(() {});
    }
    // if (address != null && address.isNotEmpty) {
    //   String? province =
    //       address.substring(address.lastIndexOf(RegExp(r'Thành phố|Tỉnh')));
    //   address = address.replaceRange(
    //       address.lastIndexOf(RegExp(r'Thành phố|Tỉnh')) - 2,
    //       address.length,
    //       '');

    //   String? district = address.substring(
    //       address.lastIndexOf(RegExp(r'Thành phố|Quận|Huyện|Thị xã')));
    //   address = address.replaceRange(
    //       address.lastIndexOf(RegExp(r'Thành phố|Quận|Huyện|Thị xã')) - 2,
    //       address.length,
    //       '');

    //   String? cwt =
    //       address.substring(address.lastIndexOf(RegExp(r'Phường|Xã|Thị trấn')));
    //   address = address.replaceRange(
    //       address.lastIndexOf(RegExp(r'Phường|Xã|Thị trấn')) - 1,
    //       address.length,
    //       '');

    // }
  }

  Future<void> getLoggedInUser() async {
    var userProvider = Provider.of<User>(context, listen: false);
    var locationProvider = Provider.of<Location>(context, listen: false);
    final result = await LoginAPI.getLoggedInUser();
    final UserModel? loggedInUser = UserModel.fromMap(jsonDecode(result.body));
    if (loggedInUser != null) userProvider.login(loggedInUser);
    print(userProvider.user!.token);
    print(userProvider.user!.id);
    String? strLocation;
    if (userProvider.user != null) {
      if (userProvider.user!.cwtId != null && userProvider.user!.cwtId != 0) {
        strLocation = await LocationAPI.getLocationByCWTId(
            userProvider.user!.cwtId.toString());
      }
      if (strLocation != null && strLocation.isNotEmpty) {
        locationProvider.getLocationFromAPI(strLocation);
      }
    }
  }
}
