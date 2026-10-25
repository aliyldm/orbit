package net.bigpoint.darkorbit.mvc.settingsFUI.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsCheckBoxItemVO;
   
   public class SettingsListItemDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _assigningData:Boolean = false;
      
      protected var _checkBox:CheckBox;
      
      protected var _label:Label;
      
      protected var _iconButton:Button;
      
      public function SettingsListItemDataAssigner()
      {
         super();
         _mouseEnabled = true;
         _mouseChildrenEnabled = true;
         initialize();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._checkBox = getChildByName("settingsCheckBox") as CheckBox;
         this._label = getChildByName("settingLabel") as Label;
         this._iconButton = getChildByName("infoIconInterfaceSettings") as Button;
         this._checkBox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.handleCheckBoxStateChanged);
      }
      
      private function get dataTyped() : SettingsCheckBoxItemVO
      {
         return data as SettingsCheckBoxItemVO;
      }
      
      override public function set data(param1:Object) : void
      {
         var vo:Object = param1;
         var wasAssigning:Boolean = this._assigningData;
         this._assigningData = true;
         try
         {
            super.data = vo as SettingsCheckBoxItemVO;
            if(this.dataTyped)
            {
               this._label.text = BPLocale.getItem(this.dataTyped.labelTextKey);
               this._checkBox.selection = this.dataTyped.checkBoxSelected;
               if(this.dataTyped.infoToolTipKey)
               {
                  this._iconButton.tooltipData = BPLocale.getItem(this.dataTyped.infoToolTipKey);
                  this._iconButton.visible = true;
               }
               else
               {
                  this._iconButton.visible = false;
               }
            }
         }
         finally
         {
            this._assigningData = wasAssigning;
         }
      }
      
      private function handleCheckBoxStateChanged(param1:CheckBoxEvent) : void
      {
         if(this._assigningData || !this.dataTyped)
         {
            return;
         }
         this.dataTyped.checkBoxSelected = this._checkBox.selection;
         this.dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.LISTED_CHECKBOX_CHANGED,this.dataTyped));
      }
   }
}

