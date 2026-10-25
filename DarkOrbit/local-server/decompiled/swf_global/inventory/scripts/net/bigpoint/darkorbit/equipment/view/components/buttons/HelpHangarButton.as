package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HelpHangarButton extends AbstractButton
   {
      
      private static var normal:Class = HelpHangarButton_normal;
      
      private static var active:Class = HelpHangarButton_active;
      
      private var _normalBitmap:Bitmap;
      
      private var _activeBitmap:Bitmap;
      
      public function HelpHangarButton()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._normalBitmap = new normal();
         addChild(this._normalBitmap);
         this._activeBitmap = new active();
         this._activeBitmap.visible = false;
         addChild(this._activeBitmap);
         var _loc1_:Sprite = new Sprite();
         _loc1_.alpha = 0;
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16711782);
         _loc2_.drawRect(0,0,this._normalBitmap.width,this._normalBitmap.height);
         _loc2_.endFill();
         _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDownEvent);
         _loc1_.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUpEvent);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOutEvent);
         addChild(_loc1_);
      }
      
      private function handleMouseDownEvent(param1:MouseEvent) : void
      {
         this._activeBitmap.visible = true;
         this._normalBitmap.visible = false;
      }
      
      private function handleMouseUpEvent(param1:MouseEvent) : void
      {
         this._activeBitmap.visible = false;
         this._normalBitmap.visible = true;
      }
      
      private function handleMouseRollOutEvent(param1:MouseEvent) : void
      {
         this._activeBitmap.visible = false;
         this._normalBitmap.visible = true;
      }
   }
}

