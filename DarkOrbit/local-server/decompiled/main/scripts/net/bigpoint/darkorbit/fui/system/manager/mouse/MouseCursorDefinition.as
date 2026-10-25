package net.bigpoint.darkorbit.fui.system.manager.mouse
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class MouseCursorDefinition
   {
      
      protected var _id:String;
      
      protected var _view:DisplayObject;
      
      private var _offsetX:Number = 0;
      
      private var _offsetY:Number = 0;
      
      private var _frameRate:Number = 0;
      
      public function MouseCursorDefinition(param1:String, param2:DisplayObject, param3:Number = 0, param4:Number = 0, param5:Number = 0)
      {
         super();
         this._id = param1;
         this._view = param2;
         this._offsetX = param3;
         this._offsetY = param4;
         this._frameRate = param5;
      }
      
      public function get view() : DisplayObject
      {
         return this._view;
      }
      
      public function get offsetX() : Number
      {
         return this._offsetX;
      }
      
      public function get offsetY() : Number
      {
         return this._offsetY;
      }
      
      public function get frameRate() : Number
      {
         return this._frameRate;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get leftSideBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         if(this.offsetX > 0)
         {
            _loc1_.width = Math.abs(this.offsetX);
         }
         if(this.offsetY > 0)
         {
            _loc1_.height = Math.abs(this.offsetY);
         }
         return _loc1_;
      }
      
      public function get rightSideBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.width = this._view.width + this.offsetX;
         _loc1_.width = this._view.height + this.offsetY;
         return _loc1_;
      }
   }
}

