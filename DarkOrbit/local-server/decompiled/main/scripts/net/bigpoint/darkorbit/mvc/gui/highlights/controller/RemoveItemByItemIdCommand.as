package net.bigpoint.darkorbit.mvc.gui.highlights.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RemoveItemByItemIdCommand extends DOAbstractSimpleCommand
   {
      
      public function RemoveItemByItemIdCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = param1.getBody() as String;
         var _loc3_:HighlightProxy = retrieveProxy(HighlightProxy.NAME) as HighlightProxy;
         _loc3_.removeAllHighlightersByItem(_loc2_);
      }
   }
}

