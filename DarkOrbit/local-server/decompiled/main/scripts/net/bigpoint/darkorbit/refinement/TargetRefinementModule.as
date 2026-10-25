package net.bigpoint.darkorbit.refinement
{
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class TargetRefinementModule extends RefinementModule
   {
      
      private static const EMBEDDED_BITMAP__TARGET_SLOT:String = "targetSlot";
      
      private static const EMBEDDED_BITMAP__TARGET_ICON:String = "targetIcon";
      
      private static const HIGHLIGHT__LINEWIDTH:Number = 2;
      
      private static const HIGHLIGHT__COLOR:uint = 16770048;
      
      private static const HIGHLIGHT__ALPHA:Number = 0.5;
      
      public static const MAX_VALUE:int = 1000000;
      
      private const HIGHLIGHT:String = "highlight";
      
      private var _targetIcon:Bitmap;
      
      private var _identifier:String;
      
      private var _ammountKey:String;
      
      private var _oreIcon:OreIcon;
      
      private var _iconBgnd:Sprite;
      
      private var _amount:int;
      
      public function TargetRefinementModule(param1:RefinementManager, param2:int, param3:String, param4:String, param5:String, param6:String)
      {
         super(param1,param2,param3,param4);
         this._identifier = param5;
         this._ammountKey = param6;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 4;
         _background = finisher.getEmbeddedBitmap(EMBEDDED_BITMAP__TARGET_SLOT);
         this.addChild(_background);
         var _loc2_:Bitmap = finisher.getEmbeddedBitmap(resKey);
         _loc2_.x = _background.width / 2 - _loc2_.width / 2;
         _loc2_.y = _background.height / 2 - _loc2_.height / 2;
         this.addChild(_loc2_);
         this._targetIcon = finisher.getEmbeddedBitmap(EMBEDDED_BITMAP__TARGET_ICON);
         this._targetIcon.x = _loc1_;
         this._targetIcon.y = _background.height - this._targetIcon.height - _loc1_;
         this.addChild(this._targetIcon);
         this._iconBgnd = new Sprite();
         this._iconBgnd.buttonMode = true;
         this._iconBgnd.x = this._targetIcon.x;
         this._iconBgnd.y = this._targetIcon.y;
         var _loc3_:Graphics = this._iconBgnd.graphics;
         _loc3_.beginFill(16777215,0);
         _loc3_.drawRect(0,0,this._targetIcon.width,this._targetIcon.height);
         _loc3_.endFill();
         addChild(this._iconBgnd);
         setLabels();
         this.setAmmount(0);
      }
      
      public function removeOreIcon() : void
      {
         if(this._oreIcon != null && this.contains(this._oreIcon))
         {
            this.removeChild(this._oreIcon);
         }
         this._oreIcon = null;
      }
      
      public function setOreIcon(param1:OreIcon) : void
      {
         this._oreIcon = param1;
         this._oreIcon.x = this.targetIcon.x + 1;
         this._oreIcon.y = this.targetIcon.y + 1;
         this.addChild(this._oreIcon);
         this.updateTooltip(param1 ? param1.tooltipKey : null);
      }
      
      private function updateTooltip(param1:String) : void
      {
         var _loc2_:String = BPLocale.getItem(param1);
         var _loc3_:ToolTipHook = TooltipControl.getInstance().getToolTipForObject(this._iconBgnd);
         if(_loc3_ == null)
         {
            TooltipControl.getInstance().addToolTip(this._iconBgnd,_loc2_);
         }
         else
         {
            _loc3_.updateText(_loc2_);
         }
      }
      
      public function get targetIcon() : Bitmap
      {
         return this._targetIcon;
      }
      
      public function get identifier() : String
      {
         return this._identifier;
      }
      
      public function setAmmount(param1:int) : void
      {
         this._amount = param1;
         labelAmmount.setText(BPLocale.getItem(this._ammountKey).replace("%COUNT%",param1.toString()));
      }
      
      public function getAmmount() : int
      {
         return this._amount;
      }
      
      public function get maxAmount() : Number
      {
         return MAX_VALUE - this._amount;
      }
      
      public function get oreType() : int
      {
         if(this._oreIcon != null)
         {
            return this._oreIcon.id;
         }
         return 0;
      }
      
      public function get oreIcon() : OreIcon
      {
         return this._oreIcon;
      }
      
      public function highlight() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.name = this.HIGHLIGHT;
         _loc1_.graphics.lineStyle(HIGHLIGHT__LINEWIDTH,HIGHLIGHT__COLOR,HIGHLIGHT__ALPHA);
         _loc1_.graphics.drawRect(this._targetIcon.x,this._targetIcon.y,this._targetIcon.width,this._targetIcon.height);
         addChild(_loc1_);
      }
      
      public function removeHighlight() : void
      {
         var _loc1_:DisplayObject = getChildByName(this.HIGHLIGHT);
         if(_loc1_ != null)
         {
            removeChild(_loc1_);
         }
      }
   }
}

