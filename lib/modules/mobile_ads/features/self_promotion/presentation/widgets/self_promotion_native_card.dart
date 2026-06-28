import 'package:flutter/material.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/mobile_ads/features/self_promotion/domain/entity/entity.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a promoted app's download page in the external browser.
Future<void> openSelfPromotion(SelfPromotionApp app) async {
  final uri = Uri.tryParse(app.shareUrl);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Small "Ad" attribution chip, shared by the house-ad widgets.
class SelfPromotionAdBadge extends StatelessWidget {
  const SelfPromotionAdBadge({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Ad',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.r,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// House ad shaped like a content grid card — brand-coloured, with the app
/// logo, name, tagline and an install CTA. Tapping opens the store page.
class SelfPromotionNativeCard extends StatelessWidget {
  const SelfPromotionNativeCard({super.key, required this.app});

  final SelfPromotionApp app;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final color = Color(app.colorValue);
    return Material(
      color: Color.alphaBlend(
        color.withValues(alpha: 0.10),
        scheme.surfaceContainerHigh,
      ),
      borderRadius: BorderRadius.circular(14.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openSelfPromotion(app),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      app.logoAsset,
                      width: 32.r,
                      height: 32.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(Icons.apps, size: 32.r, color: color),
                    ),
                  ),
                  const Spacer(),
                  SelfPromotionAdBadge(color: color),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: Text(
                  app.tagline,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.25,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  app.cta,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.r,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
