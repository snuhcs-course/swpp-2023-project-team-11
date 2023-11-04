
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/routes/named_routes.dart';

class AdditionalProfileInfoScreenController extends GetxController{

  TextEditingController birthdayCon = TextEditingController();
  final _birth = "".obs;
  DateTime get birth => DateTime.parse(_birth.value);

  final gender = "성별 선택".obs;
  Map<String, Sex?> genderMap = {"성별 선택": null, "Male": Sex.male, "Female": Sex.female, "Nonbinary": Sex.nonBinary};
  Sex get sex => genderMap[gender.value]!;

  final admission = "입학 연도 선택".obs;
  List admissionYears = ["입학 연도 선택", 2023, 2022, 2021, 2020, 2019, 2018, 2017, 2016, 2015, 2014];
  int get admissionYear => int.parse(admission.value);

  var selectedCollege = '단과대학 선택'.obs;
  var selectedDepartment = '학과 선택'.obs;
  String get department => departmentEnNameMap[selectedDepartment.value]!;
// Edit the lists below if needed
  var colleges = <String>[
    '단과대학 선택',
    '공과대학',
    // '인문대학', '사회과학대학', '자연과학대학', '농업생명과학대학',
    // '의과대학', '치의학대학', '수의과대학', '간호대학',
    // '약학대학', '미술대학', '음악대학', '사범대학', '경영대학', '자유전공학부', '기타'
  ];
  var departmentMap = <String, List<String>>{
    '공과대학': ['학과 선택', '컴퓨터공학부', '기계공학부', '전기정보공학부'],
    // '인문대학': ['학과 선택', '국어국문학과', '영어영문학과', '중어중문학과'],
    // '사회과학대학': ['학과 선택', '정치외교학과', '사회학과', '경제학과'],
    // '자연과학대학': ['학과 선택', '물리학과', '화학과', '수리과학부'],
    // '농업생명과학대학': ['학과 선택', '식물생산학과', '동물자원과학과', '생명과학부'],
    // '의과대학': ['학과 선택', '의학과', '한의학과', '치의학과'],
    // '치의학대학': ['학과 선택', '치의학과', '치의학대학부'],
    // '수의과대학': ['학과 선택', '수의학과', '수의과학과', '수의학대학부'],
    // '간호대학': ['학과 선택', '간호학과', '간호학부'],
    // '약학대학': ['학과 선택', '약학과', '약학대학부'],
    // '미술대학': ['학과 선택', '동양화과', '서양화과'],
    // '음악대학': ['학과 선택', '작곡과'],
    // '사범대학': ['학과 선택', '교육학과', '국어교육과', '영어교육과'],
    // '경영대학': ['학과 선택', '경영학과', '경영학부'],
    // '자유전공학부' : ['학과 선택', '자유전공학부'],
    // '기타': ['학과 선택','기타']
  };
  Map<String, String> departmentEnNameMap = {
    "컴퓨터공학부": "CSE", "기계공학부": "ME", '전기정보공학부': "ECE"
  };

  final selectedMbti = "mbti 선택".obs;
  Map<String, Mbti?> mbtiMap = {
    "mbti 선택": null,
    "INTJ": Mbti.INTJ,
    "INTP": Mbti.INTP,
    "ENTJ": Mbti.ENTJ,
    "ENTP": Mbti.ENTP,
    "INFJ": Mbti.INFJ,
    "INFP": Mbti.INFP,
    "ENFJ": Mbti.ENFJ,
    "ENFP": Mbti.ENFP,
    "ISTJ": Mbti.ISTJ,
    "ISFJ": Mbti.ISFJ,
    "ESTJ": Mbti.ESTJ,
    "ESFJ": Mbti.ESFJ,
    "ISTP": Mbti.ISTP,
    "ISFP": Mbti.ISFP,
    "ESTP": Mbti.ESTP,
    "ESFP": Mbti.ESFP,
    "잘 모르겠어요": Mbti.UNKNOWN};
  Mbti get mbti => mbtiMap[selectedMbti.value]!;


  bool get allSet => (DateTime.tryParse(_birth.value) != null) && (admission.value != "입학 연도 선택")
  && gender.value != "성별 선택" && (selectedDepartment.value != '학과 선택') && (selectedMbti.value != "mbti 선택");

  void onNextButtonTap(){
    Get.toNamed(Routes.Maker(nextRoute: Routes.MAKE_PROFILE));
  }

  @override
  void onInit() {
    super.onInit();
    birthdayCon.addListener(() {
      _birth(birthdayCon.text);
    });
  }

  @override
  void onClose() {
    super.onClose();
    birthdayCon.dispose();
  }

}