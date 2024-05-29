import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import NoteDatabase from '../../utils/NodeRdb/NoteDatabase'
import {Note} from '../../utils/NodeRdb/Notes'
import {noteStyle} from '../../utils/style/noteStyle'
import PreferenceUtil from '../../utils/preference/PreferencesLogInfo'
import {chooseDialog, generalDialog} from '../diaLog/DiaLog'
import form from '../entryability/EntryFormAbility';
import formProvider from '@ohos.app.form.formProvider';
import formBindingData from '@ohos.app.form.formBindingData';
@Entry
@Component
struct Main {

  private preference = PreferenceUtil
  private noteRdb = NoteDatabase
  @State notesList: Note[] = []
  @State deleteNoteId:number = 0;

  // 删除确认弹窗
  private chooseDialogController = new CustomDialogController({
    builder: chooseDialog({
      confirm:(noteId)=> {this.deleteById(noteId)},
      noteId:$deleteNoteId
    }),
    customStyle:true,
  })

  // 删除成功弹窗
  private deleteDialogController = new CustomDialogController({
    builder: generalDialog({message:$r('app.string.deletePrompt')}),
    customStyle:true
  })

  // 打开页面
  onPageShow() {
    // 提示登录成功
    this.preference.loginState().then((s)=>{
      console.log("loginState"+s)
      if(!s){
        promptAction.showToast({
          message: $r('app.string.loginPrompt'),
          duration: 2000
        });
        this.preference.setLogin();
      }
    })
    // 查询所有notes
    this.queryAllNotes();
  }

  // 查询
  async queryAllNotes(){
    this.noteRdb.queryAllNotes().then((list)=>{
      this.notesList = list;
    }).catch((err)=>{
      console.log("queryNotesError"+err);
    })
  }

  // 删除数据
  deleteById(noteId:number){
    try{
      this.noteRdb.delete(noteId);
      // 成功删除
      this.deleteDialogController.open();
      setTimeout(() => {
        this.deleteDialogController.close();
        // 刷新list
        this.queryAllNotes();
      }, 2000);
    }catch (err) {
      console.log("deleteNoteError" + err);
    }
  }


  // 左滑效果
  @Builder itemEnd(noteId:number) {
    Row () {
      Image($rawfile('delete.png'))
        .clip(new Circle({width: '100%',height:'100%'}))
        .width(50)
        .onClick(()=>{
          this.deleteNoteId = noteId;
          this.chooseDialogController.open();
        })
    }.padding(4).justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Column(){
      Row(){
          Text($r('app.string.diaryTitle')).fontSize(32)
      }
      .height('8%')

      Stack({alignContent: Alignment.Top}) {
        // 列表展示
        List({ space: 10 }) {
          ForEach(this.notesList, (note: Note) => {
            ListItem() {
              noteStyle({
                title : note.title,
                text : note.text,
                createTime:note.time
              })
            }
            .height('auto')
            .swipeAction({ end:this.itemEnd(note.id), edgeEffect: SwipeEdgeEffect.Spring})
            .onClick(()=>{
                router.pushUrl({
                  url:'pages/addOrModifyPage',
                  params: { id:note.id }
              })
            })
          })
        }
        .padding(10)
        .height('100%')
        .scrollBar(BarState.Auto)


        // 添加按钮
        Image($rawfile('add.png'))
          .clip(new Circle({width: '100%',height:'100%'}))
          .align(Alignment.Center)
          .height("9%")
          .position({x:'75%',y:'70%'})
          .margin({ top: 50, bottom:70})
          .onClick(()=>{
            router.pushUrl({
                url:'pages/addOrModifyPage'
            })
          })

      }
      .width('100%')
      .height('100%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
  }

}