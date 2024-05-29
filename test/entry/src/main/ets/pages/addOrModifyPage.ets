import router from '@ohos.router'
import NoteDatabase from '../../utils/NodeRdb/NoteDatabase'
import {Note} from '../../utils/NodeRdb/Notes'
import systemDateTime from '@ohos.systemDateTime'
import {generalDialog} from '../diaLog/DiaLog'

@Entry
@Component
struct Main{
  private noteRdb = NoteDatabase
  @State title:string = ""
  @State text:string = ""
  @State note:Note = null;
  @State changed:boolean = false;
  // 两个弹窗
  private addDialogController = new CustomDialogController({
    builder: generalDialog({message:$r('app.string.addPrompt')}),
    customStyle:true

  })

  private modifyDialogController = new CustomDialogController({
    builder: generalDialog({message:$r('app.string.modifyPrompt')}),
    customStyle:true
  })
  // 获取该页面内容（添加或者修改两种情况）
  onPageShow(){
    const params = router.getParams();
    if(params!=null){
      if(params['id']){
        this.noteRdb.queryById(params['id']).then((n)=>{
          this.note = n;
        })
      }
    }
  }

  // 插入操作
  async insertNote() {
    try {
      const dateTime = (await systemDateTime.getDate()).toLocaleString();
      const note = new Note(this.title, this.text, dateTime);
      this.noteRdb.insert(note);
      // 成功插入提示
      this.addDialogController.open();
      setTimeout(() => {
        this.addDialogController.close();
        router.back({
          url: 'pages/main'
        });
      }, 2000);
    } catch (err) {
      console.log("insertNoteError"+err);
    }
  }

  // 修改操作
  modifyNote() {
    try {
      this.noteRdb.update(this.note,this.title,this.text);
      // 成功修改提示
      this.modifyDialogController.open();
      setTimeout(() => {
        this.modifyDialogController.close();
        router.back({
          url: 'pages/main'
        });
      }, 2000);
    } catch (err) {
      console.log("modifyNoteError" + err);
    }
  }


  build(){
    Column(){
      Flex({direction: FlexDirection.Column}){
        // 返回按钮
        Button(($r('app.string.goBackButton')), { type: ButtonType.Normal })
          .fontColor(Color.Black)
          .fontSize(25)
          .backgroundColor(Color.Transparent)
          .width('30%')
          .height('8%')
          .onClick(()=>{
            router.back({
              url:'pages/main'
            })
          })
        // 标题
        TextArea({placeholder:$r('app.string.inputTitle'),text:this.note?this.note.title:null})
          .placeholderFont({size:30})
          .width('100%')
          .height('10%')
          .fontSize(30)
          .onChange((value: string) => {
            this.title = value;
            // 如果内容修改
            if (value !== (this.note ? this.note.title : "")) {
              this.changed = true;
            } else {
              this.changed = false;
            }
          })

        Stack({alignContent: Alignment.Top}) {
          TextArea({ placeholder: $r('app.string.inputText'), text: this.note ? this.note.text : null })
            .width('100%')
            .height('100%')
            .onChange((value: string) => {
              this.text = value
              // 如果内容修改
              if (value !== (this.note ? this.note.text : "")) {
                this.changed = true;
              } else {
                this.changed = false;
              }
            })
          // 显示保存按钮
          if(this.changed)
            Button(($r('app.string.saveButton')),{type:ButtonType.Capsule})
              .position({x:175,y:500})
              .onClick(()=>{
                if(this.note){
                  this.modifyNote();
                }
                else{
                  this.insertNote();
                }
              })

        }

      }
    }

    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
  }
}