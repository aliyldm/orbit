package net.bigpoint.darkorbit.gui.windows.components
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.utils.ColorUtils;
   
   public class LifeCounterComponent extends Sprite
   {
      
      private var lives:int;
      
      private var maxLives:int;
      
      private var overFlowMode:Boolean = false;
      
      public var maxDisplayWidth:int;
      
      private var livesRemainingBitmapData:BitmapData;
      
      private var lifeLostBitmapData:BitmapData;
      
      private var textField:TextField;
      
      private var updateLivesDisplay:Function;
      
      private var combo:Number;
      
      private var comboMax:Number;
      
      private var comboEmptyColour:uint = 16777215;
      
      private var comboMaxColour:uint = 12255232;
      
      public function LifeCounterComponent(param1:Boolean = false)
      {
         super();
         if(param1)
         {
            this.livesRemainingBitmapData = ResourceManager.getBitmapData("ui","lives_small_ship_icon");
            this.updateLivesDisplay = this.updateDynamicColouredLives;
         }
         else
         {
            this.livesRemainingBitmapData = ResourceManager.getBitmapData("ui","lives_remaining_icon");
            this.lifeLostBitmapData = ResourceManager.getBitmapData("ui","life_lost_icon");
            this.updateLivesDisplay = this.updateNonDynamicColouredLives;
         }
         this.textField = new TextField();
      }
      
      public function setRemainingLives(param1:int, param2:int) : void
      {
         this.lives = param1;
         this.maxLives = param2;
         this.graphics.clear();
         this.updateLivesDisplay();
      }
      
      private function updateDynamicColouredLives() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:ColorTransform = null;
         if(this.lives * this.livesRemainingBitmapData.width < this.maxDisplayWidth)
         {
            if(this.contains(this.textField))
            {
               this.removeChild(this.textField);
            }
            this.graphics.beginBitmapFill(this.livesRemainingBitmapData);
            this.graphics.drawRect(0,0,this.livesRemainingBitmapData.width * this.lives,this.livesRemainingBitmapData.height);
            this.graphics.endFill();
            _loc1_ = this.combo / this.comboMax;
            _loc2_ = new ColorTransform();
            _loc2_.color = ColorUtils.interpolate(this.comboEmptyColour,this.comboMaxColour,_loc1_);
            this.transform.colorTransform = _loc2_;
         }
         else
         {
            this.updateTextFieldDisplay();
         }
      }
      
      private function updateNonDynamicColouredLives() : void
      {
         var _loc1_:int = 0;
         if(this.lives * this.livesRemainingBitmapData.width < this.maxDisplayWidth)
         {
            if(this.contains(this.textField))
            {
               this.removeChild(this.textField);
            }
            _loc1_ = this.maxLives - this.lives;
            this.graphics.beginBitmapFill(this.livesRemainingBitmapData);
            this.graphics.drawRect(0,0,this.livesRemainingBitmapData.width * this.lives,this.livesRemainingBitmapData.height);
            this.graphics.beginBitmapFill(this.lifeLostBitmapData);
            this.graphics.drawRect(this.livesRemainingBitmapData.width * this.lives,0,this.lifeLostBitmapData.width * _loc1_,this.lifeLostBitmapData.height);
            this.graphics.endFill();
         }
         else
         {
            this.updateTextFieldDisplay();
         }
      }
      
      private function updateTextFieldDisplay() : void
      {
         this.textField.defaultTextFormat = Styles.infoFieldFmt;
         this.textField.embedFonts = Styles.infoFieldEmbed;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.mouseEnabled = false;
         this.textField.selectable = false;
         var _loc1_:int = int(Styles.infoFieldFmt.color);
         this.textField.textColor = _loc1_;
         this.textField.height = 20;
         this.textField.text = String(this.lives) + " / " + String(this.maxLives);
         this.addChild(this.textField);
      }
      
      public function setComboValues(param1:Number, param2:Number) : void
      {
         if(this.combo != param1 || param2 != this.comboMax)
         {
            this.combo = param1;
            this.comboMax = param2;
            this.updateLivesDisplay();
         }
      }
   }
}

