import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../utils/color.dart';
class RecordingCheckView extends StatefulWidget {
  Function? onSelected;

   RecordingCheckView({this.onSelected});

  @override
  State<RecordingCheckView> createState() => _RecordingCheckViewState();
}

class _RecordingCheckViewState extends State<RecordingCheckView> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey; // 禁用时的颜色
                } else if (states.contains(MaterialState.selected)) {
                  return Constants.baseStyleColor;
                }
                return hexStringToColor('#1C1E21'); // 未选中时的颜色
              },
            ),
            checkColor: Colors.white,
            activeColor: Constants.baseStyleColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // 设置为shrinkWrap来减小Checkbox的大小
            visualDensity: VisualDensity(horizontal: -2, vertical: -4),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
                if (widget.onSelected != null) {
                  widget.onSelected!(isChecked);
                }
              });
            }),
        SizedBox(width: 4,),
        Constants.mediumWhiteTextWidget('Recording', 18)
      ],
    );
  }
}
