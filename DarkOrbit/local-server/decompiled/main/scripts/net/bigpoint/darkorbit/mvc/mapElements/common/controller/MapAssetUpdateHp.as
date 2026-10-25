package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetUpdateHp extends DOAbstractSimpleCommand
   {
      
      public function MapAssetUpdateHp()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = int(param1.getBody()[0]);
         var _loc3_:int = int(param1.getBody()[1]);
         var _loc4_:int = int(param1.getBody()[2]);
         var _loc5_:int = int(param1.getBody()[3]);
         var _loc6_:int = int(param1.getBody()[4]);
         var _loc7_:HPTrait = map.getTraitById(_loc2_,HPTrait) as HPTrait;
         if(_loc7_)
         {
            _loc7_.maxHP.value = _loc4_;
            _loc7_.hp.value = _loc3_;
            _loc7_.nanohullMaxHP.value = _loc6_;
            _loc7_.nanohullHP.value = _loc5_;
         }
      }
   }
}

