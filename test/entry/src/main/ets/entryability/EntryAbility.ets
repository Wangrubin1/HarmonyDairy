import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import NoteDatabase from '../../utils/NodeRdb/NoteDatabase'
import router from '@ohos.router'

let noteId = -1;  // 默认-1

export default class EntryAbility extends UIAbility {
  private noteRdb = NoteDatabase
  // 首次打开
  onCreate(want, launchParam) {
    // 初始化数据库
    this.noteRdb.createRdbStore(this.context);
    console.log("初始化数据库完成");

    // 服务卡片跳转
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      noteId = params.noteId;
      console.info("onCreate router targetPage:" + params.noteId);
    }
  }

  // 如果在后台触发该函数
  onNewWant(want,launchParam){
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      noteId = params.noteId;
      console.info("onCreate router targetPage:" + params.noteId);
    }
    // 若为-1则表示没有从服务卡片打开
    if(noteId != -1){
      // 0表示添加
      if(noteId == 0){
        router.pushUrl({
          url:'pages/addOrModifyPage'
        })
      }
      else{
        router.pushUrl({
          url: 'pages/addOrModifyPage',
          params: {
            id: noteId
          }
        })
        // 重置
        noteId = -1;
      }
    }
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    windowStage.loadContent('pages/login')
    // 页面跳转
    if(noteId != -1){
      if(noteId == 0){
        router.pushUrl({
          url:'pages/addOrModifyPage'
        })
      }
      else{
        router.pushUrl({
          url: 'pages/addOrModifyPage',
          params: {
            id: noteId
          }
        })
        noteId = -1;
      }
    }
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
