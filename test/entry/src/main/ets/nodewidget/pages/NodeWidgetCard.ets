let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('titles') titles:string[] = [];
  @LocalStorageProp('id') noteId:Number[] = [];
  // 渲染函数
  build() {
    Column() {
      Text($r('app.string.diaryTitle'))
      .height('15%')
      if(this.titles.length){
        List({ space: 5 }){
          // notes列表
          ForEach(this.titles, (title: string, index:number) => {
            ListItem() {
              Text(`${title}`)
                .height('100%')
                .width('100%')
                .borderRadius(10)
                .backgroundColor(Color.White)
            }
            .onClick(()=>{
              console.log("cardtest"+this.noteId[index])
              postCardAction(this,{
                'action':'router',
                'abilityName': 'EntryAbility',
                'params':{
                  // 传递参数为id
                  'noteId':this.noteId[index]
                }
              })
            })
            .height('25%')
          })
        }
      }
      else{
        Text('空')
          .width('100%')
          .height('85%')
          .textAlign(TextAlign.Center)
          .onClick(()=>{
            postCardAction(this,{
              'action':'router',
              'abilityName': 'EntryAbility',
              'params':{
                // 传递参数为0，代表添加
                'noteId':0
              }
            })
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC) // 设置背景颜色
  }
}