
import 'package:flutter/cupertino.dart';

extension WidhtHeight on int{
 SizedBox get height => SizedBox(height: this.toDouble(),);
}
