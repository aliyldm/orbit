package net.bigpoint.darkorbit.mvc.wargame.model
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.WarGameLobbyStatusModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.wargame.control.WargameNotification;
   import net.bigpoint.darkorbit.mvc.wargame.model.data.WargameSingupModel;
   
   public class WargameLobbyProxy extends SimpleWindowProxy
   {
      
      public function WargameLobbyProxy(param1:String = null)
      {
         super(param1 || GuiConstants.WARGAME_LOBBY_WINDOW,new WargameSingupModel());
      }
      
      private function get model() : WargameSingupModel
      {
         return getData() as WargameSingupModel;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         sendNotification(WargameNotification.UPDATE_LOBBY);
      }
      
      public function updateRewards(param1:Vector.<RewardContentModule>) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         this.model.rewards = param1;
      }
      
      public function updateStatus(param1:WarGameLobbyStatusModule) : void
      {
         this.model.status = param1;
      }
   }
}

