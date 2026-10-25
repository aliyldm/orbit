package net.bigpoint.darkorbit.mvc.application.controller
{
   import flash.display.Stage3D;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CheckCapibilitiesCommand extends DOAbstractAsyncCommand
   {
      
      public function CheckCapibilitiesCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(this.stage3D)
         {
            this.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.handleContext3DCreate);
            this.stage3D.addEventListener(ErrorEvent.ERROR,this.handleContext3DError);
            this.stage3D.requestContext3D();
         }
         else
         {
            Settings.driverInfo = "stage3D n/a";
            commandComplete();
         }
      }
      
      private function get stage3D() : Stage3D
      {
         return screenManager.stage.stage3Ds.length > 0 ? screenManager.stage.stage3Ds[0] : null;
      }
      
      private function handleContext3DError(param1:ErrorEvent) : void
      {
         this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContext3DCreate);
         this.stage3D.removeEventListener(ErrorEvent.ERROR,this.handleContext3DError);
         Settings.driverInfo = null;
         commandComplete();
      }
      
      private function handleContext3DCreate(param1:Event) : void
      {
         this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.handleContext3DCreate);
         this.stage3D.removeEventListener(ErrorEvent.ERROR,this.handleContext3DError);
         if(this.stage3D.context3D)
         {
            Settings.driverInfo = this.stage3D.context3D.driverInfo;
            Settings.stage3DProfile = this.stage3D.context3D.hasOwnProperty("profile") ? this.stage3D.context3D["profile"] : "n/a";
            if(this.stage3D.context3D.dispose.length == 0)
            {
               this.stage3D.context3D.dispose();
            }
            else
            {
               this.stage3D.context3D.dispose(false);
            }
         }
         commandComplete();
      }
   }
}

