package net.bigpoint.darkorbit.equipment.view.components.items
{
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   
   public class PopUpBig extends PopUp
   {
      
      public function PopUpBig(param1:PopUpDefiner)
      {
         super(param1);
      }
      
      override protected function getBackgroundSprite() : Sprite
      {
         return AssetProxy.getMovieClip("scrollComponents","popUpBigBg");
      }
      
      override protected function getTitleTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.height = 35;
         _loc1_.width = 322;
         _loc1_.selectable = false;
         _loc1_.x = 20;
         _loc1_.y = 11;
         _loc1_.textColor = 16777215;
         var _loc2_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,14);
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.bold = true;
         _loc1_.defaultTextFormat = _loc2_;
         return _loc1_;
      }
      
      override protected function getMainTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.selectable = false;
         _loc1_.textColor = 16777215;
         _loc1_.wordWrap = true;
         _loc1_.multiline = true;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.height = 220;
         _loc1_.width = 500;
         _loc1_.x = 40;
         _loc1_.y = 62;
         var _loc2_:TextFormat = new TextFormat(Styles.baseEmbed ? "Verdana" : null,11);
         _loc2_.align = TextFormatAlign.LEFT;
         _loc1_.defaultTextFormat = _loc2_;
         return _loc1_;
      }
   }
}

