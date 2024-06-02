import formInfo from '@ohos.app.form.formInfo';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import NoteDatabase from '../../utils/NodeRdb/NoteDatabase';
import Form from '../../utils/NodeRdb/Form';
import PreferenceUtil from '../../utils/preference/PreferencesLogInfo'

export default class EntryFormAbility extends FormExtensionAbility {
  private noteRdb = NoteDatabase;
  private preference = PreferenceUtil;

  onAddForm(want) {
    let formId: string = want.parameters !== undefined ? want.parameters['ohos.extra.param.key.form_identity'] as string : '';
    let form: Form = new Form();
    form.formId = formId;
    // 初始化首选项
    this.preference.InitPreferences(this.context).then(()=>{
      this.preference.putPreference('formId',formId)
    })

    // 初始化数据库
    this.noteRdb.createRdbStore(this.context).then(() => {
      // 初始化并更新表单数据
      this.noteRdb.updateFormWithNotes(this.noteRdb,formId);
    });
    return null;
  }


  onCastToNormalForm(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId) {
    // 在需要更新表单时调用
    this.noteRdb.updateFormWithNotes(this.noteRdb,formId);
  }

  onChangeFormVisibility(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId, message) {
    // 在收到表单事件时更新表单
    this.noteRdb.updateFormWithNotes(this.noteRdb,formId);
  }

  onRemoveForm(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}
