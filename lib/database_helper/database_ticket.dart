import 'dart:async';

import 'package:path/path.dart';
import 'package:sangkuriang/model/ticket/ticket.dart';
import 'package:sangkuriang/model/users/users.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseTicket {

  static DatabaseTicket _databaseHelper;    // Singleton DatabaseHelper
  static Database _db;                // Singleton Database

  String tableName = "ticket";

  DatabaseTicket._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseTicket() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseTicket._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, "sangkuriang.db");

    var TicketsDatabase = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return TicketsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    var query = 'CREATE TABLE $tableName('
        'no_ticket TEXT PRIMARY KEY, '
        'site_id TEXT, '
        'requestor TEXT, '
        'longitude REAL, '
        'latitude REAL, '
        'alamat TEXT,'
        'time_request TEXT, '
        'time_accept, TEXT, '
        'time_backup TEXT, '
        'time_finish TEXT, '
        'meter_hour_before REAL, '
        'meter_hour_after REAL, '
        'meter_pln_before REAL, '
        'meter_pln_after REAL, '
        'photo_meter_hour_before TEXT, '
        'photo_meter_hour_after TEXT, '
        'photo_meter_pln_before TEXT, '
        'photo_meter_pln_after TEXT, '
        'cluster TEXT, '
        'id_mbp INTEGER, '
        'status_ticket TEXT '
        ')';
    await db.execute(query);
  }

  void dropTable() async {
    Database db = await this.database;
    var query = "DROP TABLE  $tableName";
    await db.execute(query);
  }

  // Fetch Operation: Get all Ticket objects from database
  Future<List<Map<String, dynamic>>> getTicketMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM Ticket by $colPriority ASC');
    var result = await db.query(tableName);
    return result;
  }

  Future<int> addData(TicketModel ticket) async {
    Future<TicketModel> data = getTicketRowDataList(ticket.no_ticket, "no_ticket");
    data.then((data) {
      var Tickets = TicketModel(
          no_ticket: ticket.no_ticket,
          site_id: ticket.site_id,
          requestor : ticket.requestor,
          longitude: ticket.longitude,
          latitude: ticket.latitude,
          alamat: ticket.alamat,
          time_request: ticket.time_request,
          time_accept: ticket.time_accept,
          time_backup: ticket.time_backup,
          time_finish: ticket.time_finish,
          meter_hour_before: ticket.meter_hour_before,
          meter_hour_after: ticket.meter_hour_after,
          meter_pln_before: ticket.meter_pln_before,
          meter_pln_after: ticket.meter_pln_after,
          photo_meter_hour_before: ticket.photo_meter_hour_before,
          photo_meter_hour_after: ticket.photo_meter_hour_after,
          photo_meter_pln_before: ticket.photo_meter_pln_before,
          photo_meter_pln_after: ticket.photo_meter_pln_after,
          status_ticket: ticket.status_ticket,
          id_mbp: ticket.id_mbp,
          cluster: ticket.cluster
      );
      print(Tickets.toMap());
      updateTicket(Tickets);
      print("update ticket");
    },onError: (error){
      insertTicket(ticket);
      print("insert ticket");
    });
  }

  // Insert Operation: Insert a Ticket object to database
  Future<int> insertTicket(TicketModel ticket) async {
    Database db = await this.database;

    int result = await db.rawInsert(
        "INSERT Into $tableName (no_ticket, site_id, requestor, longitude, latitude, alamat, time_request, time_accept, time_backup, time_finish, meter_hour_before, meter_hour_after, meter_pln_before, meter_pln_after, photo_meter_hour_before, photo_meter_hour_after, photo_meter_pln_before, photo_meter_pln_after, status_ticket)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [ticket.no_ticket, ticket.site_id, ticket.requestor, ticket.longitude, ticket.latitude, ticket.alamat, ticket.time_request, ticket.time_accept, ticket.time_backup, ticket.time_finish, ticket.meter_hour_before, ticket.meter_hour_after, ticket.meter_pln_before, ticket.meter_pln_after, ticket.photo_meter_hour_before, ticket.photo_meter_hour_after, ticket.photo_meter_pln_before, ticket.photo_meter_pln_after, ticket.status_ticket]);

    return result;
  }

  // Update Operation: Update a Ticket object and save it to database
  Future<int> updateTicket(TicketModel ticket) async {
    var db = await this.database;
    int result = await db.update(tableName, ticket.toMap(), where: 'no_ticket = ?', whereArgs: [ticket.no_ticket]);
    return result;
  }

  // Delete Operation: Delete a Ticket object from database
  Future<int> deleteTicket(String no_ticket) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableName WHERE no_ticket = "$no_ticket"');
    return result;
  }

  // Delete Operation: Delete a Ticket object from database
  Future<int> deleteAllTicket() async {
    var db = await this.database;
    print("Ticket Delete");
    int result = await db.rawDelete('DELETE FROM $tableName ');
    return result;
  }

  // Create Table Ticket
  Future<int> createTableTicket() async {
    var db = await this.database;
    var query = 'CREATE TABLE $tableName('
        'no_ticket TEXT PRIMARY KEY, '
        'site_id TEXT, '
        'requestor TEXT, '
        'longitude REAL, '
        'latitude REAL, '
        'alamat TEXT,'
        'time_request TEXT, '
        'time_accept, TEXT, '
        'time_backup TEXT, '
        'time_finish TEXT, '
        'meter_hour_before REAL, '
        'meter_hour_after REAL, '
        'meter_pln_before REAL, '
        'meter_pln_after REAL, '
        'photo_meter_hour_before TEXT, '
        'photo_meter_hour_after TEXT, '
        'photo_meter_pln_before TEXT, '
        'photo_meter_pln_after TEXT, '
        'cluster TEXT, '
        'id_mbp INTEGER, '
        'status_ticket TEXT '
        ')';
    await db.execute(query);
  }

  Future<List<Map<String, dynamic>>> getTicketMapListByUsernameCluster(UsersModel users) async {
    Database db = await this.database;
    String q = "SELECT * FROM " + tableName + " WHERE id_mbp = ${users.id_mbp} LIMIT 1";
    var res =  await db.rawQuery(q);
    //var res = await  db.query("$tableName", where: "cluster = ?", whereArgs: [cluster.toUpperCase()]);
    return res;
  }

  // Get number of Ticket objects in database
  Future<TicketModel> getTicketRowDataList(String fieldValue, String fieldName) async {
    Database db = await this.database;
    var res = await  db.query("$tableName", where: "$fieldName = ?", whereArgs: [fieldValue]);
    return res.isNotEmpty ? TicketModel.fromJson(res.first) : Null ;
  }

  // Get number of Ticket objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    int result = 0;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Ticket List' [ List<Ticket> ]
  Future<List<TicketModel>> getTicketList() async {
    var dataMapList = await getTicketMapList(); // Get 'Map List' from database
    int count = dataMapList.length;         // Count the number of map entries in db table

    List<TicketModel> dataList = List<TicketModel>();
    // For loop to create a 'Ticket List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      dataList.add(TicketModel.fromJson(dataMapList[i]));
    }

    return dataList;
  }

  Future<List<TicketModel>> getTicketListByUsernameCluster(UsersModel users) async {
    var dataMapList = await getTicketMapListByUsernameCluster(users); // Get 'Map List' from database based on username, cluster
    int count = dataMapList.length;         // Count the number of map entries in db table
    List<TicketModel> dataList = List<TicketModel>();
    // For loop to create a 'Ticket List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      dataList.add(TicketModel.fromJson(dataMapList[i]));
    }


    return dataList;
  }
}
