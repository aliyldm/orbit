package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.FadableButtonIconSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   
   public class HintSystemOverlistItemRendererSkin extends FadableButtonIconSkin
   {
      
      private static const Y_OFFSET_LABEL:uint = 1;
      
      private static const XPOS_OVER:uint = 30;
      
      private static const XPOS_NORMAL:uint = 24;
      
      public function HintSystemOverlistItemRendererSkin()
      {
         super();
      }
      
      override public function init() : void
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,1,1);
         _loc2_.endFill();
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Graphics = _loc3_.graphics;
         _loc4_.beginFill(0,0.5);
         _loc4_.drawRect(0,0,1,1);
         _loc4_.endFill();
         var _loc5_:DisplayObject = ResourceManager.getBitmap(HintSystemConstants.LIBRARY_NAME,"icon_bulletpoint_normal");
         var _loc6_:DisplayObject = ResourceManager.getBitmap(HintSystemConstants.LIBRARY_NAME,"icon_bulletpoint_over");
         setSkinLayer(SkinLayerNames.NORMAL,_loc1_);
         setSkinLayer(SkinLayerNames.OVER,_loc3_);
         setSkinLayer(SkinLayerNames.ICON_NORMAL,_loc5_);
         setSkinLayer(SkinLayerNames.ICON_OVER,_loc6_);
         super.init();
         this._textMarginX = XPOS_NORMAL;
         var _loc7_:DisplayObject = this.getSkinLayer(SkinLayerNames.ICON_NORMAL);
         var _loc8_:DisplayObject = this.getSkinLayer(SkinLayerNames.ICON_OVER);
         _loc7_.x = 6;
         _loc8_.x = 6;
      }
      
      override public function set textMarginX(param1:uint) : void
      {
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         var _loc2_:DisplayObject = this.getSkinLayer(SkinLayerNames.ICON_NORMAL);
         var _loc3_:DisplayObject = this.getSkinLayer(SkinLayerNames.ICON_OVER);
         var _loc4_:Number = param1 - _loc2_.height >> 1;
         _loc2_.y = _loc4_;
         _loc3_.y = _loc4_;
         this._msgLabel.y += Y_OFFSET_LABEL;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
      }
      
      override protected function setCurrentSkinState(param1:String) : void
      {
         super.setCurrentSkinState(param1);
         switch(param1)
         {
            case SkinLayerNames.NORMAL:
               TweenLite.to(this._msgLabel,0.5,{"x":XPOS_NORMAL});
               break;
            case SkinLayerNames.OVER:
               TweenLite.to(this._msgLabel,0.5,{"x":XPOS_OVER});
         }
      }
   }
}

