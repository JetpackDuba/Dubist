var Sql;

var identifier = "Dubist"
var version = "Dubist"
var description = "Simple tasks list app!"

var createDataBase = function(){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);

    db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    // isDone = 0 -> false
                    // isDone = 1 -> true
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Tasks(id INTEGER, title TEXT, description TEXT, isDone INTEGER)');
                });
}

var getTasksTodo = function(){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);
    var rows;

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Tasks WHERE isDone = 0');
                    rows=rs.rows;
                });

    return rows;
}

var getTasksDone = function(){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);
    var rows;

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Tasks WHERE isDone = 1');
                    rows=rs.rows;
                });
    return rows;

}

var insertTask = function(title, description){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);

    db.transaction(
                function(tx) {

                    var rs = tx.executeSql('SELECT MAX(id) as maxId FROM Tasks');
                    var maxId=1;
                    if(rs.rows.length > 0)
                            maxId=rs.rows.item(0).maxId

                    tx.executeSql('INSERT INTO Tasks VALUES(?, ?, ?, ?)', [maxId + 1, title, description, 0 ]);

                });
}

var changeStatus = function(id, done){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('UPDATE Tasks SET isDone = ' + done + ' WHERE id = ' + id);
                });
}

var removeTask = function(id){
    var db = Sql.openDatabaseSync(identifier, version, description, 1000000);

    db.transaction(
                function(tx) {
                    var rs = tx.executeSql('DELETE FROM Tasks WHERE id = ' + id);
                });
}
