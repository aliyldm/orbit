package net.bigpoint.darkorbit.mvc.battleStation.controller
{
   import net.bigpoint.darkorbit.com.module.AssetInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateBattleStationView extends DOAbstractSimpleCommand
   {
      
      public function UpdateBattleStationView()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssetInfoCommand = param1.getBody() as AssetInfoCommand;
         var _loc3_:BattleStation = screenManager.map.getEntityById(_loc2_.assetId) as BattleStation;
         if(_loc3_)
         {
            _loc3_.updateVisuals(_loc2_.designId,_loc2_.expansionStage);
         }
      }
   }
}

