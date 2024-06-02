import preferences from '@ohos.data.preferences';
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';


const STORE_NAME = "LogInfo"

let context = null;
let preference: preferences.Preferences
class PreferenceUtil {
  // 初始化对象
  async InitPreferences(con) {
    context = con
    try {
      preference = await preferences.getPreferences(context, STORE_NAME)
    }
    catch (err) {
      console.error(`error:${err}`)
    }
  }


  // 写入preference数据
  async putPreference(key:string,value: string) {
    if (!value) {
      return
    }

    if (!preference) {
      await this.InitPreferences(context);
    }
    // 将数据保存到首选项，内存中
    try {
      await preference.put(key, value);
    } catch (err) {
      console.error('TAG', `Failed to put value, Cause: ${err}`);
    }

    await preference.flush();
  }

  // 设置登录状态
  async setLogin(){
    if (!preference) {
      await this.InitPreferences(context);
    }
    await preference.put('isLogin', true);
  }

  // 检查登录状态
  async loginState(){
    if (!preference) {
      await this.InitPreferences(context);
    }

    let state;
    state= await preference.has('isLogin')
    return state;
  }

  /**
   * 获取preference对象
   */
  async getPreference(params) {

    let value: string = "";
    if (!preference) {
      await this.InitPreferences(context);
    }
    try {
      value = <string>await preference.get(params,"")
    } catch (err) {
      console.error('TAG', `Failed to get value, Cause: ${err}`)
    }

    return value;
  }

//  是否首次登录
  async firstLogin(){
    let t;
    if (!preference) {
      await this.InitPreferences(context);
    }
    t = !await preference.has('password')
    return t;
  }
  // 检查密码
  async checkPassword(input:string){

    let truePass =await this.getPreference('password');

    if(input == truePass){
      router.replaceUrl({
        url: 'pages/main'
      })
    }
    else{
      promptAction.showToast({
        message: '密码错误',
        duration: 2000
      });
    }
  }
}

export default new PreferenceUtil();