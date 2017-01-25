import 'app/converter/currency_converter_presenter.dart';
import 'app/converter/currency_converter_view.dart';
import 'app/data/database_provider.dart';
import 'app/data/fixer_repository.dart';
import 'app/service_worker/service_worker_manager.dart';
import 'app/utils/sidedrawer/overlay_invoker.dart';
import 'app/utils/sidedrawer/sidedrawer.dart';

class CurrencyConverterApp {

  final String _API_URL = "http://api.fixer.io/latest";
  final ServiceWorkerManager _serviceWorker = new ServiceWorkerManager();

  init() async {
    await _serviceWorker.registerServiceWorker();
    new SideDrawer(
        new OverlayInvoker()
    );
    new CurrencyConverterView(
        new CurrencyConverterPresenter(
            new FixerRepository(
                _API_URL,
                new DatabaseProvider()
            )
        )
    );
  }
}

void main() {
  new CurrencyConverterApp().init();
}