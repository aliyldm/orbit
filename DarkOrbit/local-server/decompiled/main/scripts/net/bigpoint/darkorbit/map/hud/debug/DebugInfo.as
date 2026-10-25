package net.bigpoint.darkorbit.map.hud.debug
{
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.tools.DebugInfoTrait;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   
   public class DebugInfo extends AbstractHUDElement implements IDisposable
   {
      
      private var _target:DebugInfoTrait;
      
      private var _labelF:TextField;
      
      public function DebugInfo(param1:IMapView, param2:DebugInfoTrait)
      {
         super(param1,param2.owner.position);
         this._labelF = new TextField();
         this._labelF.autoSize = TextFieldAutoSize.CENTER;
         this._labelF.multiline = true;
         this._labelF.wordWrap = true;
         this._labelF.width = 300;
         this._labelF.defaultTextFormat = new TextFormat(null,12,16777215);
         this._labelF.filters = [new GlowFilter(1,1,2,2,10,1)];
         addChild(this._labelF);
         cacheAsBitmap = true;
         this._target = param2;
         this._target.info1.changed.add(this.updateLabel);
         this._target.info2.changed.add(this.updateLabel);
         this.updateLabel();
      }
      
      private function updateLabel() : void
      {
         var _loc1_:Array = [];
         if(this._target.info1.value)
         {
            _loc1_.push(this._target.info1.value);
         }
         if(this._target.info2.value)
         {
            _loc1_.push(this._target.info2.value);
         }
         this._labelF.text = _loc1_.join("\n");
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._target.info1.changed.remove(this.updateLabel);
         this._target.info2.changed.remove(this.updateLabel);
         if(parent)
         {
            parent.removeChild(this);
         }
         super.disposeView(param1);
      }
   }
}

