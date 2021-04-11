import 'package:com.floridainc.dosparkles/globalbasestate/action.dart';
import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
import 'package:com.floridainc.dosparkles/models/model_factory.dart';
import 'package:com.floridainc.dosparkles/models/models.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';

class UserInfoOperate {
  static Future whenLogin(String token) async {
    BaseGraphQLClient.instance.setToken(token);

    final meRequest = await BaseGraphQLClient.instance.me();
    if (meRequest.hasException) {
      print("exception: ${meRequest.exception}");
    }

    final user = ModelFactory.generate<AppUser>(meRequest.data['me']['user']);

    GlobalStore.store.dispatch(GlobalActionCreator.setUser(user));
  }

  static Future<bool> whenLogout() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    try {
      _preferences.remove('jwt');
      _preferences.remove('userId');
      BaseGraphQLClient.instance.removeToken();
      GlobalStore.store.dispatch(GlobalActionCreator.setUser(null));
    } on Exception catch (_) {
      return false;
    }
    return true;
  }

  static Future whenAppStart() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    final savedToken = _preferences.getString('jwt') ?? '';

    // if (savedToken.isNotEmpty) {
    //   whenLogin(savedToken);
    // }
  }

  static Future savePushToken(id, token) async {
    return BaseGraphQLClient.instance.updateUser(id, {'pushToken': token});
  }
}
