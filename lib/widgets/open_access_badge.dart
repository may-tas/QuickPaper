import 'package:flutter/material.dart';

import '../models/article.dart';
import '../utils/size_config.dart';
import '../utils/typography.dart';

class OpenAccessBadge extends StatelessWidget {
  final Article article;
  final bool showFullDescription;
  final bool isOpenAccess;

  const OpenAccessBadge({
    super.key,
    required this.article,
    required this.isOpenAccess,
    this.showFullDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Open Access Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(isOpenAccess
                  ? _getOpenAccessDescription()
                  : "This article is not Open Access, meaning it requires a subscription or payment to read it."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getPercentSize(2),
          vertical: SizeConfig.getPercentSize(1),
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              article.openAccessIcon,
              style: TextStyle(fontSize: SizeConfig.getPercentSize(3)),
            ),
            if (showFullDescription) ...[
              SizedBox(width: SizeConfig.getPercentSize(1)),
              Text(
                _getDisplayText(),
                style: Typo.bodySmall.copyWith(
                  color: _getTextColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (!article.isOpenAccess) return Colors.red[50]!;

    switch (article.openAccessType?.toLowerCase()) {
      case 'gold':
        return Colors.amber[50]!;
      case 'green':
        return Colors.green[50]!;
      case 'hybrid':
        return Colors.blue[50]!;
      case 'bronze':
        return Colors.orange[50]!;
      case 'diamond':
        return Colors.purple[50]!;
      default:
        return Colors.green[50]!;
    }
  }

  Color _getBorderColor() {
    if (!article.isOpenAccess) return Colors.red[200]!;

    switch (article.openAccessType?.toLowerCase()) {
      case 'gold':
        return Colors.amber[200]!;
      case 'green':
        return Colors.green[200]!;
      case 'hybrid':
        return Colors.blue[200]!;
      case 'bronze':
        return Colors.orange[200]!;
      case 'diamond':
        return Colors.purple[200]!;
      default:
        return Colors.green[200]!;
    }
  }

  Color _getTextColor() {
    if (!article.isOpenAccess) return Colors.red[700]!;

    switch (article.openAccessType?.toLowerCase()) {
      case 'gold':
        return Colors.amber[700]!;
      case 'green':
        return Colors.green[700]!;
      case 'hybrid':
        return Colors.blue[700]!;
      case 'bronze':
        return Colors.orange[700]!;
      case 'diamond':
        return Colors.purple[700]!;
      default:
        return Colors.green[700]!;
    }
  }

  String _getDisplayText() {
    if (!article.isOpenAccess) return 'Subscription';

    switch (article.openAccessType?.toLowerCase()) {
      case 'gold':
        return 'Gold OA';
      case 'green':
        return 'Green OA';
      case 'hybrid':
        return 'Hybrid OA';
      case 'bronze':
        return 'Bronze OA';
      case 'diamond':
        return 'Diamond OA';
      default:
        return 'Open Access';
    }
  }

  // Helper method to get detailed open access description
  String _getOpenAccessDescription() {
    if (!article.isOpenAccess) {
      return 'This article is not Open Access, meaning it requires a subscription or payment to read it.';
    }

    switch (article.openAccessType?.toLowerCase()) {
      case 'gold':
        return 'GOLD OPEN ACCESS - This article is published in a fully open access journal and is freely available to read on the publisher\'s website. It\'s peer-reviewed and high quality.';

      case 'green':
        return 'GREEN OPEN ACCESS - This article is available in institutional or subject repositories like arXiv or PubMed Central. A free copy is available, though it may be a preprint, postprint, or published version.';

      case 'hybrid':
        return 'HYBRID OPEN ACCESS - This article is published in a subscription journal but the authors paid a fee to make it open access. It has the same peer review quality as subscription papers.';

      case 'bronze':
        return 'BRONZE OPEN ACCESS - This article is free to read on the publisher\'s website but may have restrictions. It doesn\'t have a clear open license and access might be temporary.';

      case 'diamond':
        return 'DIAMOND OPEN ACCESS - This article is free to read AND was free to publish. There are no fees for authors or readers, and it\'s published in a peer-reviewed academic journal.';

      default:
        return 'This article is Open Access, meaning it is freely available to read and download.';
    }
  }
}
