package net.bigpoint.darkorbit.map.model.traits.clickIcon.action
{
   import net.bigpoint.darkorbit.com.module.MapAssetActivationRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   
   public class DefaultClickIconEntityAction implements IMapEntityAction
   {
      
      public function DefaultClickIconEntityAction()
      {
         super();
      }
      
      public function execute(param1:MapEntity) : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new MapAssetActivationRequest(param1.id));
      }
   }
}

