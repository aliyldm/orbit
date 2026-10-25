package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapDotTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class ShipMiniMapIcon extends MiniMapDotTrait
   {
      
      private static const DISTANCE:int = 3;
      
      private static const Y_OFFSET:int = 11;
      
      private static const X_OFFSET:int = 12;
      
      private static const LEFT_ALERT_RESKEY:String = "mapIcon_alert_left";
      
      private static const RIGHT_ALERT_RESKEY:String = "mapIcon_alert_right";
      
      private static const ABOVE_ALERT_RESKEY:String = "mapIcon_alert_above";
      
      private static const BELOW_ALERT_RESKEY:String = "mapIcon_alert_below";
      
      private var left:BitmapData;
      
      private var right:BitmapData;
      
      private var above:BitmapData;
      
      private var below:BitmapData;
      
      public function ShipMiniMapIcon(param1:uint = 16711680)
      {
         super(param1);
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         ResourceManager.fileCollection.load("minimap",this.handleResourcesLoadComplete);
      }
      
      override public function deactivateTrait() : void
      {
         ResourceManager.fileCollection.removeCallbacks("minimap",this.handleResourcesLoadComplete);
         super.deactivateTrait();
      }
      
      private function handleResourcesLoadComplete(param1:SWFFinisher) : void
      {
         this.left = param1.hasEmbeddedObject(LEFT_ALERT_RESKEY) ? param1.getEmbeddedBitmapData(LEFT_ALERT_RESKEY) : null;
         this.right = param1.hasEmbeddedObject(RIGHT_ALERT_RESKEY) ? param1.getEmbeddedBitmapData(RIGHT_ALERT_RESKEY) : null;
         this.above = param1.hasEmbeddedObject(ABOVE_ALERT_RESKEY) ? param1.getEmbeddedBitmapData(ABOVE_ALERT_RESKEY) : null;
         this.below = param1.hasEmbeddedObject(BELOW_ALERT_RESKEY) ? param1.getEmbeddedBitmapData(BELOW_ALERT_RESKEY) : null;
         this.update();
      }
      
      protected function get ship() : Ship
      {
         return owner as Ship;
      }
      
      override protected function update() : void
      {
         super.update();
         var _loc1_:Boolean = false;
         if(owner.position.x * _scale < DISTANCE)
         {
            _icon.x = DISTANCE;
            _loc1_ = true;
            (_icon as Bitmap).bitmapData = this.left;
         }
         if(owner.position.x * _scale > _miniMapWidth - DISTANCE)
         {
            _icon.x = _miniMapWidth - X_OFFSET;
            _loc1_ = true;
            (_icon as Bitmap).bitmapData = this.right;
         }
         if(owner.position.y * _scale < DISTANCE)
         {
            _icon.y = DISTANCE;
            _loc1_ = true;
            (_icon as Bitmap).bitmapData = this.above;
         }
         if(owner.position.y * _scale > _miniMapHeight - DISTANCE)
         {
            _icon.y = _miniMapHeight - Y_OFFSET;
            _loc1_ = true;
            (_icon as Bitmap).bitmapData = this.below;
         }
         if(!_loc1_)
         {
            reset();
         }
      }
   }
}

