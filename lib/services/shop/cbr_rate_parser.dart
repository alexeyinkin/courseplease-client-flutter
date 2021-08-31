import 'package:courseplease/models/shop/enum/currency_alpha3.dart';
import 'package:xml/xml.dart';

class CbrRateParser {
  Map<String, double> parse(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final result = <String, double>{};
    final parent = document.getElement('ValCurs');

    if (parent == null) {
      throw Exception('Cannot parse XML string.');
    }

    for (final node in parent.children) {
      if (node is XmlElement) {
        result.addEntries([_getNodeRate(node)]);
      }
    }

    result[CurrencyAlpha3Enum.RUB] = 1;
    return result;
  }

  MapEntry<String, double> _getNodeRate(XmlNode node) {
    final alpha2 = node.getElement('CharCode')?.text;
    final lotSize = _getLotSize(node);
    final lotPrice = _getLotPrice(node);

    if (alpha2 == null || lotSize == null || lotPrice == null) {
      throw Exception('Cannot parse rate from: ' + node.toString());
    }

    return MapEntry(alpha2, lotPrice / lotSize);
  }

  double? _getLotSize(XmlNode node) {
    return _getNumericChildValue(node, 'Nominal');
  }

  double? _getLotPrice(XmlNode node) {
    return _getNumericChildValue(node, 'Value');
  }

  double? _getNumericChildValue(XmlNode node, String name) {
    final str = node.getElement(name)?.text;
    if (str == null) return null;

    return double.tryParse(str.replaceAll(',', '.'));
  }
}
