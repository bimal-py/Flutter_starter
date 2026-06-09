part of 'package_info_cubit.dart';

class PackageInfoState extends Equatable {
  const PackageInfoState({this.packageInfo});

  final PackageInfoEntity? packageInfo;

  PackageInfoState copyWith({PackageInfoEntity? packageInfo}) =>
      PackageInfoState(packageInfo: packageInfo ?? this.packageInfo);

  @override
  List<Object?> get props => [packageInfo];
}
