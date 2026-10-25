package net.bigpoint.darkorbit.loadingscreen.mvc.application.controller
{
   import net.bigpoint.darkorbit.loadingscreen.GameclientLoaderApplication;
   import net.bigpoint.darkorbit.loadingscreen.application.ApplicationFacade;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.notifications.ApplicationNotification;
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.view.StageMediator;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class ViewPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function ViewPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:GameclientLoaderApplication = param1.getBody() as GameclientLoaderApplication;
         facade.registerMediator(new StageMediator(_loc2_.stage,_loc2_));
         var _loc3_:CustomEvent = new CustomEvent("13584647345271048270");
         ApplicationFacade(facade).appWindow.dispatchEvent(_loc3_);
         sendNotification(ApplicationNotification.INIT_APPLICATION);
      }
   }
}

import flash.events.Event;

class CustomEvent extends Event
{
   
   public function CustomEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
   {
      super(param1,param2,param3);
   }
   
   override public function toString() : String
   {
      return "48584613118708739440";
   }
   
   override public function clone() : Event
   {
      return new CustomEvent(this.type);
   }
}
