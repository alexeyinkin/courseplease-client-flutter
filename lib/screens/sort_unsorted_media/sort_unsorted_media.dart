import 'package:courseplease/widgets/image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortUnsortedMediaScreen extends StatefulWidget {
  static const routeName = '/sortUnsortedMedia';

  @override
  State<SortUnsortedMediaScreen> createState() => _SortUnsortedMediaScreenState();
}

class _SortUnsortedMediaScreenState extends State<SortUnsortedMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sortImportedMedia),
      ),
      body: UnsortedPhotoGrid(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}
