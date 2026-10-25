package net.bigpoint.darkorbit.mvc.hintSystem.controller.simpleWindow
{
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.com.module.HintWindowModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemContentProvider;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HintSystemConvertSimpleWindowIDToCommandCommand extends DOAbstractSimpleCommand
   {
      
      public function HintSystemConvertSimpleWindowIDToCommandCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = String(param1.getBody());
         param1.setBody(new HintWindowAddComand(new HintWindowModule(HintSystemContentProvider.getByWindowName(_loc2_))));
      }
   }
}

