import 'package:flutter/material.dart';

import '../models/article.dart';
import '../utils/size_config.dart';
import '../utils/typography.dart';

class OpenAccessBadge extends StatelessWidget {
  final Article article;
  final bool showFullDescription;

  const OpenAccessBadge({
    super.key,
    required this.article,
    this.showFullDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: article.openAccessDescription,
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
}
