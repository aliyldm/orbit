package net.bigpoint.darkorbit.mvc.commandCenter.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CommandCenterTriggerActionCommand extends DOAbstractSimpleCommand
   {
      
      private static const actionLookup:Object = {};
      
      actionLookup["payment"] = handlePayment;
      actionLookup["link"] = handleLink;
      
      public function CommandCenterTriggerActionCommand()
      {
         super();
      }
      
      private static function handlePayment(param1:XML) : void
      {
         var _loc2_:String = String(param1.attribute("package"));
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP_WITH_LINK,[_loc2_]);
      }
      
      private static function handleLink(param1:XML) : void
      {
         var _loc2_:String = param1.attribute("href");
         JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_OPENER_TO_URL,[_loc2_]);
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:XML = null;
         super.execute(param1);
         var _loc2_:XML = param1.getBody() as XML;
         var _loc3_:XMLList = _loc2_.children();
         if(_loc3_)
         {
            for each(_loc4_ in _loc3_)
            {
               this.triggerAction(_loc4_);
            }
         }
      }
      
      private function triggerAction(param1:XML) : String
      {
         var _loc2_:String = String(param1.localName());
         if(actionLookup[_loc2_])
         {
            actionLookup[_loc2_](param1);
         }
         return _loc2_;
      }
   }
}

