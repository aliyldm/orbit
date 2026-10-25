package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model
{
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisInventoryCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CannonSynthesisInventoryCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function CannonSynthesisInventoryCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SynthesisInventoryCommand = param1.getBody() as SynthesisInventoryCommand;
         CannonSynthesisProxy.getProxy(GameFacade.getInstance()).rcvInventoryRequest(_loc2_);
      }
   }
}

