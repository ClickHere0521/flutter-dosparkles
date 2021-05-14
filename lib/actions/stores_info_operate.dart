import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/models/model_factory.dart';

class StoresInfoOperate {
  static Future whenAppStart() async {
    final storesRequest =
        await BaseGraphQLClient.instance.storesWithProductsList();
    if (storesRequest.hasException) print(storesRequest.exception);

    List<StoreItem> storesList = List.empty(growable: true);

    if (storesRequest.data != null && storesRequest.data['stores'] != null) {
      for (var i = 0; i < storesRequest.data['stores'].length; i++) {
        // printWrapped('store: ${storesRequest.data['stores'][i]}');
        StoreItem _store =
            ModelFactory.generate<StoreItem>(storesRequest.data['stores'][i]);
        storesList.add(_store);
      }

      GlobalStore.store.dispatch(GlobalActionCreator.setStoresList(storesList));
    }
  }
}
