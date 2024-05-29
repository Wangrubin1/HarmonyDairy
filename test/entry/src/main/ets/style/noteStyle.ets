@Component
// list格式
export struct noteStyle{
  title:string;
  text:string;
  createTime:string;
  build(){
    Column(){
      Text(`${this.title}`)
        .width('100%')
        .height(40)
        .fontSize(30)
        .backgroundColor(Color.White)

      Text(`${this.text}`)
        .width('100%')
        .height(32)
        .fontSize(25)
        .backgroundColor(Color.White)

      Text($r('app.string.createTime',`${this.createTime}`))
        .width('100%')
        .height(20)
        .fontSize(15)
        .fontColor(Color.Gray)
        .backgroundColor(Color.White)
    }
  }
}