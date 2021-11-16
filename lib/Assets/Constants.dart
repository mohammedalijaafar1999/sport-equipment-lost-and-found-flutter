import 'package:flutter/material.dart';

var darkMode = false;

const fontFamily = 'Raleway';

const Heading1 = TextStyle(
    fontFamily: fontFamily, fontWeight: FontWeight.bold, fontSize: 32);
const Heading2 = TextStyle(
    fontFamily: fontFamily, fontWeight: FontWeight.bold, fontSize: 24);

const paragraph = TextStyle(fontFamily: fontFamily, fontSize: 18);

var PrimaryColor = darkMode ? Color(0xff00ADB5) : Color(0xff2563EB);
var BackgroundColor = darkMode ? Color(0xff222831) : Color(0xffE5E7EB);
var HoverColor = darkMode ? Color(0xff1D4ED8) : Color(0xff1D4ED8);
var SecondaryColor = darkMode ? Color(0xff393E46) : Color(0xffFFFFFF);
var TextColorWhite = darkMode ? Color(0xffCACACA) : Color(0xffFFFFFF);
var TextColorBlack = darkMode ? Color(0xffCACACA) : Color(0xff000000);
