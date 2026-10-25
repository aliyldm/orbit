package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetUpdateShield extends DOAbstractSimpleCommand
   {
      
      public function MapAssetUpdateShield()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = int(param1.getBody()[0]);
         var _loc3_:HPTrait = map.getTraitById(_loc2_,HPTrait) as HPTrait;
         if(_loc3_)
         {
            _loc3_.shield.value = param1.getBody()[1];
            _loc3_.maxShield.value = param1.getBody()[2];
         }
      }
   }
}

