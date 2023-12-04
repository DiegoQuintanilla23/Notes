import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getUsers() async {
  List<Map<String, dynamic>> users = [];
  CollectionReference collectionReferenceUsers = db.collection('Usuarios');
  QuerySnapshot queryUsers = await collectionReferenceUsers.get();
  queryUsers.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    data['documentID'] =
        documento.id; // Agregamos el documentID al mapa de datos.
    users.add(data);
  });
  return users;
}

Future<String?> getUserIdByEmailAndPassword(
    String email, String password) async {
  CollectionReference collectionReferenceUsers = db.collection('Usuarios');
  QuerySnapshot queryUsers = await collectionReferenceUsers
      .where('email', isEqualTo: email)
      .where('passwd', isEqualTo: password)
      .get();

  if (queryUsers.docs.isNotEmpty) {
    // Se encontró un usuario con las credenciales proporcionadas.
    return queryUsers.docs.first.id;
  } else {
    // No se encontró ningún usuario con las credenciales proporcionadas.
    return '';
  }
}

Future<Map<String, String>?> getUserDataById(String documentId) async {
  DocumentSnapshot documentSnapshot =
      await db.collection('Usuarios').doc(documentId).get();

  if (documentSnapshot.exists) {
    // Se encontró un usuario con el documentID proporcionado.
    Map<String, String> userData = {
      'nombre': documentSnapshot['nombre'] ?? '',
      'email': documentSnapshot['email'] ?? '',
    };
    return userData;
  } else {
    // No se encontró ningún usuario con el documentID proporcionado.
    return null;
  }
}

Future<void> addUser(String name, String email, String pwd) async {
  await db
      .collection("Usuarios")
      .add({"nombre": name, "email": email, "passwd": pwd});
}

Future<void> deleteUser(String documentId) async {
  await db.collection("Usuarios").doc(documentId).delete();
}

Future<void> updateUser(
    String documentId, String newName, String newEmail, String newPwd) async {
  await db
      .collection("Usuarios")
      .doc(documentId)
      .update({"nombre": newName, "email": newEmail, "passwd": newPwd});
}

//Tareas
Future<List<Map<String, dynamic>>> getTasksByUserId(
    String userID, String orderByField) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Tareas')
      .where('userID', isEqualTo: userID)
      .orderBy(orderByField, descending: false)
      .get();

  List<Map<String, dynamic>> taskList = [];

  for (QueryDocumentSnapshot document in querySnapshot.docs) {
    Map<String, dynamic> taskData = {
      'documentId': document.id,
      'title': document['title'] ?? '',
      'content': document['content'] ?? '',
      'date': document['date'] ?? null,
      'location': document['location'] ?? null,
      'userID': document['userID'] ?? '',
      'imglink': document['imglink'] ?? '',
    };
    taskList.add(taskData);
  }

  return taskList;
}

Future<Map<String, dynamic>?> getTaskDataById(String documentId) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('Tareas')
      .doc(documentId)
      .get();

  if (documentSnapshot.exists) {
    // Se encontró una tarea con el documentID proporcionado.
    Map<String, dynamic> taskData = {
      'title': documentSnapshot['title'] ?? '',
      'content': documentSnapshot['content'] ?? '',
      'date': documentSnapshot['date'] ?? null,
      'location': documentSnapshot['location'] ?? null,
      'userID': documentSnapshot['userID'] ?? '',
      'imglink': documentSnapshot['imglink'] ?? '',
    };
    return taskData;
  } else {
    // No se encontró ninguna tarea con el documentID proporcionado.
    return null;
  }
}

Future<void> addTask(String title, String content, Timestamp date,
    GeoPoint location, String userID, String imgink) async {
  await db.collection("Tareas").add({
    "title": title,
    "content": content,
    "date": date,
    "location": location,
    "userID": userID,
    "imglink": imgink,
  });
}

Future<void> deleteTask(String documentId) async {
  await db.collection("Tareas").doc(documentId).delete();
}

Future<void> updateTask(
    String documentId,
    String newtitle,
    String newcontent,
    Timestamp newdate,
    GeoPoint newlocation,
    String userID,
    String newimgink) async {
  await db.collection("Tareas").doc(documentId).update({
    "title": newtitle,
    "content": newcontent,
    "date": newdate,
    "location": newlocation,
    "userID": userID,
    "imglink": newimgink,
  });
}

Future<List<Map<String, dynamic>>> getTasksByUserIdWithOrder(
    String userId, String orderByField) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy(orderByField)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error en getTasksByUserIdWithOrder: $e');
    return [];
  }
}
