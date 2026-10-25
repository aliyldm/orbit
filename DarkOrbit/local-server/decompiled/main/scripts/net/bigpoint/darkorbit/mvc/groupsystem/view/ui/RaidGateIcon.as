package net.bigpoint.darkorbit.mvc.groupsystem.view.ui
{
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import net.bigpoint.darkorbit.utils.textfield.TextFieldConstants;
   
   public class RaidGateIcon extends Sprite
   {
      
      private static const STD_CORNER_RADIUS:int = 6;
      
      private var _color:uint;
      
      private var _stageNumber:int;
      
      private var _stageNumberTextfield:TextField = new TextField();
      
      private var _borderSize:int = 0;
      
      private var _maxWidth:int = 2147483647;
      
      private var _maxHeight:int = 2147483647;
      
      private var _toolTip:ToolTipHook;
      
      private var _cornerRadius:int = 6;
      
      public function RaidGateIcon()
      {
         super();
         var _loc1_:TextFormat = new TextFormat(Styles.simpleFmt.font,Styles.achievementFontHeight);
         _loc1_.color = Styles.WHITE;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.leftMargin = 0;
         _loc1_.rightMargin = 0;
         this._stageNumberTextfield.embedFonts = Styles.baseEmbed;
         this._stageNumberTextfield.autoSize = TextFieldAutoSize.LEFT;
         this._stageNumberTextfield.defaultTextFormat = _loc1_;
         this._stageNumberTextfield.selectable = false;
         this._stageNumberTextfield.filters = [new DropShadowFilter(1,45,0,1,1,1)];
         this._toolTip = TooltipControl.getInstance().addToolTip(this,"-");
         this.init();
      }
      
      private function init() : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this);
         addChild(this._stageNumberTextfield);
         this.layoutTextAndBackground();
      }
      
      public function set stageNumber(param1:int) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != this._stageNumber)
         {
            this._stageNumber = param1;
            _loc2_ = this._stageNumberTextfield.width;
            this._stageNumberTextfield.text = this._stageNumber.toString();
            if(_loc2_ != this._stageNumberTextfield.width)
            {
               this.drawBackground();
            }
            this.layoutTextAndBackground();
         }
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Graphics = this.graphics;
         var _loc2_:Array = [this._color,3355443];
         var _loc3_:Array = [1,1];
         var _loc4_:Array = [0,255];
         var _loc5_:Matrix = new Matrix();
         var _loc6_:int = this._stageNumberTextfield.width + this._borderSize;
         var _loc7_:int = this._stageNumberTextfield.height + this._borderSize;
         _loc7_ = _loc7_ > this._maxHeight ? this._maxHeight : _loc7_;
         _loc6_ = _loc6_ > _loc7_ ? _loc6_ : _loc7_;
         _loc6_ = _loc6_ > this._maxWidth ? this._maxWidth : _loc6_;
         _loc5_.createGradientBox(_loc6_,_loc7_,FastMath.asRadians(90));
         _loc1_.clear();
         _loc1_.beginFill(1842204);
         _loc1_.drawRoundRect(0,0,_loc6_,_loc7_,this._cornerRadius);
         _loc1_.endFill();
         _loc1_.beginGradientFill(GradientType.LINEAR,_loc2_,_loc3_,_loc4_,_loc5_);
         _loc1_.drawRoundRect(this._borderSize,this._borderSize,_loc6_ - this._borderSize * 2,_loc7_ - this._borderSize * 2,this._cornerRadius);
         _loc1_.endFill();
      }
      
      private function layoutTextAndBackground() : void
      {
         this._stageNumberTextfield.x = (width - this._stageNumberTextfield.width) * 0.5;
         this._stageNumberTextfield.y = (height - this._stageNumberTextfield.height - TextFieldConstants.MAGIC_OFFSET) * 0.5;
      }
      
      public function set borderSize(param1:int) : void
      {
         if(this._borderSize != param1)
         {
            this._borderSize = param1;
         }
         this.layoutTextAndBackground();
      }
      
      public function set maxWidth(param1:int) : void
      {
         this._maxWidth = param1;
         this.layoutTextAndBackground();
      }
      
      public function set maxHeight(param1:int) : void
      {
         if(this._maxHeight != param1)
         {
            this._maxHeight = param1;
            this.layoutTextAndBackground();
            this.drawBackground();
         }
      }
      
      public function set inGate(param1:Boolean) : void
      {
         if(param1)
         {
            this.showGlow();
         }
         else
         {
            this.hideGlow();
         }
      }
      
      private function hideGlow() : void
      {
         this.filters = [];
      }
      
      private function getGlowfilter() : GlowFilter
      {
         return new GlowFilter(this._color,10,6,6,2,1,false,false);
      }
      
      private function showGlow() : void
      {
         this.filters = [this.getGlowfilter()];
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            this.drawBackground();
            this.layoutTextAndBackground();
         }
      }
      
      public function set toolTip(param1:String) : void
      {
         this._toolTip.updateText(param1);
      }
      
      public function set cornerRadius(param1:int) : void
      {
         if(param1 != this._cornerRadius)
         {
            this._cornerRadius = param1;
            this.drawBackground();
         }
      }
   }
}

