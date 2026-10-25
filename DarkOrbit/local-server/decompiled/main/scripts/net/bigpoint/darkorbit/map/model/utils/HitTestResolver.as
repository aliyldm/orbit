package net.bigpoint.darkorbit.map.model.utils
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   
   public class HitTestResolver
   {
      
      private const _hittestArray:Vector.<MouseHitAreaTrait> = new Vector.<MouseHitAreaTrait>();
      
      private var _clickableList:EntityTraitContainer;
      
      private var _currentlyHovered:MouseHitAreaTrait;
      
      private var _map:Map;
      
      public function HitTestResolver()
      {
         super();
      }
      
      public function set map(param1:Map) : void
      {
         var _loc2_:MouseHitAreaTrait = null;
         if(this._clickableList)
         {
            this._clickableList.traitAdded.remove(this.handleTraitAdded);
            this._clickableList.traitRemoved.remove(this.handleTraitRemoved);
            this._hittestArray.length = 0;
            if(this._currentlyHovered)
            {
               this._currentlyHovered.mouseOut();
               this._currentlyHovered = null;
            }
         }
         this._map = param1;
         if(this._map)
         {
            this._clickableList = this._map.getTraitsList(MouseHitAreaTrait);
            this._clickableList.traitAdded.add(this.handleTraitAdded);
            this._clickableList.traitRemoved.add(this.handleTraitRemoved);
            for each(_loc2_ in this._clickableList.traits)
            {
               this.handleTraitAdded(_loc2_);
            }
         }
      }
      
      public function hoverTest(param1:int, param2:int) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:MouseHitAreaTrait = null;
         if(this.mapView == null || this._map == null)
         {
            return false;
         }
         if(this._currentlyHovered)
         {
            _loc3_ = this._currentlyHovered.getScreenPosition(this.mapView).distanceTo(param1,param2);
            if(_loc3_ <= this._currentlyHovered.clickRadius)
            {
               return true;
            }
            this._currentlyHovered.mouseOut();
            this._currentlyHovered = null;
         }
         var _loc5_:int = int(this._hittestArray.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = this._hittestArray[_loc6_];
            _loc3_ = _loc4_.getScreenPosition(this.mapView).distanceTo(param1,param2);
            if(_loc3_ <= _loc4_.clickRadius)
            {
               _loc4_.mouseOver();
               this._currentlyHovered = _loc4_;
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      public function hittestNormalClick(param1:int, param2:int) : Boolean
      {
         var _loc4_:MouseHitAreaTrait = null;
         var _loc7_:PointLite = null;
         var _loc8_:Number = NaN;
         var _loc9_:PointLite = null;
         var _loc10_:PointLite = null;
         if(this.mapView == null || this._map == null)
         {
            return false;
         }
         var _loc3_:int = int(this._hittestArray.length);
         var _loc5_:Ship = this._map.hero;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = this._hittestArray[_loc6_];
            if(_loc4_.owner.id != Hero.userID && _loc4_.enabled.value)
            {
               _loc7_ = _loc4_.getScreenPosition(this.mapView);
               _loc8_ = _loc7_.distanceTo(param1,param2);
               if(_loc8_ <= _loc4_.clickRadius)
               {
                  if(_loc4_.isLockTrigger && _loc4_.owner.getFirstTrait(AttackTargetTrait) != null)
                  {
                     if(this.lockedTarget != _loc4_.owner)
                     {
                        if(!(_loc4_.owner is Ship))
                        {
                           this._map.lockManager.target = _loc4_.owner;
                        }
                        else
                        {
                           this._map.lockManager.target = null;
                        }
                        if(_loc5_)
                        {
                           _loc9_ = _loc4_.owner.position;
                           _loc10_ = _loc5_.position;
                           if(_loc10_ != null && _loc9_ != null)
                           {
                              GameFacade.getInstance().sendNotification(MapAssetNotification.TRY_TO_SELECT_MAPASSET,[_loc4_.owner.id,_loc9_.x,_loc9_.y,param1,param2,_loc7_.x,_loc7_.y,_loc4_.clickRadius]);
                           }
                        }
                     }
                  }
                  else
                  {
                     _loc4_.mouseClick();
                  }
                  return true;
               }
            }
            _loc6_++;
         }
         return false;
      }
      
      public function hittestDoubleClick(param1:int, param2:int) : Boolean
      {
         var _loc4_:MouseHitAreaTrait = null;
         var _loc5_:Number = NaN;
         if(this.mapView == null || this._map == null)
         {
            return false;
         }
         var _loc3_:MapEntity = this.lockedTarget;
         if(_loc3_)
         {
            _loc4_ = _loc3_.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
            if(_loc4_ == null)
            {
               return false;
            }
            _loc5_ = _loc4_.getScreenPosition(this.mapView).distanceTo(param1,param2);
            if(_loc5_ <= _loc4_.clickRadius)
            {
               GameFacade.getInstance().sendNotification(MapAssetNotification.ATTACK_MAP_ASSET,_loc3_);
               return true;
            }
         }
         return false;
      }
      
      private function handleTraitAdded(param1:MouseHitAreaTrait) : void
      {
         this.sortInHittest2DArray(param1);
      }
      
      private function handleTraitRemoved(param1:MouseHitAreaTrait) : void
      {
         var _loc2_:int = this._hittestArray.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._hittestArray.splice(_loc2_,1);
         }
         if(this._currentlyHovered == param1)
         {
            this._currentlyHovered.mouseOut();
            this._currentlyHovered = null;
         }
         if(this._map.lockManager.target == param1.owner)
         {
            this._map.lockManager.target = null;
         }
      }
      
      private function sortInHittest2DArray(param1:MouseHitAreaTrait) : void
      {
         this._hittestArray.push(param1);
         this._hittestArray.sort(this.sortOnClickPriority);
      }
      
      private function get lockedTarget() : MapEntity
      {
         if(this._map)
         {
            return this._map.lockManager.target;
         }
         return null;
      }
      
      private function sortOnClickPriority(param1:MouseHitAreaTrait, param2:MouseHitAreaTrait) : int
      {
         return param2.clickPriority - param1.clickPriority;
      }
      
      public function hoverOut() : void
      {
         if(this._currentlyHovered)
         {
            this._currentlyHovered.mouseOut();
            this._currentlyHovered = null;
         }
      }
      
      private function get mapView() : IMapView
      {
         return ScreenManager.getInstance().mapView;
      }
      
      public function get currentlyHovered() : MouseHitAreaTrait
      {
         return this._currentlyHovered;
      }
   }
}

