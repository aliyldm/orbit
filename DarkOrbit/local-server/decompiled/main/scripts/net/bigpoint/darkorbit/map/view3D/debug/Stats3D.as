package net.bigpoint.darkorbit.map.view3D.debug
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Stats3D extends Sprite
   {
      
      public static var ships:int = 0;
      
      public static var renderablesOpaque:int = 0;
      
      public static var renderablesTransparent:int = 0;
      
      private var _labelF:TextField;
      
      private var _updateInterval:uint;
      
      public function Stats3D()
      {
         super();
         this._labelF = new TextField();
         this._labelF.autoSize = TextFieldAutoSize.LEFT;
         this._labelF.border = this._labelF.background = false;
         this._labelF.defaultTextFormat = new TextFormat(null,10,16777215);
         addChild(this._labelF);
         filters = [new DropShadowFilter(1,0,0,1,2,2,1,0)];
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFrom);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         clearInterval(this._updateInterval);
         this._updateInterval = setInterval(this.update,500);
         Settings.showUI.changed.add(this.handleShowUIChanged);
         this.handleShowUIChanged();
      }
      
      private function handleRemovedFrom(param1:Event) : void
      {
         clearInterval(this._updateInterval);
         Settings.showUI.changed.remove(this.handleShowUIChanged);
      }
      
      private function handleShowUIChanged() : void
      {
         visible = Settings.showUI.value;
      }
      
      private function update() : void
      {
      }
   }
}

