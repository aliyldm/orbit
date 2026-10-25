package net.bigpoint.darkorbit.mvc.battleStation.controller
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class OpenBuildingUIBubbleCommand extends DOAbstractSimpleCommand
   {
      
      public function OpenBuildingUIBubbleCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:ClickIconTrait = null;
         var _loc2_:MapEntity = screenManager.map.getEntityById(param1.getBody() as int);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getFirstTrait(ClickIconTrait) as ClickIconTrait;
            if(_loc3_)
            {
               _loc3_.handleActionAvailableCommand(true);
            }
         }
      }
   }
}

