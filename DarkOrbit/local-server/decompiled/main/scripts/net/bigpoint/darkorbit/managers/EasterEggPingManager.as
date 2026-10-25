package net.bigpoint.darkorbit.managers
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.EggTriggerRequest;
   import net.bigpoint.darkorbit.com.module.PingCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class EasterEggPingManager
   {
      
      private static var _instance:EasterEggPingManager = null;
      
      private var upperLeftCornerClicked:Boolean = false;
      
      private var upperRightCornerClicked:Boolean = false;
      
      private var lowerLeftCornerClicked:Boolean = false;
      
      private var lowerRightCornerClicked:Boolean = false;
      
      public function EasterEggPingManager()
      {
         super();
      }
      
      public static function getInstance() : EasterEggPingManager
      {
         if(_instance == null)
         {
            _instance = new EasterEggPingManager();
         }
         return _instance;
      }
      
      public function checkPingPattern(param1:PointLite, param2:Map) : void
      {
         if(param1.x < param2.serious_width * 0.1 && param1.y < param2.serious_height * 0.1)
         {
            this.upperLeftCornerClicked = true;
         }
         else if(param1.x < param2.serious_width * 0.1 && param1.y > param2.serious_height * 0.9)
         {
            this.lowerLeftCornerClicked = true;
         }
         else if(param1.x > param2.serious_width * 0.9 && param1.y > param2.serious_height * 0.9)
         {
            this.lowerRightCornerClicked = true;
         }
         else if(param1.x > param2.serious_width * 0.9 && param1.y < param2.serious_height * 0.1)
         {
            this.upperRightCornerClicked = true;
         }
         else
         {
            this.reset();
         }
         if(this.upperLeftCornerClicked && this.upperRightCornerClicked && this.lowerLeftCornerClicked && this.lowerRightCornerClicked)
         {
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EggTriggerRequest(EggTriggerRequest.EGGTRIGGERTYPE_MINIMAP_PING));
            GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("msg_easter_egg_found")));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.3,param2.serious_height * 0.2));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.7,param2.serious_height * 0.2));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.5,param2.serious_height * 0.4));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.5,param2.serious_height * 0.5));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.5,param2.serious_height * 0.6));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.2,param2.serious_height * 0.6));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.3,param2.serious_height * 0.7));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.4,param2.serious_height * 0.8));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.5,param2.serious_height * 0.8));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.6,param2.serious_height * 0.8));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.7,param2.serious_height * 0.7));
            HandlerLookup.execute(new PingCommand(param2.serious_width * 0.8,param2.serious_height * 0.6));
            this.reset();
         }
      }
      
      private function reset() : void
      {
         this.upperLeftCornerClicked = false;
         this.upperRightCornerClicked = false;
         this.lowerLeftCornerClicked = false;
         this.lowerRightCornerClicked = false;
      }
   }
}

