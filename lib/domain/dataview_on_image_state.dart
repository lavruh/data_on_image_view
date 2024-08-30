import 'dart:io';

import 'package:data_on_image_view/data/i_file_provider.dart';
import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_editor.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_settings_widget.dart';
import 'package:data_on_image_view/ui/widgets/question_dialog_widget.dart';
import 'package:data_on_image_view/utils/data_processor.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class DataViewOnImageState extends ChangeNotifier {
  OverviewScreenConfig? selectedConfig;
  String selectedConfigPath = '';
  Map<String, Map<String, String>> data = {};
  bool configChanged = false;
  bool get configSelected => selectedConfig != null;
  final IFileProvider fileProvider = FileProvider.getInstance();

  setSelectedConfig(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      selectedConfigPath = path;
      selectedConfig = OverviewScreenConfig.fromJson(file.readAsStringSync());
      notifyListeners();
    } else {
      throw Exception('Config file [$path] does not exist');
    }
  }

  showConfigEditor(BuildContext context) {
    final config = selectedConfig;
    if (config != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DataViewOnImageEditor(state: this)));
    }
  }

  loadData(BuildContext context) async {
    try {
      final dataFile = await fileProvider.selectFile(
          context: context,
          title: 'Select data file',
          allowedExtensions: ['json', 'csv']);
      data = DataProcessor().getData(dataFile);
      dataFile.watch().listen((event) {
        data = DataProcessor().getData(dataFile);
        notifyListeners();
      });
      final conf = data["config"]?["config"];
      if (conf != null) {
        setSelectedConfig(conf);
      } else {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  showDataViewOnImageSettings(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return DataViewOnImageSettingsWidget(state: this);
        });
  }

  updateConfig(OverviewScreenConfig conf) {
    selectedConfig = conf;
    notifyListeners();
  }

  saveConfigFile() {
    final conf = selectedConfig;
    if (conf != null && selectedConfigPath.isNotEmpty) {
      File(selectedConfigPath).writeAsStringSync(conf.toJson());
    }
  }

  Map<String, bool> getRelatedViewPortIds() {
    Map<String, bool> res = {};
    final conf = selectedConfig;
    if (conf != null) {
      for (final e in conf.viewPorts.keys) {
        res.putIfAbsent(e, () => true);
      }
    }
    for (final e in data.keys) {
      res.putIfAbsent(e, () => false);
    }
    return res;
  }

  toggleViewPortActivation(String id) {
    final conf = selectedConfig;
    if (conf != null) {
      Map<String, ViewPort> ports = conf.viewPorts;
      if (viewPortActivated(id)) {
        ports.remove(id);
      } else {
        ports.putIfAbsent(id, () => ViewPort(id: id, title: id, x: 10, y: 10));
      }
      updateConfig(conf.copyWith(viewPorts: ports));
    }
  }

  bool viewPortActivated(String id) {
    final conf = selectedConfig;
    if (conf != null) {
      return conf.viewPorts.containsKey(id);
    }
    return false;
  }

  selectConfigFile(BuildContext context) async {
    try {
      final f = await fileProvider.selectFile(
        context: context,
        title: 'Select config file',
      );
      final path = f.path;
      setSelectedConfig(path);
      addConfig(configPath: path);
    } catch (e) {
      rethrow;
    }
  }

  createOrSelectConfig(BuildContext context) async {
    final c = context;
    final act = await questionDialogWidget(
        context: context,
        question:
            'Config file not found.\n Yes to create new,\n No select existing file.');
    if (act != null) {
      if (act && c.mounted) {
        await createConfigFile(c);
      } else {
        await selectConfigFile(c);
      }
    }
  }

  Future<void> createConfigFile(BuildContext c) async {
    OverviewScreenConfig? conf;
    final context = c;

    final img = await fileProvider.selectFile(
        context: context,
        title: "Select image file",
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    final imgPath = img.path;
    conf = OverviewScreenConfig(path: imgPath, viewPorts: {});
    if (!context.mounted) return;
    final name = await showAdaptiveDialog<String?>(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            content: TextField(
              decoration: const InputDecoration(labelText: "Name"),
              onSubmitted: (v) {
                Navigator.of(context).pop(v);
              },
            ),
          );
        });
    if (name == null) return;
    final dir = p.dirname(img.path);
    final path = p.join(dir, '$name.json');
    // }

    File(path).writeAsStringSync(conf.toJson());
    addConfig(configPath: path);
  }

  void reloadConfigFile() async {
    await setSelectedConfig(selectedConfigPath);
  }

  void addConfig({required String configPath}) {
    selectedConfigPath = configPath;
    setSelectedConfig(configPath);
  }

  Future<File> selectFile(BuildContext context, String title) async {
    try {
      final f = await fileProvider.selectFile(context: context, title: title);
      if (!f.existsSync()) throw Exception('File does not exist');
      return f;
    } catch (e) {
      rethrow;
    }
  }
}
