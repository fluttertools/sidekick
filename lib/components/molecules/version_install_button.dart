import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/dto/version.dto.dart';
import 'package:sidekick/providers/fvm_queue.provider.dart';

const installedMsg = 'Version is installed';
const notInstalledMsg = 'Version not installed. Click to install.';

class VersionInstallButton extends HookWidget {
  final VersionDto version;
  final bool warningIcon;
  const VersionInstallButton(this.version, {this.warningIcon = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isQueued = useState(false);
    final hovering = useState(false);
    final queueProvider = useProvider(fvmQueueProvider.state);

    useEffect(() {
      final isInstalling = queueProvider.activeItem != null &&
          queueProvider.activeItem.name == version.name;

      if (isInstalling) {
        isQueued.value = true;
        return;
      }

      final queued = queueProvider.queue.firstWhere(
        (item) => item.name == version.name,
        orElse: () => null,
      );

      isQueued.value = queued != null;
      return;
    }, [queueProvider]);

    Future<void> onInstall() async {
      isQueued.value = true;
      // Add it to queue for installation
      context.read(fvmQueueProvider).install(version.name);
    }

    Widget installIcon() {
      if ((isQueued.value && !version.isInstalled)) {
        return const SizedBox(
          height: 20,
          width: 20,
          child: SpinKitFadingFour(
            size: 15,
            color: Colors.cyan,
          ),
        );
      }

      if (version.isInstalled) {
        return const Icon(
          Icons.check,
          size: 20,
          color: Colors.cyan,
        );
      }

      // Display warning icon instead of download arrow
      if (warningIcon) {
        return const Icon(MdiIcons.alert, size: 20);
      }
      return const Icon(Icons.arrow_downward, size: 20);
    }

    return MouseRegion(
      onHover: (_) {
        if (!hovering.value) {
          hovering.value = true;
        }
      },
      onExit: (_) {
        if (hovering.value) {
          hovering.value = false;
        }
      },
      child: Opacity(
        opacity: version.isInstalled ? 0.3 : 1,
        child: IconButton(
          onPressed: version.isInstalled ? onInstall : onInstall,
          splashRadius: 20,
          icon: Tooltip(
              message: version.isInstalled ? installedMsg : notInstalledMsg,
              child: installIcon()),
        ),
      ),
    );
  }
}
