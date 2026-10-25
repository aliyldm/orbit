package net.bigpoint.darkorbit.map.model.env.homebase
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.QuestGiverApproachedRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   
   public class QuestGiver extends MapEntity
   {
      
      public function QuestGiver(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"questgiver_" + param1.designId,UberAssetsLib.LIB_DEFAULT,param1.showBubble ? this.handleIconClick : null,null,param1.userName);
         var _loc2_:ClickIconTrait = getFirstTrait(ClickIconTrait) as ClickIconTrait;
         if(_loc2_)
         {
            _loc2_.disabledSignal.add(this.handleIconDisabled);
         }
      }
      
      private function handleIconClick() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.OPEN_QUEST_WINDOW,id);
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new QuestGiverApproachedRequest(id));
         GameFacade.getInstance().sendNotification(QuestGiverWindowNotification.REFRESH_CURRENTLY_SELECTED_QUEST_DETAILS);
      }
      
      private function handleIconDisabled() : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.CLOSE_QUEST_WINDOW);
      }
   }
}

