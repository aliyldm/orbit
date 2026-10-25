package net.bigpoint.darkorbit.net.netty.handlers.spaceSearch
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchRequest;
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.UpdateSpaceSearchKeyCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateSpaceSearchKeyCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UpdateSpaceSearchKeyCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:SpaceSearchRequest = null;
         var _loc2_:UpdateSpaceSearchKeyCommand = param1.getBody() as UpdateSpaceSearchKeyCommand;
         if(_loc2_)
         {
            _loc3_ = new SpaceSearchRequest();
            _loc3_.action = SpaceSearchRequest.ACTION_ssAtlas;
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc3_);
         }
      }
   }
}

