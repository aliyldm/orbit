package net.bigpoint.darkorbit.mvc.battleStation.controller
{
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CloseBuildingUIBubbleCommand extends DOAbstractSimpleCommand
   {
      
      public function CloseBuildingUIBubbleCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         var _loc3_:ClickIconTrait = screenManager.map.getTraitById(_loc2_,ClickIconTrait) as ClickIconTrait;
         if(_loc3_)
         {
            _loc3_.handleActionAvailableCommand(false);
         }
      }
   }
}

