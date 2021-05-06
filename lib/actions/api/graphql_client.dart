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
            phoneNumber
            storeFavorite {
              id
              name
            }
            store {
              id
              name
            }
            role {
              id
              name
            }
            name
            country
            orders {
              id
              status
              orderDetails
              totalPrice
              products {
              id
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
              }
            }
            avatar {
              url
            }
          }
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> fetchUsers() {
    String _query = '''
      query {
        users {
          id
          email
          username
          phoneNumber
          shippingAddress
          storeFavorite {
            id
            name
          }
          store {
            id
            name
          }
          role {
            id
            name
          }
          name
          country
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.query(_query);
  }

  Future<QueryResult> setUserPhoneNumber(String id, String phoneNumber) {
    String _mutation = '''
      mutation {
        updateUser (
          input: {
            where: {
              id: "$id"
            }
            data: {
              phoneNumber: "$phoneNumber"
            }
          }
        )
        {
          user {
            id
            email
            username
            phoneNumber
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

  Future<QueryResult> registerUser(Map data) {
    String _mutation = '''
      mutation {
        register (
          input: { 
            email: "${data['emailValue']}"
            username: "${data['emailValue']}"
            password: "${data['passwordValue']}"
          }
        ) 
        {
          jwt
          user {
            id
            username
            email
            role {
              id
              name
            }
          }
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.query(_mutation);
  }

  Future<QueryResult> updateUserOnCreate(String id, Map data) {
    String _mutation = '''
      mutation UpdateUser {
        updateUser (
          input: {
            where: {
              id: "$id"
            },
            data: {
              name: "${data['fullName']}"
            }
          }
        ) 
        {
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
              name
            }
            role {
              id
              name
            }
            name
            country
          }
        }
      }
    ''';

    return _service.query(_mutation);
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
                          optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
            productDetails
            deliveryTime
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
                          optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
            productDetails
              deliveryTime
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

  Future<QueryResult> updateStoreOrder(String id, List<String> orderIds) {
    String _mutation = '''
      mutation UpdateStore {
        updateStore (
          input: {
            where: {
              id: "$id"
            }
            data:{
              orders: $orderIds      
            }
          }
        ) 
        {
          store {
            id
            name
            address
            phone
            orders {
              id
            }
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
                            optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
          }
        }
      }
    ''';

    //  printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> createOrder(
    String orderDetailsJson,
    double totalPrice,
    String productsIdsJson,
  ) {
    String _mutation = '''
      mutation CreateOrder {
        createOrder (
          input: {
            data:{
              orderDetails: $orderDetailsJson,
              totalPrice: $totalPrice,
              products: $productsIdsJson,
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
                            optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
                          optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
            productDetails
              deliveryTime
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
          rejectedReason
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
    return _service.query(_query);
  }

  Future<QueryResult> changeOrder(
      String id, String status, String rejectedReason) {
    String _mutation = '''
      mutation UpdateOrder {
        updateOrder (
          input: {
            where: {
              id: "$id"
            }
            data:{
              status: $status              
              rejectedReason: "$rejectedReason"
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
            rejectedReason
            media {
              id
            }
            shipmentDetails
            shineonId
          }
        }
      }
    ''';

    // printWrapped('Debug _mutation: $_mutation');
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
            phoneNumber
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

  Future<QueryResult> fetchAppContent() {
    String _query = '''
      query {
        appContent {
          id
          privacyPolicy
          termsAndConditions
          aboutUs
        }
      }
    ''';

    return _service.query(_query);
  }

  Future<QueryResult> createSupportRequest(
      name, email, subjectChoice, message) {
    String _mutation = '''
      mutation {
        createSupportRequest (
          input: {
            data: {
              name: "$name"
              email: "$email"
              subjectChoice: $subjectChoice
              message: "$message"
            }
          }
        )
        {
          supportRequest {
            name
            email
            subjectChoice
            message
          }
        }
      }
    ''';

    print("DEBUG________$_mutation");
    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateProductMedia(String id, List<String> productIds) {
    String _mutation = '''
      mutation UpdateProduct {
        updateProduct (
          input: {
            where: {
              id: "$id"
            }
            data:{
              media: $productIds      
            }
          }
        ) 
        {
					product {
              id
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
                id
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
        }
      }
    ''';

    //  printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> updateProductEngravingName(String id, String name) {
    String _mutation = '''
      mutation UpdateProduct {
        updateProduct (
          input: {
            where: {
              id: "$id"
            }
            data:{
              """""""": $name      
            }
          }
        ) 
        {
					product {
              id
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
                id
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
        }
      }
    ''';

    //  printWrapped('Debug _mutation: $_mutation');
    return _service.mutate(_mutation);
  }

  Future<QueryResult> fetchProductById(String id) {
    String _query = '''
      query {
        products (where: { id: "$id" }) {
              id
              shineonImportId
              optionalFinishMaterialOldPrice
              showOptionalFinishMaterialOldPrice
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
              productDetails
              deliveryTime
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
                id
                url
              }
              name
              uploadsAvailable
              sizeOptionsAvailable
              isActive
            }
        }
      
    ''';

    return _service.query(_query);
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
