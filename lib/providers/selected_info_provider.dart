import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../dto/release.dto.dart';

class InfoDetail {
  ReleaseDto version;
  Project project;
  InfoDetail({this.version, this.project});

  factory InfoDetail.fromMap(Map<String, dynamic> map) {
    return InfoDetail(project: map['project'], version: map['version']);
  }

  factory InfoDetail.clone(InfoDetail infoDetail) {
    return InfoDetail.fromMap(infoDetail.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'project': project,
    };
  }
}

final selectedInfoProvider =
    StateNotifierProvider<InfoProvider, InfoDetail>((ref) => InfoProvider());

class InfoProvider extends StateNotifier<InfoDetail> {
  InfoProvider() : super(InfoDetail());

  // ignore: use_setters_to_change_properties
  void selectVersion(ReleaseDto version) {
    state.version = version;
    _updateState();
  }

  // ignore: use_setters_to_change_properties
  void selectProject(Project project) {
    state.project = project;
    _updateState();
  }

  void _updateState() {
    state = InfoDetail.clone(state);
  }

  void clearVersion() {
    state.version = null;
    _updateState();
  }
}
