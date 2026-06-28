import 'package:equatable/equatable.dart';

/// A sibling app promoted through a house ad. Static config (no backend), so
/// fields are non-nullable. [colorValue] is an ARGB int — the entity stays
/// Flutter-free; the widget wraps it in a `Color`.
class SelfPromotionApp extends Equatable {
  const SelfPromotionApp({
    required this.id,
    required this.name,
    required this.tagline,
    required this.logoAsset,
    required this.shareUrl,
    required this.colorValue,
    this.cta = 'Install',
  });

  final String id;
  final String name;
  final String tagline;
  final String logoAsset;
  final String shareUrl;
  final int colorValue;
  final String cta;

  @override
  List<Object?> get props => [
    id,
    name,
    tagline,
    logoAsset,
    shareUrl,
    colorValue,
    cta,
  ];
}
