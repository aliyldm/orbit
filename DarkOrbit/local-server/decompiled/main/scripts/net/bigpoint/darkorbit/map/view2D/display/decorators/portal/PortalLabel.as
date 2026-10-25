package net.bigpoint.darkorbit.map.view2D.display.decorators.portal
{
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.mvc.display.IDOTextField;
   
   public class PortalLabel implements IDisposable
   {
      
      private var _textField:IDOTextField;
      
      private var _alpha:Number = 1;
      
      private var _position:Point;
      
      private var _shakeInterval:uint;
      
      private var _text:String = "";
      
      public function PortalLabel(param1:IDOTextField)
      {
         super();
         this._textField = param1;
         this._shakeInterval = setInterval(this.shake,300);
         this._alpha = this._textField.alpha;
         this._position = new Point(this._textField.x,this._textField.y);
         this._textField.htmlText = this._text;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         if(this._textField)
         {
            this._textField.htmlText = param1;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         clearInterval(this._shakeInterval);
      }
      
      private function shake() : void
      {
         if(this._textField)
         {
            this.internalShake();
            setTimeout(this.internalShake,30);
            setTimeout(this.internalShake,50);
            setTimeout(this.internalShake,70);
            setTimeout(this.internalShake,90);
            setTimeout(this.internalShake,120);
            setTimeout(this.internalShake,130);
            setTimeout(this.shakeEnd,140);
         }
      }
      
      private function shakeEnd() : void
      {
         this._textField.alpha = this._alpha;
      }
      
      private function internalShake() : void
      {
         this._textField.x = int(this._position.x + Math.random() * 3 - 1.5);
         this._textField.y = int(this._position.y + Math.random() * 3 - 1.5);
         this._textField.alpha = Math.random() * this._alpha;
      }
   }
}

