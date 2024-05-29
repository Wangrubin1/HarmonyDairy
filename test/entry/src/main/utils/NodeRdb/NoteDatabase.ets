import dataRdb from '@ohos.data.relationalStore';
import {Note} from './Notes'
class NoteDatabase {
  private tableName = ''
  private columns:Array<string> = []
  private sql_create_table = ""
  private rdbStore:dataRdb.RdbStore = null
  private StoreConfig = {
    name: "harmony.db",
    securityLevel: dataRdb.SecurityLevel.S1
  }
  constructor() {
    this.tableName = 'notes'
    this.sql_create_table = 'CREATE TABLE "notes" ("id" INTEGER NOT NULL,"title" TEXT NOT NULL,"text" TEXT,"time" DATE,PRIMARY KEY ("id"));'
  }

  // 创建数据库表
  async createRdbStore(context: Context) {
    await dataRdb.getRdbStore(context, this.StoreConfig)
      .then((rdbStore: dataRdb.RdbStore) => {
        if (rdbStore) {
          rdbStore.executeSql(this.sql_create_table)
          this.rdbStore = rdbStore
        }
      }).catch((err)=>{
        console.log("testRdb"+err)
      })
    return this.rdbStore;
  }

  // 新增笔记
  insert(notes){
    const valueBucket = JSON.parse(JSON.stringify(notes));
    this.rdbStore.insert(this.tableName,valueBucket, function(err,rows){
      if(err){
        console.error(`添加失败，code:${err.code},msg:${err.message}`);
      }
      else {
        console.info(`add row count: ${rows}`);
      }
    })
  }

  // 根据主键id删除
  delete(id:number){
    let predicates = new dataRdb.RdbPredicates(this.tableName);
    predicates.equalTo("id", id);
    this.rdbStore.delete(predicates,function(err, rows){
      if(err){
        console.error(`删除失败，code:${err.code},msg:${err.message}`);
      }
      else {
        console.info(`deleted row count: ${rows}`);
      }
    })

  }

  // 修改笔记
  update(note:Note,title:string,text:string){
    note.setTitle(title);
    note.setText(text);
    const valueBucket = JSON.parse(JSON.stringify(note));
    let predicates = new dataRdb.RdbPredicates(this.tableName);
    predicates.equalTo("id", note.id);
    this.rdbStore.update(valueBucket,predicates, function(err, rows){
      if(err){
        console.error(`添加失败，code:${err.code},msg:${err.message}`);
      }
      else {
        console.info(`Updated row count: ${rows}`);
      }
    })
  }

  // 查询所有笔记
  async queryAllNotes(){
    let resultList = [];
    let predicates = new dataRdb.RdbPredicates(this.tableName);
    console.log("开始查询")
    let ret = await this.queryFromDB(predicates);
    console.log("开始查询完成")
    resultList = await this.getListFromResultSet(ret);
    return resultList;
  }

  // 根据ID查询
  async queryById(id:number){
    let note:Note;
    let predicates = new dataRdb.RdbPredicates(this.tableName);
    predicates.equalTo('id',id);
    let ret = await this.queryFromDB(predicates);
    await this.getListFromResultSet(ret).then((noteList)=>{
      note = noteList[0];
    })
    return note;
  }

  // 查询语句
  async queryFromDB(predicates){
    let resultList;
    console.log("开始查询数据库")
    await this.rdbStore.query(predicates, this.columns).then((set)=>{
      resultList = set;
      console.log("开始获得数据长度为"+set.rowCount)
    }).catch((err)=>{
      console.log("查询失败"+err)
    })

    console.log("开始查询数据库完成")
    return resultList;
  }

  // 结果封装为用户列表
  async getListFromResultSet(resultSet){
    let noteList = []
    for(let i = 0;i<resultSet.rowCount;i++){
      resultSet.goToNextRow();
      let id = resultSet.getDouble(resultSet.getColumnIndex('id'));

      let notes = new Note(resultSet.getString(resultSet.getColumnIndex('title')),
        resultSet.getString(resultSet.getColumnIndex('text')),
        resultSet.getString(resultSet.getColumnIndex('time'))
      );
      notes.setID(id);
      noteList.push(notes);
    }
    return noteList;
  }


}
export default new NoteDatabase()

