import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssumake/CartOrder/order_history_page.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Login_Register/Welcome/welcome_page.dart';
import 'package:ssumake/User/update_user_page.dart';
import '../Model/Product/category_model.dart';
import '../Model/Product/sub_category_model.dart';
import '../Model/User/user_model.dart';
import 'home_page.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({
    Key? key,
    required this.categories,
    required this.subCategories,
  }) : super(key: key);
  final List<CategoryModel> categories;
  final List<SubCategoryModel> subCategories;

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  late Map<CategoryModel, bool> categoriesExtended;
  late var user;
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = getLoggedAccount();
    categoriesExtended = toMapCategories();

  }

  Future<void> getLoggedAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user = preferences.getStringList('user');
    print(user[0]);
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user = null;
    preferences.remove('user');
    print(preferences.getStringList('user'));
    Provider.of<User>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: [
          FutureBuilder(
            future: _future,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: kDefaultPadding * 2,
                          left: kDefaultPadding,
                          right: kDefaultPadding),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent, padding: EdgeInsets.zero),
                        onPressed: () {
                          if (user != null) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const WelcomePage();
                            }));
                            logout();
                          } else {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const WelcomePage();
                            }));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: kPrimaryLightColor),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.all(kDefaultPadding / 4 * 3),
                                child: user == null
                                    ? Row(
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: kDefaultPadding / 2),
                                          child: Icon(Icons.login, color: Colors.black,),
                                        ),
                                        Text('Đăng Nhập',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    )
                                    : Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: kDefaultPadding / 2),
                                            child: Icon(Icons.logout, color: Colors.black,),
                                          ),
                                          Text('Đăng Xuất',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: kDefaultPadding,
                            left: kDefaultPadding,
                            right: kDefaultPadding),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, padding: EdgeInsets.zero),
                          onPressed: () {
                            if (user != null) {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return const UpdateUserPage();
                                  }));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryLightColor),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.all(kDefaultPadding / 4 * 3),
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: kDefaultPadding / 2),
                                        child: Icon(Icons.person, color: Colors.black,),
                                      ),
                                      Text('Thông tin cá nhân',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      visible: user!=null,
                    ),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: kDefaultPadding,
                            left: kDefaultPadding,
                            right: kDefaultPadding),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, padding: EdgeInsets.zero),
                          onPressed: () {
                            if (user != null) {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return const OrderHistoryPage();
                                  }));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryLightColor),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.all(kDefaultPadding / 4 * 3),
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: kDefaultPadding / 2),
                                        child: Icon(Icons.history_edu, color: Colors.black,),
                                      ),
                                      Text('Lịch sử đơn hàng',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      visible: user!=null,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding/2),
            child: Divider(thickness: 2),
          ),
          mapCategoriesToMenuList()
        ]),
      ),
    );
  }

  mapCategoriesToMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoriesExtended.length,
        itemBuilder: (context, index) => categoriesExtended.isNotEmpty
            ? buildCategoryItem(index)
            : const SizedBox.shrink(),
      ),
    );
  }

  toMapCategories() {
    return {for (var c in widget.categories) c: false};
  }

  buildCategoryItem(int index) {
    CategoryModel cate = categoriesExtended.keys.toList()[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, padding: EdgeInsets.zero),
            onPressed: () => setState(() {
              categoriesExtended[cate] = !categoriesExtended[cate]!;
            }),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: kPrimaryLightColor),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(cate.categoryName!,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  Icon(
                      categoriesExtended[cate]!
                          ? Icons.arrow_left
                          : Icons.arrow_drop_down,
                      color: Colors.black),
                ],
              ),
            ),
          ),
          getSubCategoryMenuItem(cate).isNotEmpty
              ? mapSubCategoriesToMenuList(
                  cate, getSubCategoryMenuItem(cate), categoriesExtended[cate]!)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  mapSubCategoriesToMenuList(CategoryModel cate,
      List<SubCategoryModel> scatesByCateId, bool isExtended) {
    return Visibility(
      visible: isExtended,
      child: Padding(
        padding: const EdgeInsets.only(
            left: kDefaultPadding, top: kDefaultPadding / 4),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scatesByCateId.length,
          itemBuilder: (context, index) => scatesByCateId.isNotEmpty
              ? buildSubCategoryItem(cate, scatesByCateId, index)
              : const Text("No Sub Categories"),
        ),
      ),
    );
  }

  buildSubCategoryItem(
      CategoryModel cate, List<SubCategoryModel> scates, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.transparent, elevation: 0, padding: EdgeInsets.zero),
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage(
            category: cate,
            subCategoriesByCategoryId: scates,
            subCategory: scates[index],
          );
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kPrimaryLightColor),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(scates[index].subCategoryName!,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SubCategoryModel> getSubCategoryMenuItem(CategoryModel cate) {
    return widget.subCategories
        .where((element) => element.categoryId == cate.categoryId)
        .toList();
  }
}
