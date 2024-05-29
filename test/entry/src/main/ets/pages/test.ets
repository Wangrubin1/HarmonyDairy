@Entry
@Component
struct Index {
  @State itemIndexArr:number[] = [1,2]

  @Builder itemEnd(index:number) {
    Row () {
      Image($r("app.media.app_icon"))
        .width(32)
        .height(32)
        .margin(4)
        .onClick(()=>{
          console.log("删除了")
        })
    }.padding(4).justifyContent(FlexAlign.SpaceEvenly)
  }

  build() {
    Column() {
      List({space:10}) {
        ForEach(this.itemIndexArr,(item,index) =>{
          ListItem(){
            Text('' + item)
              .width('100%')
              .height(100)
              .fontSize(16)
              .margin({ top: 10 })
              .borderRadius(16)
              .textAlign(TextAlign.Center)
              .backgroundColor(Color.White)
          }.swipeAction({ end:this.itemEnd.bind(this,index), edgeEffect: SwipeEdgeEffect.Spring})
        },item=>item)
      }

      Row() {
        Image($r("app.media.app_icon"))
          .width(40)
          .height(40)
          .margin(4)
          .onClick(()=>{
            this.itemIndexArr.push(this.itemIndexArr.length + 1)
          })
      }

    }
    .padding(10)
    .backgroundColor(0xDCDCDC)
    .width('100%')
    .height('100%')
  }
}