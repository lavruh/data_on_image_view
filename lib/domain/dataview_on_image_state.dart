import 'dart:io';

import 'package:data_on_image_view/domain/overview_screen_config.dart';
import 'package:data_on_image_view/domain/view_port.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_editor.dart';
import 'package:data_on_image_view/ui/widgets/dataview_on_image_settings_widget.dart';
import 'package:data_on_image_view/ui/widgets/question_dialog_widget.dart';
import 'package:data_on_image_view/utils/data_processor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DataViewOnImageState extends ChangeNotifier {
  OverviewScreenConfig? selectedConfig;
  String selectedConfigPath = '';
  Map<String, Map<String, String>> data = {};
  bool configChanged = false;

  bool get configSelected => selectedConfig != null;

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
          builder: (context) => DataViewOnImageEditor(
                state: this,
              )));
    }
  }

  loadData() async {
    final f = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select data file',
      allowedExtensions: ['json', 'csv'],
      type: FileType.custom,
    );
    if (f != null) {
      final path = f.paths.first ?? '';
      data = DataProcessor().getData(File(path));
      final conf = data["config"]?["config"];
      if (conf != null) {
        setSelectedConfig(conf);
      } else {
        notifyListeners();
      }
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

  selectConfigFile() async {
    final f = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select config file',
      allowedExtensions: ['.json'],
    );
    if (f != null) {
      final path = f.paths.first ?? '';
      addConfig(configPath: path);
    }
  }

  createOrSelectConfig(BuildContext context) async {
    final act = await questionDialogWidget(
        context: context,
        question:
            'Config file not found.\n Yes to create new,\n No select existing file.');
    if (act != null) {
      if (act) {
        await createConfigFile();
      } else {
        await selectConfigFile();
      }
    }
  }

  Future<void> createConfigFile() async {
    final img =
        await FilePicker.platform.pickFiles(dialogTitle: 'Select image file');
    final imgPath = img?.files.first.path;
    if (img == null || imgPath == null) return;

    final conf = OverviewScreenConfig(path: imgPath, viewPorts: {});
    final path =
        await FilePicker.platform.saveFile(dialogTitle: 'Save new config');
    if (path != null) {
      File(path).writeAsStringSync(conf.toJson());
      addConfig(configPath: path);
    }
  }

  void reloadConfigFile() async {
    await setSelectedConfig(selectedConfigPath);
  }

  void addConfig({required String configPath}) {
    selectedConfigPath = configPath;
    setSelectedConfig(configPath);
  }
}
