import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/modules/compression/components/compressed_asset_status.dart';
import 'package:sidekick/modules/compression/models/compression_asset.model.dart';

class CompressedAssetList extends StatelessWidget {
  final List<CompressedAsset> assets;
  const CompressedAssetList(this.assets, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataCell> renderCells(CompressedAsset item) {
      return [
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.file(
              item.original.file,
              height: 50,
              width: 50,
            ),
          ),
        ),
        DataCell(
          Caption(item.original.name),
        ),
        DataCell(
          Caption(filesize(item.original.size)),
        ),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CompressedAssetStatus(item)],
          ),
        ),
      ];
    }

    List<DataRow> renderRows(List<CompressedAsset> assets) {
      return assets.map((asset) {
        return DataRow(cells: renderCells(asset));
      }).toList();
    }

    return Container(
      child: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const [
                DataColumn(
                  label: Text('Preview'),
                ),
                DataColumn(
                  label: Text('Info'),
                ),
                DataColumn(
                  label: Text('Size'),
                ),
                DataColumn(
                  label: Text('Savings'),
                ),
              ],
              rows: renderRows(assets),
            ),
          ),
        ),
      ),
    );
  }
}
