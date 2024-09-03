import 'channel.dto.dart';

/// Master channel dto
class MasterDto extends ChannelDto {
  /// Latest version of the channel
  MasterDto({
    required super.name,
    required super.needSetup,
    required super.sdkVersion,
    required super.cache,
    required super.isGlobal,
  }) : super(
          release: null,
          currentRelease: null,
        );
}
