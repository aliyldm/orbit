package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.confirmations.general
{
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HintSystemConfirmationButtonClickCommand extends HintSystemAbstractConfirmationClickCommand
   {
      
      public function HintSystemConfirmationButtonClickCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Array = param1.getBody() as Array;
         var _loc3_:IHintSystemContentDescription = _loc2_[0];
         var _loc4_:String = _loc2_[1];
         var _loc5_:HintSystemButtonActionDescriptionVO = _loc3_.content.getButtonDescription(_loc4_);
         if(_loc5_)
         {
            registerAndExecuteCommand(_loc5_.command,_loc3_);
            executeExternalInterface(_loc5_);
         }
      }
   }
}

