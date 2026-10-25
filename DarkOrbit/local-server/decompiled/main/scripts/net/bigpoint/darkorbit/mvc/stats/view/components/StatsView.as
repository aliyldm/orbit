package net.bigpoint.darkorbit.mvc.stats.view.components
{
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.mvc.stats.model.vo.StatsVO;
   import net.hires.debug.Stats;
   
   public class StatsView extends Sprite
   {
      
      private var _text:TextField;
      
      private var _stats:Stats;
      
      public function StatsView()
      {
         super();
         this.mouseEnabled = this.mouseChildren = false;
      }
      
      public function init() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Verdana";
         _loc1_.size = 9;
         this._text = new TextField();
         this._text.defaultTextFormat = _loc1_;
         this._text.autoSize = TextFieldAutoSize.LEFT;
         this._text.textColor = 16777215;
         this._text.background = true;
         this._text.backgroundColor = 6710886;
         this._text.antiAliasType = AntiAliasType.ADVANCED;
         this._text.selectable = false;
      }
      
      public function update(param1:StatsVO) : void
      {
         var _loc2_:String = param1.currentMem.toFixed(2) + "MB";
         var _loc3_:String = "";
         if(param1.joinedParams != "")
         {
            _loc3_ = param1.joinedParams + " ";
         }
         _loc3_ += "FPS: " + param1.currentFPS + " | MEM: " + _loc2_;
         this._text.text = "v" + Main.VERSION + " | " + _loc3_;
      }
      
      public function show() : void
      {
         visible = true;
         if(!this.contains(this._text))
         {
            this.addChild(this._text);
         }
      }
      
      public function hide() : void
      {
         visible = false;
         if(this.contains(this._text))
         {
            this.removeChild(this._text);
         }
      }
   }
}

