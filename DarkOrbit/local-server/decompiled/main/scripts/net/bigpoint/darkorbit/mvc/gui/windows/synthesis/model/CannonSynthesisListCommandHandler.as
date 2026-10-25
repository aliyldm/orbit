package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model
{
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisListCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CannonSynthesisListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function CannonSynthesisListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SynthesisListCommand = param1.getBody() as SynthesisListCommand;
         var _loc3_:CannonSynthesisProxy = CannonSynthesisProxy.getProxy(GameFacade.getInstance());
         _loc3_.rcvInitRequest(_loc2_);
      }
   }
}

