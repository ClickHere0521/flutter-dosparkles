import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:com.floridainc.dosparkles/actions/app_config.dart';
import 'package:com.floridainc.dosparkles/actions/api/graphql_service.dart';

class BaseGraphQLClient {
  BaseGraphQLClient._();

  static final BaseGraphQLClient _instance = BaseGraphQLClient._();
  static BaseGraphQLClient get instance => _instance;
  final GraphQLService _service = GraphQLService()
    ..setupClient(
      httpLink: AppConfig.instance.graphQLHttpLink,
      // webSocketLink: AppConfig.instance.graphQlWebSocketLink
    );

  void setToken(String token) {
    _service.setupClient(
        httpLink: AppConfig.instance.graphQLHttpLink,
        /*webSocketLink: null, */ token: token);
  }

  void removeToken() {
    _service.setupClient(
      httpLink: AppConfig.instance.graphQLHttpLink, /*webSocketLink: null*/
    );
  }

  Future<QueryResult> loginWithEmail(String email, String password) {
    removeToken();

    String _mutation = '''
      mutation {
        login (input: {
            identifier: "$email",
            password: "$password"
        })
        {
          user {
            id
            username
            email
            role {
              name
              type
              description
            }
          }
          jwt
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> me() {
    String _query = '''
      query {
        me {
          id
          user {
            email
            username
            shippingAddress
            storeFavorite {
              id
              name
            }
            role {
              id
              name
            }
            name
            country
            avatar {
              url
            }
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> storesWithProductsList() {
    String _query = '''
      query {
        stores {
          id
          name
          address
          phone
          lat
          lng
          thumbnail {
            url
          }
          products {
            id
            shineonImportId
            thumbnail {
              url
            }
            video {
              url
            }
            engraveExample {
              url
            }
            optionalMaterialExample {
              url
            }
            orders {
              id
            }
            oldPrice
            price
            showOldPrice
            engraveAvailable
            properties
            shineonIds
            engraveOldPrice
            engravePrice
            showOldEngravePrice
            defaultFinishMaterial
            optionalFinishMaterial
            optionalFinishMaterialPrice
            optionalFinishMaterialEnabled
            media {
              url
            }
            deliveryInformation
            name
            uploadsAvailable
            sizeOptionsAvailable
            isActive
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> createOrder(
    String orderDetailsJson,
    double totalPrice,
    String productsIdsJson,
    List orderImageIds,
  ) {
    String _mutation = '''
      mutation CreateOrder {
        createOrder(
          input: {
            data:{
              orderDetails: $orderDetailsJson,
              totalPrice: $totalPrice,
              products: $productsIdsJson,
              media: $orderImageIds
            }
          }
        ) 
        {
          order {
            id
            orderDetails
            status
            refunded
            totalPrice
            products {
              id
            }
            media {
              id
            }
            shipmentDetails
            shineonId
            cancelReason
          }
        }
      }
    ''';

    printWrapped('Debug _mutation: $_mutation');
    return _service.query(_mutation);
  }

  Future<QueryResult> signUp(String identifier, String password) {
    String _mutation = '''
      mutation {
        register (
          input: {
            username: "$identifier",
            email: "$identifier",
            password: "$password"
          }
        )
        {
          user {
            id
            username
            email
            role {
              name
              type
              description
            }
          }
          jwt
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> forgotPassword(String email) {
    String _mutation = '''
      mutation {
        forgotPassword (
          email: "$email"
        ) {
          ok
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> resetPassword(
    String passwordValue,
    String repeatPassValue,
    String userId,
  ) {
    String _mutation = '''
      mutation {
        resetPassword (
          code: "",
          password: "$passwordValue",
          passwordConfirmation: "$repeatPassValue"
        ) {
          user {
            id
          }
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateUser(id, Map<String, dynamic> data) {
    String _mutation = '''
      mutation UserUpdate(\$input: updateUserInput!) {
        updateUser(input: \$input) {
          user {
            id
            email
            name
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    print("$data");
    return _service.mutate(_mutation, variables: data);
  }

  Future<QueryResult> setUsersFavoriteStore(String id, String storeFavorite) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              storeFavorite: "$storeFavorite"
            }
          }
        )
        {
          user {
            id
            email
            username
            role {
              id
              name
            }
            storeFavorite {
              id
            }
            pushToken
          }
        }
      }
    ''';

    return _service.mutate(_mutation);
  }

  Future<QueryResult> fetchChats() {
    String _query = '''
      query {
        chats {
          id
          users {
            id
            email
            name
          }
          chat_messages {
            id
            text
            createdAt
            user {
              id
              name
            }
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchChat(String chatId) {
    String _query = '''
      query {
        chats(where: { id: "$chatId" }) {
          id
          users {
            id
            email
            name
          }
          chat_messages {
            id
            text
            createdAt
            user {
              id
              name
            }
          }
        }
      }
      
    ''';

    // print("DEBUG________$_query");
    return _service.query(_query);
  }

  Future<QueryResult> addMessage(Map<String, dynamic> data) {
    String _mutation = '''
      mutation {
        createChatmessage (
          input: {
            data: {
              text: "${data['text']}"
              chat: "${data['chat']}"
              user: "${data['user']}"
            }
          }
        )
        {
          chatmessage {
            id
            text
            createdAt
            chat {
              id
            }
            user {
              id
              name
            }
          }
        }
      }
    ''';

    // print("DEBUG________$_mutation");
    return _service.mutate(_mutation);
  }

  // Stream<FetchResult> tvShowCommentSubscription(int id) {
  //   String _sub = '''
  //   subscription tvComment{
  //      comment: tvShowCommentList(id:$id){
  //         id
  //         comment
  //       }
  //   }''';

  //   return _service.subscribe(_sub, operationName: 'tvComment');
  // }
}
