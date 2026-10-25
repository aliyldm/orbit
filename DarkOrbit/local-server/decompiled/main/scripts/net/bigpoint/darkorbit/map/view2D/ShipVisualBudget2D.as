package net.bigpoint.darkorbit.map.view2D
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   
   public final class ShipVisualBudget2D
   {
      
      private static var _hero:Ship;
      
      public static const RADIUS:Number = 900;
      
      public static const PET_RADIUS:Number = 800;
      
      public static const FULL_PLAYER_LIMIT:int = 50;
      
      public static const POLL_MS:int = 250;
      
      private static var _views:Dictionary = new Dictionary(true);
      
      private static var _allowed:Dictionary = new Dictionary(true);
      
      private static var _previousAllowed:Dictionary = new Dictionary(true);
      
      private static var _reducedShips:Dictionary = new Dictionary(true);
      
      private static var _candidates:Array = [];
      
      private static var _hiddenPetShips:Dictionary = new Dictionary(true);
      
      public function ShipVisualBudget2D()
      {
         super();
      }
      
      public static function register(param1:Ship2D) : void
      {
         if(!param1)
         {
            return;
         }
         _views[param1] = true;
      }
      
      public static function unregister(param1:Ship2D) : void
      {
         if(param1)
         {
            delete _views[param1];
         }
      }
      
      public static function clear() : void
      {
         _views = new Dictionary(true);
         _hiddenPetShips = new Dictionary(true);
         _hero = null;
         _allowed = new Dictionary(true);
         _previousAllowed = new Dictionary(true);
         _reducedShips = new Dictionary(true);
         _candidates.length = 0;
      }
      
      public static function begin(param1:Ship) : void
      {
         _hero = param1;
         _allowed = new Dictionary(true);
         _candidates.length = 0;
      }
      
      public static function consider(param1:Ship) : void
      {
         if(!eligible(param1) || !_hero)
         {
            return;
         }
         var _loc2_:AttackerTrait = param1.getFirstTrait(AttackerTrait) as AttackerTrait;
         if(Boolean(_loc2_) && Boolean(_loc2_.target) && _loc2_.target.owner === _hero)
         {
            _allowed[param1] = true;
            return;
         }
         var _loc3_:Number = param1.position.x - _hero.position.x;
         var _loc4_:Number = param1.position.y - _hero.position.y;
         var _loc5_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         if(_loc5_ <= RADIUS * RADIUS || _candidates.length < FULL_PLAYER_LIMIT)
         {
            _candidates.push({
               "ship":param1,
               "distanceSquared":_loc5_
            });
         }
      }
      
      public static function commit() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Ship = null;
         var _loc5_:Ship = null;
         var _loc6_:Ship2D = null;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         if(_candidates.length > FULL_PLAYER_LIMIT)
         {
            _candidates.sortOn("distanceSquared",Array.NUMERIC);
         }
         var _loc1_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _candidates.length && _loc1_ < FULL_PLAYER_LIMIT)
         {
            _loc4_ = _candidates[_loc2_].ship as Ship;
            if(_previousAllowed[_loc4_] === true)
            {
               _allowed[_loc4_] = true;
               _loc1_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _candidates.length && _loc1_ < FULL_PLAYER_LIMIT)
         {
            _loc5_ = _candidates[_loc2_].ship as Ship;
            if(_allowed[_loc5_] !== true)
            {
               _allowed[_loc5_] = true;
               _loc1_++;
            }
            _loc2_++;
         }
         _reducedShips = new Dictionary(true);
         for(_loc3_ in _views)
         {
            _loc6_ = _loc3_ as Ship2D;
            if(_loc6_)
            {
               if(_loc6_.ship is Pet)
               {
                  _loc8_ = _loc6_.ship.position.x - _hero.position.x;
                  _loc9_ = _loc6_.ship.position.y - _hero.position.y;
                  _loc10_ = _loc8_ * _loc8_ + _loc9_ * _loc9_ > PET_RADIUS * PET_RADIUS;
                  _hiddenPetShips[_loc6_.ship] = _loc10_;
                  _loc6_.setPetRangeHidden(_loc10_);
               }
               else if(eligible(_loc6_.ship))
               {
                  _loc7_ = _allowed[_loc6_.ship] !== true;
                  _loc6_.setReducedVisual(_loc7_);
                  if(_loc7_)
                  {
                     _reducedShips[_loc6_.ship] = true;
                  }
               }
            }
         }
         _previousAllowed = _allowed;
      }
      
      private static function eligible(param1:Ship) : Boolean
      {
         return param1 && param1 !== _hero && !param1.isHeroShip() && !param1.isNPC && !(param1 is Pet);
      }
      
      public static function isPetHidden(param1:Ship) : Boolean
      {
         return Boolean(param1) && _hiddenPetShips[param1] === true;
      }
      
      public static function isReduced(param1:Ship) : Boolean
      {
         return Boolean(param1) && _reducedShips[param1] === true;
      }
   }
}

