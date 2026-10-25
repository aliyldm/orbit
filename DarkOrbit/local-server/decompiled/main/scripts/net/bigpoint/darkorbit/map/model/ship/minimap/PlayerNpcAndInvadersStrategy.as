package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.InvaderTrait;
   
   public class PlayerNpcAndInvadersStrategy extends ShipMiniMapIcon
   {
      
      public static const INVADER:int = 4293787648;
      
      public static const NPC:int = 4294901760;
      
      public static const PLAYER:int = 4278229503;
      
      public static const HERO:int = 4278229503;
      
      public function PlayerNpcAndInvadersStrategy()
      {
         super();
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         this.updateRelations();
      }
      
      public function updateRelations() : void
      {
         var _loc2_:MapEntity = null;
         var _loc1_:Bitmap = _icon as Bitmap;
         _loc1_.bitmapData = BITMAP_DATA;
         if(ship.isNPC)
         {
            color = NPC;
         }
         else if(ship is Pet)
         {
            _loc2_ = ScreenManager.getInstance().map.getEntityById((ship as Pet).ownerID);
            if(_loc2_)
            {
               if(_loc2_.id == Hero.userID)
               {
                  color = HERO;
               }
               else
               {
                  this.updateColorToObject(_loc2_);
               }
            }
            else
            {
               this.updateColorToObject(ship);
            }
         }
         else if(ship.isHeroShip())
         {
            color = HERO;
         }
         else
         {
            this.updateColorToObject(ship);
         }
      }
      
      private function updateColorToObject(param1:MapEntity) : void
      {
         var _loc6_:BitmapData = null;
         var _loc2_:Bitmap = _icon as Bitmap;
         var _loc3_:Ship = ScreenManager.getInstance().map.hero;
         var _loc4_:Boolean = _loc3_ ? _loc3_.getFirstTrait(InvaderTrait) != null : false;
         var _loc5_:Boolean = param1.getFirstTrait(InvaderTrait) != null;
         color = _loc4_ == _loc5_ ? uint(PLAYER) : uint(INVADER);
         if(!_loc4_ && _loc5_)
         {
            _loc6_ = ResourceManager.getBitmapData("minimap","mapIcon_alert");
            _loc2_.transform.colorTransform = new ColorTransform();
            _loc2_.bitmapData = _loc6_;
         }
      }
      
      override public function reset() : void
      {
         this.updateRelations();
      }
   }
}

