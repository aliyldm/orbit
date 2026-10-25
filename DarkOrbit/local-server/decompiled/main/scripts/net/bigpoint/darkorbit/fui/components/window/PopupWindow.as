package net.bigpoint.darkorbit.fui.components.window
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class PopupWindow
   {
      
      private var _handleOKpressed:Function;
      
      private var _handleCancelPressed:Function;
      
      private var _handleSavePressed:Function;
      
      private var okBTN:DisplayObject;
      
      private var cancelBTN:DisplayObject;
      
      private var toggleBTN:DisplayObject;
      
      private var _simpleWindow:SimpleWindow;
      
      public function PopupWindow(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:Function, param5:String = null, param6:Function = null)
      {
         var _loc8_:Label = null;
         var _loc9_:CheckBox = null;
         super();
         this._simpleWindow = param1;
         this._handleOKpressed = param3;
         this._handleCancelPressed = param4;
         this._handleSavePressed = param6;
         this._simpleWindow.activateModalLayer(true);
         var _loc7_:DisplayObjectContainer = param2.getChildAt(0) as DisplayObjectContainer;
         if(param5)
         {
            _loc8_ = _loc7_.getChildByName("label") as Label;
            if(_loc8_)
            {
               _loc8_.text = param5;
            }
         }
         this.okBTN = _loc7_.getChildByName("okButton");
         if(this.okBTN)
         {
            this.okBTN.addEventListener(MouseEvent.CLICK,this.okButtonClicked);
         }
         this.cancelBTN = _loc7_.getChildByName("cancelButton");
         if(this.cancelBTN)
         {
            this.cancelBTN.addEventListener(MouseEvent.CLICK,this.cancelButtonClicked);
         }
         if(param6 == null)
         {
            _loc8_ = _loc7_.getChildByName("saveLabel") as Label;
            _loc9_ = _loc7_.getChildByName("toggleSave") as CheckBox;
            if(Boolean(_loc8_) && Boolean(_loc9_))
            {
               _loc8_.visible = _loc9_.visible = false;
            }
         }
         else
         {
            this.toggleBTN = _loc7_.getChildByName("toggleSave");
            if(this.toggleBTN)
            {
               this.toggleBTN.addEventListener(MouseEvent.CLICK,this.saveButtonClicked);
            }
         }
      }
      
      private function cancelButtonClicked(param1:MouseEvent) : void
      {
         if(this._handleCancelPressed != null)
         {
            this._handleCancelPressed();
         }
         this.dispose();
      }
      
      private function dispose() : void
      {
         if(this.okBTN)
         {
            this.okBTN.removeEventListener(MouseEvent.CLICK,this.okButtonClicked);
         }
         if(this.cancelBTN)
         {
            this.cancelBTN.removeEventListener(MouseEvent.CLICK,this.cancelButtonClicked);
         }
         if(this.toggleBTN)
         {
            this.toggleBTN.removeEventListener(MouseEvent.CLICK,this.saveButtonClicked);
         }
         this._simpleWindow.activateModalLayer(false);
         this._simpleWindow.minimize(false);
         this._handleOKpressed = this._handleCancelPressed = null;
      }
      
      private function okButtonClicked(param1:MouseEvent) : void
      {
         if(this._handleOKpressed != null)
         {
            this._handleOKpressed();
         }
         this.dispose();
      }
      
      private function saveButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:CheckBox = null;
         if(this._handleSavePressed != null)
         {
            _loc2_ = this.toggleBTN as CheckBox;
            this._handleSavePressed(_loc2_.selection);
         }
      }
   }
}

