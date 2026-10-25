package net.bigpoint.darkorbit.fui.components.buttons.radio
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class RadioButtonGroup extends EventDispatcher
   {
      
      private var _rbMap:Dictionary = new Dictionary();
      
      private var _currentSelectedRadioButton:RadioButton;
      
      private var _number:uint = 0;
      
      public function RadioButtonGroup()
      {
         super();
      }
      
      public function add(param1:RadioButton) : void
      {
         if(this._rbMap[param1.ID])
         {
            this.remove(param1);
         }
         this._rbMap[param1.ID] = param1;
         ++this._number;
      }
      
      public function remove(param1:RadioButton) : void
      {
         if(this._rbMap[param1.ID])
         {
            this._rbMap[param1.ID] = null;
            delete this._rbMap[param1.ID];
            if(this._number > 0)
            {
               --this._number;
            }
         }
      }
      
      public function select(param1:RadioButton) : void
      {
         var _loc2_:RadioButton = null;
         if(this._currentSelectedRadioButton == param1)
         {
            return;
         }
         for each(_loc2_ in this._rbMap)
         {
            if(_loc2_.ID == param1.ID)
            {
               _loc2_.select();
               this._currentSelectedRadioButton = param1;
            }
            else
            {
               _loc2_.unselect();
            }
            _loc2_.forceRedraw();
         }
         dispatchEvent(new RadioButtonGroupEvent(this));
      }
      
      public function selectByData(param1:Object) : void
      {
         var _loc2_:RadioButton = null;
         for each(_loc2_ in this._rbMap)
         {
            if(_loc2_.data == param1)
            {
               _loc2_.select();
               this._currentSelectedRadioButton = _loc2_;
            }
            else
            {
               _loc2_.unselect();
            }
         }
         dispatchEvent(new RadioButtonGroupEvent(this));
      }
      
      public function get number() : uint
      {
         return this._number;
      }
      
      public function getSelectedRadionButton() : RadioButton
      {
         return this._currentSelectedRadioButton;
      }
   }
}

