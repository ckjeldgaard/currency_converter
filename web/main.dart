import 'app/converter/currency_converter_view.dart';
import 'app/utils/sidedrawer/overlay_invoker.dart';
import 'app/utils/sidedrawer/sidedrawer.dart';

void main() {
  new SideDrawer(new OverlayInvoker());
  new CurrencyConverterView();
}