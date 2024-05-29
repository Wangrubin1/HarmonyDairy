import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formProvider from '@ohos.app.form.formProvider';
import NoteDatabase from '../../utils/NodeRdb/NoteDatabase';
import Form from '../../utils/NodeRdb/Form';

export default class EntryFormAbility extends FormExtensionAbility {
  private noteRdb = NoteDatabase;

  onAddForm(want) {
    let formId: string = want.parameters !== undefined ? want.parameters['ohos.extra.param.key.form_identity'] as string : '';

    this.noteRdb.createRdbStore(this.context).then(() => {
      let form: Form = new Form();
      form.formId = formId;
      // 初始化并更新表单数据
      this.updateFormWithNotes(formId);
    });
    return null;
  }

  // 查询所有笔记并更新表单
  updateFormWithNotes(formId) {
    this.noteRdb.queryAllNotes().then((list) => {
      // 获取后三个
      list = list.reverse().slice(0,3)
      let formData = {
        'titles': list.map(Note => Note.title),
        'id':list.map(Note => Note.id),
      };
      let formInfo = formBindingData.createFormBindingData(formData);
      formProvider.updateForm(formId, formInfo).then((data) => {
        console.info('rdbtestFormAbility updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        console.error('rdbtestFormAbility updateForm failed: ' + JSON.stringify(error));
      });
    });
  }

  onCastToNormalForm(formId) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId) {
    // 在需要更新表单时调用
    this.updateFormWithNotes(formId);
  }

  onChangeFormVisibility(newStatus) {
    // Called when the form provider receives form events from the system.
  }

  onFormEvent(formId, message) {
    // 在收到表单事件时更新表单
    this.updateFormWithNotes(formId);
  }

  onRemoveForm(formId) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}
