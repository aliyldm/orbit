package com.bigpoint.utils.ui.buttons
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   
   public class ImagesStatesButton extends StatesButtonDecorator
   {
      
      private var _backgroundBitmapData:BitmapData;
      
      private var _rollOverBitmapData:BitmapData;
      
      private var _selectedBitmapData:BitmapData;
      
      public function ImagesStatesButton(param1:DisplayObjectContainer, param2:BitmapData, param3:BitmapData, param4:BitmapData, param5:BitmapData = null)
      {
         super(param1);
         this.addState(background,this._backgroundBitmapData = param2);
         this.addState(rollOverState,this._rollOverBitmapData = param3);
         this.addState(mouseDownState,this._rollOverBitmapData);
         this.addState(selectedState,this._selectedBitmapData = param5);
         if(param5)
         {
            this.addState(selectedState,this._selectedBitmapData = param5);
         }
      }
      
      private function addState(param1:DisplayObjectContainer, param2:BitmapData) : void
      {
         if(param2)
         {
            param1.addChild(new Bitmap(param2));
         }
      }
   }
}

