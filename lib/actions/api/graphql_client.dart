import 'package:com.floridainc.dosparkles/globalbasestate/store.dart';
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
            id
            email
            username
            shippingAddress
            storeFavorite {
              id
              name
            }
            store {
              id
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
          chats {
            id
            store {
              id 
              name
            }
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
              name
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

  Future<QueryResult> fetchStoreById(String id) {
    String _query = '''
      query {
        stores ( where: { id: "$id" } ) {
          id
          name
          address
          phone
          lat
          lng
          thumbnail {
            url
          }
          chats {
            id
            users {
              id
              email
              name
            }
            store {
              id
              name
            }
            chat_messages {
              id
              text
              createdAt
              messageType
              order {
                id
              }
              chat {
                id
              }
              user {
                id
                name
              }
            }
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
              name
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
        createOrder (
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
              shineonImportId
              thumbnail {
                url
              }
              video {
                url
              }
              engraveExample {
                url
                name
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

    // printWrapped('Debug _mutation: $_mutation');
    return _service.query(_mutation);
  }

  Future<QueryResult> fetchOrder(String orderId) {
    String _query = '''
      query {
        orders (where: { id: "$orderId" }) {
          id
          orderDetails
          status
          refunded
          totalPrice
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
          media {
            id
            url
          }
          shipmentDetails
          shineonId
          cancelReason
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.query(_query);
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
            avatar {
              url
            }
          }
          store {
            id
            name
            createdAt
            thumbnail {
              id
              url
            }
          }
          chat_messages {
            id
            text
            createdAt
            messageType
            order {
              id
            }
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
            avatar {
              url
            }
          }
          store {
            id
            name
            createdAt
            thumbnail {
              id
              url
            }
          }
          chat_messages {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
              avatar {
                url
              }
            }
          }
        }
      }
      
    ''';

    // print("DEBUG________$_query");
    return _service.query(_query);
  }

  Future<QueryResult> createOrderChat(List<String> ids, String storeId) {
    String _mutation = '''
      mutation {
        createChat (
          input: {
            data: {
              users: $ids
              store: "$storeId"
            }
          }
        ) 
        {
          chat {
            id
            store {
              id
              name
            }
            users {
              id
              email
              name
              avatar {
              url
            }
            }
            chat_messages {
              id
              text
              createdAt
              order {
                id
              }
              messageType
              user {
                id
                name
              }
            }
          }
        }
      }
    ''';

    // print("DEBUG________$_mutation");
    return _service.mutate(_mutation);
  }

  Future<QueryResult> createOrderMessage(
    String chatId,
    String orderId,
  ) {
    String _mutation = '''
      mutation {
        createChatmessage (
          input: {
            data: {
              chat: "$chatId"
              order: "$orderId"
              messageType: order
            }
          }
        )
        {
          chatmessage {
            id
            text
            createdAt
            messageType
            order {
              id
            }
            chat {
              id
            }
            user {
              id
              name
              avatar {
                url
              }
            }
          }
        }
      }
    ''';

    // print("DEBUG________$_mutation");
    return _service.mutate(_mutation);
  }

  Future<QueryResult> createMessage(Map<String, dynamic> data) {
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
            messageType
            order {
              id
            }
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
