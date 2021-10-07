import 'package:flutter/material.dart';
import 'package:tomato_record/utils/logger.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEng => _selectedCategoryInEng;
  String get currentCategoryInKor {
    logger.d("currentCategoryInKor called!!!!");
    return categoriesMapEngToKor[_selectedCategoryInEng]!;
  }

  void setNewCategoryWithEng(String newCategory) {
    if (categoriesMapEngToKor.keys.contains(newCategory)) {
      _selectedCategoryInEng = newCategory;
      notifyListeners();
    }
  }

  void setNewCategoryWithKor(String newCategory) {
    if (categoriesMapEngToKor.values.contains(newCategory)) {
      _selectedCategoryInEng = categoriesMapKorToEng[newCategory]!;
      notifyListeners();
    }
  }
}

const Map<String, String> categoriesMapEngToKor = {
  'none': '선택',
  'furniture': '가구',
  'electronics': '전자기기',
  'kids': '유아동',
  'sports': '스포츠',
  'woman': '여성',
  'man': '남성',
  'makeup': '메이크업',
};

const Map<String, String> categoriesMapKorToEng = {
  '선택': 'none',
  '가구': 'furniture',
  '전자기기': 'electronics',
  '유아동': 'kids',
  '스포츠': 'sports',
  '여성': 'woman',
  '남성': 'man',
  '메이크업': 'makeup',
};
