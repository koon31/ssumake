import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';

import '../API/cwt_API.dart';
import '../API/district_API.dart';
import '../API/location_API.dart';
import '../API/login_API.dart';
import '../API/province_API.dart';
import '../API/update_user_API.dart';
import '../CommonFeatures/custom_button.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/input_decoration.dart';
import '../Model/Location/cwt_model.dart';
import '../Model/Location/district_model.dart';
import '../Model/Location/location_model.dart';
import '../Model/Location/province_model.dart';
import '../Model/User/update_user_model.dart';
import '../Model/User/user_model.dart';

class ModalBottomSheetChangeAddress extends StatefulWidget {
  const ModalBottomSheetChangeAddress({Key? key}) : super(key: key);

  @override
  State<ModalBottomSheetChangeAddress> createState() =>
      _ModalBottomSheetChangeAddressState();
}

class _ModalBottomSheetChangeAddressState
    extends State<ModalBottomSheetChangeAddress> {
  final GlobalKey<FormState> _formKeyAddressUpdate = GlobalKey<FormState>();

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
    return Column(
      children: [
        titleModalBottomSheet(),
        Form(
          key: _formKeyAddressUpdate,
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    text: "Cập nhật địa chỉ",
                    press: () async {
                      if (_formKeyAddressUpdate.currentState!.validate()) {
                        onClickUpdateCustomerInfo();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(padding: MediaQuery.of(context).viewInsets),
      ],
    );
  }

  Container titleModalBottomSheet() {
    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding * 1.4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.grey,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 46),
                child: Text(
                  'Cập nhật địa chỉ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 23),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
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
      user = userProvider.user!;
      if (userProvider.user!.cwtId != null && userProvider.user!.cwtId != 0) {
        strLocation = await LocationAPI.getLocationByCWTId(
            userProvider.user!.cwtId.toString());
      }
      if (strLocation != null && strLocation.isNotEmpty) {
        locationProvider.getLocationFromAPI(strLocation);
      }
    }
  }

  Future<void> onClickUpdateCustomerInfo() async {
    try {
      UpdateUserModel uU = UpdateUserModel(
          customerId: user.id,
          address: _addressController.text,
          gender: user.gender,
          fullname: user.fullname,
          cwtId: _valueCWT.cwtId);
      final result = await UpdateUserAPI.updateCustomerInfo(uU);
      print(result);
      if (result == 200) {
        DisplayToast.displaySuccessToast(
            context, 'Đổi địa chỉ thành công');
        Timer(const Duration(seconds: 2), () {
          getLoggedInUser();
          Navigator.pop(context);
        });
      } else {
        DisplayToast.displayErrorToast(
            context, 'Đổi địa chỉ thất bại');
      }
    } catch (e) {
      DisplayToast.displayErrorToast(
          context, 'Đổi địa chỉ thất bại fail');
    }
  }
  void getLoggedUserInfo() {
    user = Provider.of<User>(context, listen: false).user!;
  }
}
