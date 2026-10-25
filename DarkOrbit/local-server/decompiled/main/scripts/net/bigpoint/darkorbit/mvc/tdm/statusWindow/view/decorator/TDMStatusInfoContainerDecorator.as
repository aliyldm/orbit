package net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator
{
   import flash.display.Shape;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusWindowConstants;
   
   public class TDMStatusInfoContainerDecorator
   {
      
      private var _livesRemainig:TextField;
      
      private var _timeLeft:TextField;
      
      private var _separator:Shape;
      
      private var _livesRemainigText:TextField;
      
      private var _timeLeftText:TextField;
      
      public function TDMStatusInfoContainerDecorator(param1:SimpleContainer)
      {
         super();
         this.decorate(param1);
      }
      
      private function decorate(param1:SimpleContainer) : void
      {
         this._livesRemainig = new TextField();
         this._timeLeft = new TextField();
         this._livesRemainigText = new TextField();
         this._timeLeftText = new TextField();
         this._separator = new Shape();
         this._separator.graphics.drawRect(0,0,0,TDMStatusWindowConstants.GAP_LOW);
         var _loc2_:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.infoFieldFontHeight,16777215,false);
         this._timeLeftText.defaultTextFormat = this._timeLeft.defaultTextFormat = this._livesRemainigText.defaultTextFormat = this._livesRemainig.defaultTextFormat = _loc2_;
         this._timeLeft.defaultTextFormat.align = TextFormatAlign.RIGHT;
         this._livesRemainig.defaultTextFormat.align = TextFormatAlign.RIGHT;
         this._livesRemainigText.embedFonts = this._timeLeftText.embedFonts = this._livesRemainig.embedFonts = this._timeLeft.embedFonts = Styles.baseEmbed;
         this._timeLeft.autoSize = this._livesRemainig.autoSize = TextFieldAutoSize.RIGHT;
         this._timeLeftText.autoSize = this._livesRemainigText.autoSize = TextFieldAutoSize.LEFT;
         this._timeLeftText.selectable = this._livesRemainigText.selectable = this._timeLeft.selectable = this._livesRemainig.selectable = false;
         param1.addElement(this._livesRemainigText,SimpleContainer.ALIGN_VERTICAL);
         param1.addElement(this._livesRemainig,SimpleContainer.ALIGN_HORIZONTAL);
         param1.addElement(this._timeLeftText,SimpleContainer.ALIGN_VERTICAL);
         param1.addElement(this._timeLeft,SimpleContainer.ALIGN_HORIZONTAL);
         param1.addElement(this._separator,SimpleContainer.ALIGN_VERTICAL);
         this.setPositions();
      }
      
      private function setPositions() : void
      {
         this._timeLeftText.x = this._timeLeft.x = this._livesRemainigText.x = this._livesRemainig.x = 0;
         this._timeLeft.width = this._livesRemainig.width = TDMStatusWindowConstants.CONTAINER_WIDTH;
      }
      
      public function get livesRemainig() : TextField
      {
         return this._livesRemainig;
      }
      
      public function get timeLeft() : TextField
      {
         return this._timeLeft;
      }
      
      public function get livesRemainigText() : TextField
      {
         return this._livesRemainigText;
      }
      
      public function get timeLeftText() : TextField
      {
         return this._timeLeftText;
      }
   }
}

