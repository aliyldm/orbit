package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.controller
{
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.BonusCalendarProxy;
   import net.bigpoint.darkorbit.loadingscreen.utils.Session;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class LoginBonusBookCommand extends SimpleCommand
   {
      
      public function LoginBonusBookCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BonusCalendarProxy = facade.retrieveProxy(BonusCalendarProxy.NAME) as BonusCalendarProxy;
         if(_loc2_.loginBonusActive)
         {
            this.dailyLoginBonusBook();
         }
      }
      
      private function dailyLoginBonusBook() : void
      {
         var _loc3_:Loader = null;
         var _loc1_:String = Session.host + "flashAPI/dailyLogin.php?doBook=1";
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         _loc2_.method = URLRequestMethod.POST;
         _loc3_ = new Loader();
         _loc3_.load(_loc2_);
      }
   }
}

