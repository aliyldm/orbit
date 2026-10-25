package net.bigpoint.darkorbit.map.model.ship
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   
   public class MotherShipTrait extends EntityTraitBase implements IUpdatable
   {
      
      private static const _undockedMapObjects:Dictionary = new Dictionary();
      
      private var minions:Dictionary = new Dictionary();
      
      public function MotherShipTrait()
      {
         super();
      }
      
      public static function dockMinion(param1:int, param2:Ship, param3:int) : void
      {
         var _loc4_:Ship = ScreenManager.getInstance().map.getShipManager().getShip(param1) as Ship;
         if((Boolean(_loc4_)) && Boolean(_loc4_.getFirstTrait(MotherShipTrait)))
         {
            MotherShipTrait(_loc4_.getFirstTrait(MotherShipTrait)).dock(param2,param3);
         }
         else
         {
            if(_undockedMapObjects[param1] == null)
            {
               _undockedMapObjects[param1] = [];
            }
            _undockedMapObjects[param1].push({
               "minion":param2,
               "index":param3
            });
         }
      }
      
      public static function undockMinion(param1:int, param2:Ship) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param2 == null)
         {
            return;
         }
         var _loc3_:Ship = ScreenManager.getInstance().map.getShipManager().getShip(param1) as Ship;
         if(Boolean(_loc3_) && Boolean(_loc3_.getFirstTrait(MotherShipTrait)))
         {
            MotherShipTrait(_loc3_.getFirstTrait(MotherShipTrait)).undock(param2);
         }
         else if(_undockedMapObjects[param1] != null)
         {
            _loc4_ = _undockedMapObjects[param1];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_.minion == param2)
               {
                  _loc4_.splice(_loc5_,1);
                  break;
               }
               _loc5_++;
            }
         }
      }
      
      public static function clearDockingData() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in _undockedMapObjects)
         {
            _undockedMapObjects[_loc1_] = null;
            delete _undockedMapObjects[_loc1_];
         }
      }
      
      override public function activateTrait() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Array = _undockedMapObjects[owner.id] as Array;
         if(_loc1_ != null)
         {
            for each(_loc2_ in _loc1_)
            {
               this.dock(_loc2_.minion,_loc2_.index);
            }
            this.updateMinionsPositions();
            _undockedMapObjects[owner.id] = null;
            delete _undockedMapObjects[owner.id];
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         this.updateMinionsPositions();
      }
      
      private function undock(param1:MapEntity) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            AudioManager.playSoundEffect(112);
            for(_loc2_ in this.minions)
            {
               if(this.minions[_loc2_] == param1)
               {
                  this.minions[_loc2_] = null;
                  delete this.minions[_loc2_];
                  break;
               }
            }
         }
      }
      
      protected function updateMinionsPositions() : void
      {
         var _loc1_:String = null;
         var _loc2_:MapEntity = null;
         var _loc3_:BindablePointLite = null;
         for(_loc1_ in this.minions)
         {
            _loc2_ = this.minions[_loc1_] as MapEntity;
            if(_loc2_)
            {
               _loc3_ = owner.getPivot("dock_" + _loc1_);
               _loc2_.position.setTo(owner.x + _loc3_.x,owner.y + _loc3_.y,owner.z + _loc3_.z);
            }
         }
      }
      
      private function dock(param1:MapEntity, param2:int) : void
      {
         this.minions[param2] = param1;
         this.updateMinionsPositions();
      }
   }
}

