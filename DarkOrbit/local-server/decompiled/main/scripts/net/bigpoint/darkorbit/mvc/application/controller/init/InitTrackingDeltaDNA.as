package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.deltadna.TrackingDeltaDNA;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitTrackingDeltaDNA extends SimpleCommand
   {
      
      public function InitTrackingDeltaDNA()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         var _loc3_:Boolean = !Settings.isTestInstance();
         new TrackingDeltaDNA(_loc3_,Hero.userID,Settings.instanceID,Hero.sessionID,Settings.platform);
         TrackingDeltaDNA._instance.setStage(_loc2_.stage);
         TrackingDeltaDNA._instance.TrackClientDevice();
      }
   }
}

