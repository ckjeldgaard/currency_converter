import 'app/converter/currency_converter_presenter.dart';
import 'app/converter/currency_converter_view.dart';
import 'app/data/database_provider.dart';
import 'app/data/fixer_repository.dart';
import 'app/model/currency.dart';
import 'app/model/default_currency.dart';
import 'app/model/stored_currencies.dart';
import 'app/service_worker/service_worker_manager.dart';
import 'app/utils/sidedrawer/overlay_invoker.dart';
import 'app/utils/sidedrawer/sidedrawer.dart';
import 'dart:async';

class CurrencyConverterApp {

  final ServiceWorkerManager _serviceWorker = new ServiceWorkerManager();

  init() async {
    await _serviceWorker.registerServiceWorker();
    new SideDrawer(new OverlayInvoker());
    new CurrencyConverterView(new CurrencyConverterPresenter(new FixerRepository()));
  }
}

void main() {
  new CurrencyConverterApp().init();
  getDb();
}

Future getDb() async {
  DatabaseProvider databaseProvider = new DatabaseProvider();
  await databaseProvider.open();

  StoredCurrencies storedCurrencies = new StoredCurrencies(databaseProvider.db);

  storedCurrencies.add(new DefaultCurrency("DKK", 1.1));
  storedCurrencies.add(new DefaultCurrency("NKK", 0.8));

  storedCurrencies.getCurrencies().then((currencies){
      for (Currency c in currencies) {
        print("currency = " + c.code);
      }
  });
}