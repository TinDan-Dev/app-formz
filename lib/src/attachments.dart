import 'package:flutter/material.dart';

import 'form_cubit.dart';
import 'input/input.dart';

extension FocusAttachment on FormCubit {
  FocusNode getFocusAttachment(InputIdentifier inputId) => getAttachment<FocusNode>(
        inputId,
        create: () => FocusNode(),
        dispose: (node) => node.dispose(),
      );

  void unfocusAll() => getAttachments<FocusNode>().forEach((e) => e.unfocus());
}

extension TextEditingAttachment on FormCubit {
  TextEditingController getTextEditingAttachment(InputIdentifier inputId) => getAttachment<TextEditingController>(
        inputId,
        create: () => TextEditingController(),
        dispose: (controller) => controller.dispose(),
      );
}

extension GlobalKeyAttachment on FormCubit {
  GlobalKey getGlobalKeyAttachment(InputIdentifier inputId) => getAttachment<GlobalKey>(
        inputId,
        create: () => GlobalKey(debugLabel: inputId.toString()),
      );
}
