import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock_file.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';
import 'package:stockmeter/widgets/confirm_alert_dialog_widget.dart';
import 'package:stockmeter/widgets/settings/create_file_button_widget.dart';
import 'package:stockmeter/widgets/settings/stock_file_name_widget.dart';

class DataSourceWidget extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();
  final String _stockNotificationOnlyOnSelectedFile =
      'Stock Notification will check only on the selected Stock File.';

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) =>
          _buildDataSourceWidget(context, model));

  Widget _buildDataSourceWidget(BuildContext context, AppModel model) =>
      ListTile(
          enabled: model.isUserSigned,
          title: const Text('Stock File'),
          subtitle: model.stockFile == null
              ? _createFileStatus(model.isUserSigned, model.createFileOption)
              : _stockFileDetails(model.stockFile!),
          trailing: _createEditFileTrailingButton(context, model),
          onTap: model.stockFiles.length > 1
              ? () => _showSheetIdsAvailable(context, model.stockFiles)
              : null);

  Widget? _createEditFileTrailingButton(BuildContext context, AppModel model) =>
      model.createFileOption
          ? CreateFileButtonWidget()
          : model.stockFile != null
              ? _editStockFileButton(context, model)
              : null;

  Widget _stockFileDetails(StockFile stockFile) {
    List<Widget> _children = [Text('Google Sheets Id: ${stockFile.id}')];
    if (stockFile.name != null) {
      _children.add(Text('File Name: ${stockFile.name}'));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _children);
  }

  Widget _createFileStatus(bool isUserSigned, bool createFileOption) =>
      isUserSigned && !createFileOption
          ? Text('Loading file...')
          : Text('File Not Found');

  _showSheetIdsAvailable(
      BuildContext context, List<StockFile> stockFiles) async {
    List<Widget> _children = [
      ListTile(
          leading: Icon(Icons.find_in_page_rounded, size: 40),
          title: Text(_stockNotificationOnlyOnSelectedFile),
          subtitle: const Text('Tap on a Google Sheets Id to select the File.'))
    ];
    stockFiles.forEach((stockFile) async {
      _children.add(Card(
          child: ListTile(
              onTap: () => _selectStockFile(context, stockFile),
              title: Text(stockFile.id, style: TextStyle(fontSize: 13)),
              subtitle: _stockFileName(stockFile.name))));
    });
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => ListView(children: _children));
  }

  Widget _editStockFileButton(BuildContext context, AppModel model) =>
      StockElevatedButton(
          child: Icon(Icons.settings),
          onPressed: () => _editStockFile(context, model));

  _editStockFile(BuildContext context, AppModel model) async {
    List<Widget> _children = [
      ListTile(
          leading: Icon(Icons.settings, size: 40),
          title: const Text('Edit the current Stock File')),
      StockFileNameWidget(stockFileName: model.stockFile!.name ?? ''),
      Divider(thickness: 1),
      ListTile(
          title: const Text('Delete the actual Stock File'),
          subtitle: const Text('The file will be permanently erased.'),
          trailing: _deleteStockFileButton(context, model.stockFile!.id)),
      Divider(thickness: 1),
      ListTile(
          title: const Text('Create another Stock File'),
          subtitle: Text(_stockNotificationOnlyOnSelectedFile),
          trailing: _createAnotherStockFileButton(context)),
      Divider(thickness: 1),
      ListTile(
          enabled: model.stockFiles.length > 1,
          title: const Text('Select another Stock File'),
          subtitle: Text(_stockNotificationOnlyOnSelectedFile),
          trailing: StockElevatedButton(
              onPressed: () => _selectStockFileMenu(context, model.stockFiles),
              child: Icon(Icons.find_in_page_rounded))),
      Divider(thickness: 1),
    ];
    return await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => ListView(children: _children));
  }

  Text? _stockFileName(String? positionFileName) =>
      positionFileName == null ? null : Text(positionFileName);

  Future<void> _selectStockFile(
      BuildContext context, StockFile stockFile) async {
    Navigator.of(context).pop();
    await _foregroundController.refreshFileContent(stockFile);
  }

  _selectStockFileMenu(BuildContext context, List<StockFile> stockFiles) async {
    Navigator.of(context).pop();
    return await _showSheetIdsAvailable(context, stockFiles);
  }

  Widget _createAnotherStockFileButton(BuildContext context) =>
      StockElevatedButton(
          onPressed: () => _createStockFile(context),
          child: Icon(Icons.file_copy_rounded));

  Future<void> _createStockFile(BuildContext context) async {
    Navigator.of(context).pop();
    await _foregroundController.createStockFile();
  }

  Widget _deleteStockFileButton(BuildContext context, String spreadsheetId) =>
      StockElevatedButton(
          onPressed: () => _deleteStockFile(context, spreadsheetId),
          child: Icon(Icons.delete_forever_rounded));

  Future<void> _deleteStockFile(BuildContext context, String sheetId) async {
    if (await ConfirmAlertDialogWidget().show(context,
        'The Stock File with id $sheetId will be permanently deleted')) {
      Navigator.of(context).pop();
      await _foregroundController.deleteStockFile();
    }
  }
}
