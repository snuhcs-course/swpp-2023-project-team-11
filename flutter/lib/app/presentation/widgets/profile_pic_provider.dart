

import 'package:flutter/material.dart';

class ProfilePic {

  AssetImage call(String email){
    int idResult = email.hashCode % 6 + 1;
    return AssetImage('assets/images/snek_profile_img_${idResult}.webp');
  }

}