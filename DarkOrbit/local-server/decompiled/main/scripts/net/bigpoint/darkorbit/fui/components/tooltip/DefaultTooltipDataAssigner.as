package net.bigpoint.darkorbit.fui.components.tooltip
{
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   
   public class DefaultTooltipDataAssigner implements ITooltipDataAssigner
   {
      
      protected static const DEFAULT_LABEL_INSTANCE_NAME:String = "label";
      
      protected static const DEFAULT_BACKGROUND_INSTANCE_NAME:String = "background";
      
      protected var _target:Coreponent;
      
      protected var _data:Object;
      
      private var _maxWidth:Number = 180;
      
      public function DefaultTooltipDataAssigner()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function set target(param1:Coreponent) : void
      {
         this._target = param1;
      }
      
      public function hasTarget() : Boolean
      {
         return this._target != null;
      }
      
      public function assign() : void
      {
         this.setLabelText(String(this._data));
      }
      
      protected function setLabelText(param1:String) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:LabelSkin = null;
         var _loc4_:Label = this._target.getChildByName(DEFAULT_LABEL_INSTANCE_NAME) as Label;
         if(_loc4_)
         {
            _loc4_.autoSizeTextWidth = true;
            _loc4_.autoSizeTextHeight = true;
            _loc4_.text = param1;
            _loc4_.forceRedraw(InvalidationType.SIZE);
            _loc2_ = _loc4_.width;
            _loc3_ = _loc4_.height;
            if(_loc2_ > this._maxWidth)
            {
               _loc5_ = _loc4_.skin as LabelSkin;
               _loc5_.textField.multiline = true;
               _loc5_.textField.wordWrap = true;
               _loc5_.textField.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.textField.width = this._maxWidth;
               _loc5_.textField.htmlText = param1;
            }
         }
      }
      
      public function set maxWidth(param1:Number) : void
      {
         this._maxWidth = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get target() : Coreponent
      {
         return this._target;
      }
   }
}

