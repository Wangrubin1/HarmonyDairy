import PreferenceUtil from '../../utils/preference/PreferencesLogInfo'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';

@Entry
@Component


struct Login {
  private preference = PreferenceUtil

  @State password: string = "";
  @State firstLogin:boolean = false;

  // 检查是否首次打开应用
  onPageShow() {
    this.preference.InitPreferences();
    this.preference.firstLogin().then((f)=>{
      this.firstLogin = f;
    })
  }

  build(){
    Column(){
      Image($r('app.media.icon'))
        .width('144')
        .height('144')
        .margin({ top: 70, bottom:70})
        .align(Alignment.Center)
      if(this.firstLogin){
        Text($r('app.string.createPassword'))
          .fontSize(30)
          .margin({bottom:20})
      }
      else{
        Text($r('app.string.inputPassword'))
          .fontSize(30)
          .margin({bottom:20})
      }

      TextInput({placeholder:$r('app.string.inputPassword')})
        .width('70%')
        .height('5%')
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })

      Button(($r('app.string.loginButton')), { type: ButtonType.Capsule })
        .margin('50')
        .width('30%')
        .onClick(()=>{
          if(this.firstLogin){
            this.createPassword();
          }
          else{
            this.checkLogin();
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ff25c5b5')
  }
  // 首次打开创建密码
  createPassword(){
    if(this.password != "") {
      this.preference.putPreference(`${this.password}`)
      router.replaceUrl({
        url: 'pages/main',
      })
    }
    else{
      promptAction.showToast({
        message: $r('app.string.emptyInputPrompt'),
        duration: 2000
      });
    }
  }

  // 检查密码
  checkLogin(){
    this.preference.checkPassword(this.password)
  }
}