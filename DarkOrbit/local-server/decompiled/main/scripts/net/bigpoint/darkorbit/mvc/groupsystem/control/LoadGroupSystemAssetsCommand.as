package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class LoadGroupSystemAssetsCommand extends AsyncCommand
   {
      
      public function LoadGroupSystemAssetsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         sendNotification(AssetNotifications.LOAD_ASSET,["groupSystemShipIcons",this.onComplete,this.onError]);
      }
      
      private function onError(param1:*) : void
      {
      }
      
      private function onComplete(param1:FileCollectionFinisher) : void
      {
         commandComplete();
      }
   }
}

