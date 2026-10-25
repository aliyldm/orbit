package net.bigpoint.darkorbit.managers.hotkeysHandlers.gameplay
{
   import flash.events.KeyboardEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.EggTriggerRequest;
   import net.bigpoint.darkorbit.managers.hotkeysHandlers.general.AbstractKeyboardEventHandler;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   
   public class EasterEggEventKeyboardHandler extends AbstractKeyboardEventHandler
   {
      
      public static const instance:EasterEggEventKeyboardHandler = new EasterEggEventKeyboardHandler();
      
      private static var rainbowEasterEggIndex:int = 0;
      
      private const RAINBOW_EASTEREGG_STRING:String = "iwantrainbows";
      
      public function EasterEggEventKeyboardHandler()
      {
         super();
      }
      
      override public function handle(param1:KeyboardEvent) : void
      {
         if(String.fromCharCode(param1.charCode) == this.RAINBOW_EASTEREGG_STRING.charAt(rainbowEasterEggIndex))
         {
            ++rainbowEasterEggIndex;
            if(rainbowEasterEggIndex == this.RAINBOW_EASTEREGG_STRING.length)
            {
               gameFacade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new EggTriggerRequest(EggTriggerRequest.EGGTRIGGERTYPE_RAINBOW_LASER));
               GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("msg_easter_egg_found")));
               rainbowEasterEggIndex = 0;
            }
         }
         else
         {
            rainbowEasterEggIndex = 0;
         }
      }
   }
}

