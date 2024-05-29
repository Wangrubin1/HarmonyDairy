import preferences from '@ohos.data.preferences';
import router from '@ohos.router'
import promptAction from '@ohos.promptAction';


const STORE_NAME = "LogInfo"

let context = getContext(this)
let preference: preferences.Preferences

class PreferenceUtil {
  // 初始化对象
  async InitPreferences() {
    try {
      preference = await preferences.getPreferences(context, STORE_NAME)
    }
    catch (err) {
      console.error(`error:${err}`)
    }
  }

  /**
   * 删除所有的preferences对象
   */
  async deletePreferences() {
    try {
      await preferences.deletePreferences(context, STORE_NAME);
    } catch(err) {
      console.error('TAG', `Failed to delete preferences, Cause: ${err}`);
    };
  }

  // 写入preference数据
  async putPreference(value: string) {
    if (!value) {
      return
    }

    if (!preference) {
      await this.InitPreferences();
    }
    // 将数据保存到首选项，内存中
    try {
      await preference.put('password', value);
    } catch (err) {
      console.error('TAG', `Failed to put value, Cause: ${err}`);
    }

    await preference.flush();
  }

  // 设置登录状态
  async setLogin(){
    if (!preference) {
      await this.InitPreferences();
    }
    await preference.put('isLogin', true);
  }

  // 检查登录状态
  async loginState(){
    if (!preference) {
      await this.InitPreferences();
    }

    let state;
    state= await preference.has('isLogin')
    return state;
  }

  /**
   * 获取preference对象
   */
  async getPreference() {

    let value: string = "";
    if (!preference) {
      await this.InitPreferences();
    }
    try {
      value = <string>await preference.get('password',"")
    } catch (err) {
      console.error('TAG', `Failed to get value, Cause: ${err}`)
    }

    return value;
  }

//   判空
  async firstLogin(){
    let t;
    if (!preference) {
      await this.InitPreferences();
    }
    t = !await preference.has('password')
    return t;
  }

  async checkPassword(input:string){

    let truePass =await this.getPreference();

    if(input == truePass){
      router.replaceUrl({
        url: 'pages/main',
        params:{prompt:true}
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