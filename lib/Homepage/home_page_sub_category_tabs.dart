import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/Product/sub_category_model.dart';
import 'package:ssumake/a_test/category_test.dart';

import '../Constants/color.dart';
import '../Model/Product/category_model.dart';

typedef StringCallback = void Function(String val);

class HomePageSubCategoryTabs extends StatefulWidget {
  const HomePageSubCategoryTabs(
      {Key? key,
      this.subCategoriesByCategoryId,
      this.selectedCategory,
      this.onTabChanged})
      : super(key: key);
  final List<SubCategoryModel>? subCategoriesByCategoryId;
  final SubCategoryModel? selectedCategory;
  final Function(int)? onTabChanged;

  @override
  HomePageSubCategoryTabsState createState() => HomePageSubCategoryTabsState();
}

class HomePageSubCategoryTabsState extends State<HomePageSubCategoryTabs> {
  late final StringCallback callback;

  //List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses", "Cap"];
  // By default our first item will be selected
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = (widget.selectedCategory != null &&
            widget.subCategoriesByCategoryId!.isNotEmpty)
        ? widget.subCategoriesByCategoryId!.indexOf(widget.selectedCategory!)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    List<SubCategoryModel> scates =
        Provider.of<SubCategoryList>(context, listen: false).subCategories;
    CategoryModel cate =
        Provider.of<CategoryList>(context, listen: false).categories.first;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.subCategoriesByCategoryId != null
              ? widget.subCategoriesByCategoryId!.length
              : scates
                  .where((element) => element.categoryId == cate.categoryId)
                  .length,
          itemBuilder: (context, index) => widget.subCategoriesByCategoryId !=
                  null
              ? buildSubCategory(widget.subCategoriesByCategoryId!, index)
              : buildSubCategory(
                  scates
                      .where((element) => element.categoryId == cate.categoryId)
                      .toList(),
                  index),
        ),
      ),
    );
  }

  Widget buildSubCategory(List<SubCategoryModel> scBuilder, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.onTabChanged!(index);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              scBuilder[index].subCategoryName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: kDefaultPadding / 4),
              //top padding 5
              height: 2,
              width: 30,
              color:
                  selectedIndex == index ? kPrimaryColor : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  void onTabChange(int index) {
    selectedIndex = index;
  }
}
