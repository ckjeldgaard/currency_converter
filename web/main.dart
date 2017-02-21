import 'app/converter/currency_converter_presenter.dart';
import 'app/converter/currency_converter_view.dart';
import 'app/data/fixer_repository.dart';
import 'app/data/ts_local_storage.dart';
import 'app/service_worker/service_worker_adapter.dart';
import 'app/utils/online_check_impl.dart';
import 'app/utils/sidedrawer/overlay_invoker.dart';
import 'app/utils/sidedrawer/sidedrawer.dart';

class CurrencyConverterApp {

  final String _API_URL = "https://api.fixer.io/latest";
  final ServiceWorkerAdapter _serviceWorker = new ServiceWorkerAdapter(new TsLocalStorage());

  init() async {
    await _serviceWorker.registerServiceWorker();
    new SideDrawer(
        new OverlayInvoker()
    );
    new CurrencyConverterView(
        new CurrencyConverterPresenter(
            new FixerRepository(
                _API_URL,
                new TsLocalStorage()
            ),
            new OnlineCheckImpl()
        )
    );
  }
}

void main() {
  new CurrencyConverterApp().init();
}