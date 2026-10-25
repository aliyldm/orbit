package net.bigpoint.darkorbit.mvc.battleStation.controller
{
   import net.bigpoint.darkorbit.com.module.AssetInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateBattleStationModuleView extends DOAbstractSimpleCommand
   {
      
      public function UpdateBattleStationModuleView()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetInfoCommand = param1.getBody() as AssetInfoCommand;
         var _loc3_:BattleStationModule = screenManager.map.getEntityById(_loc2_.assetId) as BattleStationModule;
         if(_loc3_)
         {
            _loc3_.update(_loc2_.designId,_loc2_.expansionStage);
         }
      }
   }
}

