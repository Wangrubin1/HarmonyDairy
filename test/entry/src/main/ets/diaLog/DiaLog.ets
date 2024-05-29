@CustomDialog
export struct generalDialog {

  controller: CustomDialogController
  message: Resource
  build() {
    Column() {
      Row(){
        Text(this.message)
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          .align(Alignment.Center)
      }
      .height('100%')
    }
    .backgroundColor(Color.White)
    .width(150)
    .height(100)
    .borderRadius(24)
  }
}
@CustomDialog
export struct chooseDialog {
  @Link noteId : number;
  controller: CustomDialogController
  message: Resource = $r('app.string.deleteConfirmText')
  confirm?: (noteId) => void

  build() {
    Column() {
      Text(this.message)
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .align(Alignment.Center)
      Row(){
      Button($r('app.string.ConfirmButton'))
        .backgroundColor(Color.Red)
        .onClick(() => {
          this.controller.close()
          if (this.confirm) {
            this.confirm(this.noteId)
          }
        })
        .margin({ top: 10, bottom: 5 })

      Button($r('app.string.cancelButton'))
        .onClick(() => {
          this.controller.close()
        })
        .margin({ top: 10, bottom: 5 })
      }
    }
    .width(400)
    .height(100)
    .borderRadius(24)
    .backgroundColor(Color.White)
  }

}