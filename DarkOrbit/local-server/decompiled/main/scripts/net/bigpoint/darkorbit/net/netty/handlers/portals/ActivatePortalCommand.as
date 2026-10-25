package net.bigpoint.darkorbit.net.netty.handlers.portals
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.JumpInitiatedCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ActivatePortalCommand extends SimpleCommand
   {
      
      public function ActivatePortalCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:JumpInitiatedCommand = param1.getBody() as JumpInitiatedCommand;
         var _loc3_:MapEntity = ScreenManager.getInstance().map.getEntityById(_loc2_.gateId);
         if(_loc3_)
         {
            (_loc3_ as Portal).jump(10);
         }
         Main.scheduledDisconnect = true;
         if(_loc2_.mapId != 0)
         {
            Settings.nextMapID = _loc2_.mapId;
         }
      }
   }
}

