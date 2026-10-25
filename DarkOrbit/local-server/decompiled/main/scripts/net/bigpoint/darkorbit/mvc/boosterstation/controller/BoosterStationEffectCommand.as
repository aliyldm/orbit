package net.bigpoint.darkorbit.mvc.boosterstation.controller
{
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.boosterstation.view.BoosterStation;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class BoosterStationEffectCommand extends DOAbstractSimpleCommand
   {
      
      public function BoosterStationEffectCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:VisualModifierCommand = param1.getBody() as VisualModifierCommand;
         var _loc3_:BoosterStation = screenManager.map.getEntityById(_loc2_.userId) as BoosterStation;
         if(_loc3_)
         {
            if(_loc2_.activated)
            {
               _loc3_.activate(Math.ceil(_loc2_.attribute * 1.2));
            }
            else
            {
               _loc3_.deactivate();
            }
         }
      }
   }
}

