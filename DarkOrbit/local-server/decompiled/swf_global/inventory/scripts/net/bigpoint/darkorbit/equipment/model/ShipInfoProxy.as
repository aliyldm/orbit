package net.bigpoint.darkorbit.equipment.model
{
   import net.bigpoint.darkorbit.equipment.model.VO.ShipInfoVO;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class ShipInfoProxy extends Proxy
   {
      
      private static var _owned:Vector.<ShipInfoVO>;
      
      private static var _notOwned:Vector.<ShipInfoVO>;
      
      public static const NAME:String = "ShipInfoProxy";
      
      public function ShipInfoProxy()
      {
         super(NAME);
      }
      
      public function init() : void
      {
         _notOwned = new Vector.<ShipInfoVO>();
         _owned = new Vector.<ShipInfoVO>();
      }
      
      public function add(param1:Object) : void
      {
         var _loc2_:ShipInfoVO = new ShipInfoVO(param1);
         if(_loc2_.isOwned())
         {
            _owned.push(_loc2_);
         }
         else
         {
            _notOwned.push(_loc2_);
         }
      }
      
      public function getOwnedByHangarID(param1:String) : ShipInfoVO
      {
         var _loc2_:uint = _owned.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(_owned[_loc3_].hangarID == param1)
            {
               return _owned[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getNotOwnedByHangarID(param1:String) : ShipInfoVO
      {
         var _loc2_:uint = _notOwned.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(_notOwned[_loc3_].hangarID == param1)
            {
               return _notOwned[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function get owned() : Vector.<ShipInfoVO>
      {
         return _owned;
      }
      
      public function get notOwned() : Vector.<ShipInfoVO>
      {
         return _notOwned;
      }
   }
}

