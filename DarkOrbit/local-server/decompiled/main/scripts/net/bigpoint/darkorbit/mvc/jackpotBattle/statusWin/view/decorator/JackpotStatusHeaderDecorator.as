package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator
{
   import flash.filters.GlowFilter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class JackpotStatusHeaderDecorator
   {
      
      private static const ROUND_LABLE_FILTER:Array = [new GlowFilter(16711680,0.5,6,6,2,1,false)];
      
      private var _headContainer:SimpleContainer;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _remainingPlayerText:String = BPLocale.getItem("jackpot_status_window_remaining_players_message");
      
      private var _roundText:String = BPLocale.getItem("jackpot_status_window_round_message");
      
      private var _roundTextfield:TextFieldElement;
      
      private var _remainingOfRegisterdTextfield:TextFieldElement;
      
      public function JackpotStatusHeaderDecorator(param1:SimpleContainer, param2:Number, param3:Number)
      {
         super();
         this._height = param3;
         this._width = param2;
         this._headContainer = param1;
         this.createHeader();
      }
      
      private function createHeader() : void
      {
         this.addTextFieldRegisterdOfRemainig();
         this.addRoundTextField();
      }
      
      private function addTextFieldRegisterdOfRemainig() : void
      {
         this._remainingOfRegisterdTextfield = new TextFieldElement(this._width,20,Styles.simpleFmtWhite);
         this._headContainer.addElement(this._remainingOfRegisterdTextfield,SimpleContainer.ALIGN_VERTICAL);
      }
      
      private function addRoundTextField() : void
      {
         this._roundTextfield = new TextFieldElement(this._width,20,Styles.jackpotWindowRoundFmt);
         if(Settings.qualityExplosion.value >= Settings.QUALITY_HIGH)
         {
            this._roundTextfield.filters = ROUND_LABLE_FILTER;
         }
         else
         {
            this._roundTextfield.filters = [];
         }
         this._headContainer.addElement(this._roundTextfield,SimpleContainer.ALIGN_VERTICAL);
      }
      
      public function updateRemainingPlayers(param1:int, param2:int) : void
      {
         var _loc3_:String = this._remainingPlayerText.replace(/%COUNT%/,param1).replace(/%TOTAL%/,param2);
         this._remainingOfRegisterdTextfield.updateText(_loc3_);
      }
      
      public function updateRoundCount(param1:int) : void
      {
         var _loc2_:String = this._roundText.replace(/%COUNT%/,param1);
         this._roundTextfield.updateText(_loc2_);
      }
      
      public function get remainingOfRegisterdTextfield() : TextFieldElement
      {
         return this._remainingOfRegisterdTextfield;
      }
   }
}

