package net.bigpoint.darkorbit.equipment.view.components.buttons
{
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class FavouriteHangarButton extends AbstractButton
   {
      
      private static var disabled:Class = FavouriteHangarButton_disabled;
      
      private static var enabled:Class = FavouriteHangarButton_enabled;
      
      private static var enabled_clicked:Class = FavouriteHangarButton_enabled_clicked;
      
      private static var enabled_over:Class = FavouriteHangarButton_enabled_over;
      
      private var _isActive:Boolean;
      
      private var _disabledBitmap:Bitmap;
      
      private var _enabledBitmap:Bitmap;
      
      private var _enabledClickedBitmap:Bitmap;
      
      private var _enabledOverBitmap:Bitmap;
      
      public function FavouriteHangarButton()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._disabledBitmap = new disabled();
         this._disabledBitmap.visible = false;
         addChild(this._disabledBitmap);
         this._enabledBitmap = new enabled();
         this._enabledBitmap.visible = false;
         addChild(this._enabledBitmap);
         this._enabledClickedBitmap = new enabled_clicked();
         this._enabledClickedBitmap.visible = false;
         addChild(this._enabledClickedBitmap);
         this._enabledOverBitmap = new enabled_over();
         this._enabledOverBitmap.visible = false;
         addChild(this._enabledOverBitmap);
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16711782);
         _loc2_.drawRect(0,0,this._disabledBitmap.width,this._disabledBitmap.height);
         _loc2_.endFill();
         _loc1_.alpha = 0;
         _loc1_.addEventListener(MouseEvent.CLICK,this.handleMouseEventClickEvent);
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.handleMouseRollOverEvent);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.handleMouseRollOutEvent);
         addChild(_loc1_);
         this.activate();
      }
      
      public function isActive() : Boolean
      {
         return this._isActive;
      }
      
      private function activate() : void
      {
         this._isActive = true;
      }
      
      private function deactivate() : void
      {
         this._isActive = false;
      }
      
      private function handleMouseEventClickEvent(param1:MouseEvent) : void
      {
         if(this.isActive())
         {
            this.deactivate();
         }
         else
         {
            this.activate();
         }
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function handleMouseRollOverEvent(param1:MouseEvent) : void
      {
      }
      
      private function handleMouseRollOutEvent(param1:MouseEvent) : void
      {
      }
   }
}

