package net.bigpoint.darkorbit.questfm.rewardsList
{
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.Styles;
   
   public class QuestRewardsListRow extends Sprite
   {
      
      private static const MARGIN:int = 15;
      
      private var _rewardNameF:TextField;
      
      private var _amountF:TextField;
      
      public function QuestRewardsListRow(param1:String, param2:String)
      {
         super();
         this._rewardNameF = this.createTextField();
         this._rewardNameF.autoSize = TextFieldAutoSize.LEFT;
         this._rewardNameF.htmlText = param1;
         addChild(this._rewardNameF);
         this._amountF = this.createTextField();
         this._amountF.autoSize = TextFieldAutoSize.LEFT;
         this._amountF.htmlText = param2;
         addChild(this._amountF);
         this.updateLayout();
      }
      
      private function updateLayout() : void
      {
         this._amountF.x = this._rewardNameF.x + this._rewardNameF.width + MARGIN;
      }
      
      private function createTextField(param1:Boolean = false) : TextField
      {
         var _loc3_:TextField = null;
         var _loc2_:TextFormat = param1 ? new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936) : new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFmt.size,15327936);
         _loc3_ = new TextField();
         _loc3_.defaultTextFormat = _loc2_;
         _loc3_.embedFonts = Styles.strongStdEmbed;
         _loc3_.antiAliasType = AntiAliasType.ADVANCED;
         _loc3_.mouseEnabled = Main.mouseEventsEnabled;
         _loc3_.selectable = false;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.x = 4;
         _loc3_.y = 8;
         return _loc3_;
      }
   }
}

