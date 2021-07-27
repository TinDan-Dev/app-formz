import 'package:flutter/material.dart';

import 'form_cubit.dart';

extension FocusAttachment on FormCubit {
  FocusNode getFocusAttachment(String name) => getAttachment<FocusNode>(
        name,
        create: () => FocusNode(),
        dispose: (node) => node.dispose(),
      );

  void unfocusAll() => getAttachments<FocusNode>().forEach((e) => e.unfocus());
}

extension TextEditingAttachment on FormCubit {
  TextEditingController getTextEditingAttachment(String name) => getAttachment<TextEditingController>(
        name,
        create: () => TextEditingController(),
        dispose: (node) => node.dispose(),
      );
}
